<%@page import="java.sql.Date"%>
<%@page import="com.jacaranda.exceptions.EmployeeCompanyException"%>
<%@page import="com.jacaranda.models.Employee"%>
<%@page import="com.jacaranda.repository.dbRepository"%>
<%@page import="com.jacaranda.models.Company"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="ISO-8859-1">
<title>Add Empleado</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<%
//Comprobamos la session, si somos usuario o admin muestra la pagina, en caso de que no seamos ninguno nos pedira que logeemos
if(session.getAttribute("userSession")!=null && session.getAttribute("userSession").equals("admin")){ %>

<body>

<%
	//Definimos las variables
	// Comprobamos si hay algun empleado guardado en session, esto lo hago para comprobar que no se manipula mas tarde el id pasado por parametro
	Employee emp = session.getAttribute("emp")!=null?(Employee)session.getAttribute("emp"):null;
	int id = -1;
	String message = "";
	String name= "";
	String surname = "";
	String email = "";
	String gender = "";
	Date dateOfBirth = null;
	Company company = null;
	String companyName = "";
	ArrayList<Company> companies = null;
	try{
		// Inicializamos la lista de companias
	if(companies==null){
		companies = (ArrayList<Company>) dbRepository.findAll(Company.class);
	}
	}catch(Exception e){
		message = "No se encuentra las compañias";
	}


	try{
		// Cargamos el usuario que vamos a eliminar.
		if(emp==null) emp = dbRepository.find(Employee.class, Integer.valueOf(request.getParameter("id")));
		
	}catch(Exception e){
		message = "No se encuentra ese empleado";
	}
	
	// Si existe inicializamos las variables y un atributo de sesion para comprobar mas tarde que no se altera el id.
	if(emp!=null){
		id = emp.getId();
		name = emp.getFirstName();
		surname = emp.getLastName();
		email = emp.getEmail();
		gender = emp.getGender();
		dateOfBirth = emp.getDateOfBirth();
		
		company = emp.getCompany();
		companyName = emp.getCompany().getName();
		session.setAttribute("emp", emp);
	}
	

	Employee delEmp = null;

	try{
		
		if(request.getParameter("delSubmit")!=null){
			try{
				// Comprobamos que los campos esten rellenos y creamos la instancia del empleado que se va a eliminar
				if(id!=-1 && !name.isBlank() && !surname.isBlank() && !email.isBlank() && !gender.isBlank() && company!=null){		
					delEmp = new Employee(id, name, surname, email, gender, String.valueOf(dateOfBirth), company);
				// Si coincide lo eliminamos, si no avisamos que se ha modificado la id.
				if(emp.getId()==delEmp.getId()){
					
					dbRepository.delete(emp);
					message="Borrado con exito";
					session.removeAttribute("emp");
				}else{
					message="La id original no coincide";
					session.removeAttribute("emp");
				}
				}else message = "Todos los campos deben tener valor";
			}catch(Exception e){
				message="No se ha podido modificar";
				session.removeAttribute("emp");
			}
		}
	}catch(Exception e){
		message = "Algo ha ido mal";
		session.removeAttribute("emp");
	}


%>
<%@ include file="../navbar.jsp" %>
<form>
<input id="id" name="idEmp" type="number" class="form-control" value="<%=id %>" required="required" disabled readonly="readonly" hidden="true">
  <div class="form-group row">
    <label for="name" class="col-4 col-form-label">Nombre</label> 
    <div class="col-8">
      <input id="name" name="name" placeholder="Nombre" type="text" class="form-control" value="<%=name %>" required="required" disabled>
    </div>
  </div>
  <div class="form-group row">
    <label for="surname" class="col-4 col-form-label">Apellidos</label> 
    <div class="col-8">
      <input id="surname" name="surname" placeholder="Apellidos" type="text" class="form-control" value="<%=surname %>" required="required" disabled>
    </div>
  </div>
  <div class="form-group row">
    <label for="email" class="col-4 col-form-label">Email</label> 
    <div class="col-8">
      <input id="email" name="email" placeholder="Email" type="email" class="form-control" value="<%=email %>" required="required" disabled>
    </div>
  </div>
  <div class="form-group row">
    <label for="gender" class="col-4 col-form-label">Genero</label> 
    <div class="col-8">
      <input id="gender" name="gender" placeholder="Genero" type="text" class="form-control" value="<%=gender %>" required="required" disabled>
    </div>
  </div>
  <div class="form-group row">
    <label for="birthdate" class="col-4 col-form-label">Fecha de nacimiento</label> 
    <div class="col-8">
      <input id="birthdate" name="birthdate" type="date" class="form-control" value="<%=dateOfBirth %>" required="required" disabled>
    </div>
  </div>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañia</label> 
    <div class="col-8">
          <input id="company" name="company" type="text" class="form-control" value="<%=companyName%>" required="required" disabled>
        
      </select>
    </div>
  </div> 
  <div class="form-group row">
    <div class="offset-4 col-8">
      <button name="delSubmit" type="submit" class="btn btn-primary" value="del">Borrar</button>
    </div>
  </div>
</form>
<%=message %>

</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe ser administrador");  %>
</html>