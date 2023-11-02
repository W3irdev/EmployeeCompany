<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
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

<%
// Comprobamos que estamos logeado
if(session.getAttribute("userSession")!=null && session.getAttribute("userSession").equals("admin")){ %>
<body>

<%
	// Definimos las variables
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
	List<Company> companies = new ArrayList<Company>();
	try{
	// Inicializamos la lista de companias
	if(companies.isEmpty()){
		companies = dbRepository.findAll(Company.class);
	}
	}catch(Exception e){
		message = "No se encuentra las compañias";
	}


	try{
		// Al pasar de la pagina de usuarios a editar el usuario nos traemos su id y comprobamos y lo traemos de la base de datos.
		emp = dbRepository.find(Employee.class, Integer.valueOf(request.getParameter("id")));
		// Si existe inicializamos las variables.
		if(emp!=null){
			id = emp.getId();
			name = emp.getFirstName();
			surname = emp.getLastName();
			email = emp.getEmail();
			gender = emp.getGender();
			dateOfBirth = emp.getDateOfBirth();
			company = emp.getCompany();
			session.setAttribute("emp", emp);
		}
	}catch(Exception e){
		message = "No se encuentra ese empleado";
	}
	
	// Variable para comprobar diferencias
	Employee modEmp = null;

	try{
		// Cuando pulsamos el boton de editar, comprobamos que ningun campo quede vacio.
		if(request.getParameter("modSubmit")!=null && request.getParameter("name")!=null && request.getParameter("surname")!=null
				&& request.getParameter("email")!=null && request.getParameter("gender")!=null
				&& request.getParameter("birthdate")!=null && request.getParameter("company")!=null && Integer.valueOf(request.getParameter("idEmp"))!=-1){
			id = Integer.valueOf(request.getParameter("idEmp")); name = request.getParameter("name"); surname = request.getParameter("surname"); email = request.getParameter("email");
			gender = request.getParameter("gender"); 
			// Rescatamos de la base de datos la compania en forma de objeto de la lista de companias.
			company = dbRepository.getInstance(Company.class, request.getParameter("company"));
			dateOfBirth = Date.valueOf(request.getParameter("birthdate"));
			try{
				// Si todos los campos estan rellenos creamos el empleado que sera modificado, pero en una instancia nueva
				if(id!=-1 && !name.isBlank() && !surname.isBlank() && !email.isBlank() && !gender.isBlank() && company!=null){		
					modEmp = new Employee(id, name, surname, email, gender, request.getParameter("birthdate"), company);
				// Si el id del usuario que venia originalmente al pulsar el boton de editar en la lista coincide con el que va a ser modificado, llamamos a la funcion modificar.
				if(emp.getId()==modEmp.getId()){
					dbRepository.modify(modEmp);
					message="Modificado con exito";
				}else{
					message="La id original no coincide";
				}
				}else message = "Todos los campos deben tener valor";
			}catch(Exception e){
				message="No se ha podido modificar";
			}
		}
	}catch(Exception e){
		message = "Algo ha ido mal";
	}


%>
<%@ include file="../navbar.jsp" %>
<form>
<input id="id" name="idEmp" type="number" class="form-control" value="<%=id %>" required="required" readonly="readonly" hidden="true">
  <div class="form-group row">
    <label for="name" class="col-4 col-form-label">Nombre</label> 
    <div class="col-8">
      <input id="name" name="name" placeholder="Nombre" type="text" class="form-control" value="<%=name %>" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="surname" class="col-4 col-form-label">Apellidos</label> 
    <div class="col-8">
      <input id="surname" name="surname" placeholder="Apellidos" type="text" class="form-control" value="<%=surname %>" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="email" class="col-4 col-form-label">Email</label> 
    <div class="col-8">
      <input id="email" name="email" placeholder="Email" type="email" class="form-control" value="<%=email %>" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="gender" class="col-4 col-form-label">Genero</label> 
    <div class="col-8">
      <input id="gender" name="gender" placeholder="Genero" type="text" class="form-control" value="<%=gender %>" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="birthdate" class="col-4 col-form-label">Fecha de nacimiento</label> 
    <div class="col-8">
      <input id="birthdate" name="birthdate" type="date" class="form-control" value="<%=dateOfBirth %>" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañia</label> 
    <div class="col-8">
          <select id="company" name="company" class="custom-select" required="required">
      	<%for(Company c : companies){ %>
      		<%if(emp.getCompany().getId()==c.getId()){%>
      			<option value="<%= c.getName()%>" selected="selected"><%= c.getName()%></option>
      		<%}else{%>
			<option value="<%= c.getName()%>"><%= c.getName()%></option>
      		<%}%>
      	<%} %>
        
      </select>
    </div>
  </div> 
  <div class="form-group row">
    <div class="offset-4 col-8">
      <button name="modSubmit" type="submit" class="btn btn-primary" value="mod">Editar</button>
    </div>
  </div>
</form>
<%=message %>

</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe ser administrador");  %>

</html>