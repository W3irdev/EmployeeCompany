<%@page import="com.jacaranda.exceptions.EmployeeCompanyException"%>
<%@page import="com.jacaranda.models.Employee"%>
<%@page import="com.jacaranda.repository.dbRepository"%>
<%@page import="com.jacaranda.models.Company"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Empleado</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

<%
	String message = "";
	ArrayList<Company> companies = null;
	if(companies==null){
		companies = (ArrayList<Company>) dbRepository.findAll(Company.class);
	}

	if(request.getParameter("submit")!= null && request.getParameter("submit").equals("submit") && request.getParameter("name")!=null && request.getParameter("surname")!=null && request.getParameter("email")!=null 
			&& request.getParameter("gender")!=null && request.getParameter("birthdate")!=null && request.getParameter("company")!=null){
			String name = request.getParameter("name");
			String surname = request.getParameter("surname");
			String email = request.getParameter("email");
			String gender = request.getParameter("gender");
			String birthdate = request.getParameter("birthdate");
			String company = request.getParameter("company");
			Company c = dbRepository.getInstance(Company.class, company);
			try{
				Employee newEmp = new Employee(name,surname,email,gender,birthdate,c);
				dbRepository.save(newEmp);
				message = "Usuario añadido con exito";
			}catch (EmployeeCompanyException ece){
				out.println(ece.getMessage());
			}catch (Exception e){
				out.println(e.getMessage());
			}
	} 
%>

<form>
  <div class="form-group row">
    <label for="name" class="col-4 col-form-label">Nombre</label> 
    <div class="col-8">
      <input id="name" name="name" placeholder="Nombre" type="text" class="form-control" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="surname" class="col-4 col-form-label">Apellidos</label> 
    <div class="col-8">
      <input id="surname" name="surname" placeholder="Apellidos" type="text" class="form-control" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="email" class="col-4 col-form-label">Email</label> 
    <div class="col-8">
      <input id="email" name="email" placeholder="Email" type="email" class="form-control" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="gender" class="col-4 col-form-label">Genero</label> 
    <div class="col-8">
      <input id="gender" name="gender" placeholder="Genero" type="text" class="form-control" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="birthdate" class="col-4 col-form-label">Fecha de nacimiento</label> 
    <div class="col-8">
      <input id="birthdate" name="birthdate" type="date" class="form-control" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañia</label> 
    <div class="col-8">
      <select id="company" name="company" class="custom-select" required="required">
      	<%for(Company c : companies){ %>
			<option value="<%= c.getName()%>"><%= c.getName()%></option>
      	<%} %>
        
      </select>
    </div>
  </div> 
  <div class="form-group row">
    <div class="offset-4 col-8">
      <button name="submit" type="submit" class="btn btn-primary" value="submit">Enviar</button>
    </div>
  </div>
</form>


</body>
</html>