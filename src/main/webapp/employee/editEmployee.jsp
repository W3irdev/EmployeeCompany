<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
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
<html lang="es">
<head>
<meta charset="ISO-8859-1">
<title>Add Empleado</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<%@ include file="../navbar.jsp" %>
<%
//Definimos las variables
	// Comprobamos si hay algun empleado guardado en session, esto lo hago para comprobar que no se manipula mas tarde el id pasado por parametro
	
	int id = -1;
	String message = "";
	String name= "";
	String surname = "";
	String email = "";
	String gender = "";
	Date dateOfBirth = null;
	Company company = null;
	String rol = "";
	String password = "";
	List<Company> companies = new ArrayList<Company>();
	String disabled= "";
	String readonly ="";
boolean validate = session.getAttribute("validate")!=null?true:false;
Employee emp = session.getAttribute("emp")!=null?(Employee)session.getAttribute("emp"):null;

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
		rol = emp.getRole();
		password = emp.getPassword();
		
		session.setAttribute("emp", emp);
	}
}catch(Exception e){
	message = "No se encuentra ese empleado";
}


if(request.getParameter("inputPassword")!=null){
	validate = DigestUtils.md5Hex(request.getParameter("inputPassword")).equals(emp.getPassword());
	session.setAttribute("validate", validate);
}

if(session.getAttribute("userSession")!=null && session.getAttribute("userSession").equals("user") && !validate){%>
	<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title text-center">Verificacion</h5>
          <form>
          <input id="id" name="id" type="number" class="form-control" value="<%=id %>" required="required" readonly="readonly" hidden="true">
            <div class="form-group">
              <label for="inputPassword">Contraseņa</label>
              <input type="password" class="form-control" name="inputPassword" id="inputPassword" placeholder="Verifica tu contraseņa" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Aceptar</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<% }
// Comprobamos que estamos logeado
else if(session.getAttribute("userSession")!=null && (session.getAttribute("userSession").equals("admin") || validate)){ %>

<%
	
	if(session.getAttribute("userSession").equals("user")) {
		disabled = "disabled='disabled'";
		readonly = "readonly='readonly'";
	}
	try{
	// Inicializamos la lista de companias
	if(companies.isEmpty()){
		companies = dbRepository.findAll(Company.class);
	}
	}catch(Exception e){
		message = "No se encuentra las compaņias";
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
					if(session.getAttribute("userSession").equals("admin") && request.getParameter("rol")!=null) rol = request.getParameter("rol");
					if(session.getAttribute("userSession").equals("admin")){
						
						modEmp = new Employee(id, name, surname, email, gender, request.getParameter("birthdate"), company, rol, password);
					}else if(session.getAttribute("userSession").equals("user")){
							if(request.getParameter("password")== null && request.getParameter("rPassword")==null){
								modEmp = new Employee(id, name, surname, email, gender, request.getParameter("birthdate"), company, rol, password);
							}else if(request.getParameter("password")!= null && request.getParameter("rPassword")!=null && request.getParameter("password").equals(request.getParameter("rPassword"))){
								password = DigestUtils.md5Hex(request.getParameter("password"));
								modEmp = new Employee(id, name, surname, email, gender, request.getParameter("birthdate"), company, rol, password);
							}
						
					}
				// Si el id del usuario que venia originalmente al pulsar el boton de editar en la lista coincide con el que va a ser modificado, llamamos a la funcion modificar.
				if(emp.getId()==modEmp.getId()){
					dbRepository.modify(modEmp);
					message="Modificado con exito";
					session.removeAttribute("validate");
				}else{
					message="La id original no coincide";
				}
				}else message = "Todos los campos deben tener valor";
			}catch(Exception e){
				message="No se ha podido modificar";
				session.removeAttribute("validate");
			}
		}
	}catch(Exception e){
		message = "Algo ha ido mal";
		session.removeAttribute("validate");
	}


%>

<form>
<input id="id" name="id" type="number" class="form-control" value="<%=id %>" required="required" readonly="readonly" hidden="true">
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
      <input id="email" name="email" placeholder="Email" type="email" class="form-control" value="<%=email %>" <%=readonly %> required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="gender" class="col-4 col-form-label">Genero</label> 
    <div class="col-8">
      <input id="gender" name="gender" placeholder="Genero" type="text" class="form-control" value="<%=gender %>" <%=readonly %> required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="birthdate" class="col-4 col-form-label">Fecha de nacimiento</label> 
    <div class="col-8">
      <input id="birthdate" name="birthdate" type="date" class="form-control" value="<%=dateOfBirth %>" required="required">
    </div>
  </div>
  <%if(session.getAttribute("userSession").equals("admin")){ %>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compaņia</label> 
    <div class="col-8">
          <select id="company" name="company" class="custom-select" required="required">
      	<%for(Company c : companies){ %>
      		<%if(emp.getCompany().getId()==c.getId()){%>
      			<option value="<%= c.getName()%>" selected="selected"><%= c.getName()%></option>
      		<%}else{%>
			<option value="<%= c.getName()%>"><%= c.getName()%></option>
      		<%}%>
      	<%}%>
      </select>
      	
  	<%}else{ %>
          <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compaņia</label> 
    <div class="col-8">
		<input id="company" name="company" type="text"  readonly="readonly" class="form-control" value=<%=emp.getCompany().getName() %>>
    </div>
  </div> 
  <%} %>
    </div>
  </div> 
  
  <%if(session.getAttribute("userSession").equals("admin")){ %>
  <div class="form-group row">
    <label for="rol" class="col-4 col-form-label">Rol</label> 
    <div class="col-8">
          <select id="rol" name="rol" class="custom-select" required="required">
    		<option value="user">Usuario</option>
    		<option value="admin">Administrador</option>    
	      </select>
    </div>
  </div> 
  <%} %>

  <div class="form-group row">
    <label for="password" class="col-4 col-form-label">Contraseņa nueva</label> 
    <div class="col-8">
		<input id="password" name="password" placeholder="******" type="password" class="form-control">
    </div>
  </div> 
   <%if(session.getAttribute("userSession").equals("user")) {%>
  <div class="form-group row">
    <label for="password" class="col-4 col-form-label">Repita Contraseņa</label> 
    <div class="col-8">
      <input id="password" name="rPassword" placeholder="******" type="password" class="form-control">
    </div>
  </div>
  <%} %>
  <div class="form-group row">
    <div class="offset-4 col-8">
      <button name="modSubmit" type="submit" class="btn btn-primary" value="mod">Editar</button>
    </div>
  </div>
</form>
<%=message %>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe estar logeado");  %>

</html>