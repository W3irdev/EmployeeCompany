<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="com.jacaranda.models.Employee"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.jacaranda.repository.dbRepository"%>
<%@page import="com.jacaranda.models.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

</head>
<body>

<%
// Variable para mostrar mensajes en la pagina
String message ="";

	
	if(request.getParameter("login")!=null && request.getParameter("login").equals("login")){
		// hacemos una consulta a la base de datos para comprobar que el usuario exista
		try{
		//User user = dbRepository.find(User.class, request.getParameter("user"));
		Employee user = dbRepository.getUserEmployee(Employee.class, request.getParameter("user"));
		
		// Comparamos la password de la base de datos con la del campo password del formulario
		if(DigestUtils.md5Hex(request.getParameter("password")).equals(user.getPassword()) ){
			// Creamos una session con el rol del usuario y lo redireccionamos a la lista de empleados.
			session.setAttribute("userSession", user.getRole());
			session.setAttribute("empleado", user);
			response.sendRedirect("employee/listEmployee.jsp");
			return;
		// En caso de que la contrasena no coincida lo mostramos por pantalla
		}else{
			message="La contraseña es incorrecta";
		}
		
		}catch(Exception e){
			message="Ese usuario no existe";
		}
		
	}else if(request.getParameter("register")!=null){
		response.sendRedirect("employee/addEmployee.jsp");
		return;
	}



%>

<%@ include file="navbar.jsp" %>

<div class="container">
<main><section>

<%if(session.getAttribute("userSession")==null){ %>
    <div class="appLogin">

        <form class="form-control" method="POST">
            <label for="user">Email:</label>
            <input type="text" name="user" id="user" placeholder="Usuario">
            <label for="password">Contraseña:</label>
            <input type="password" name="password" id="password" placeholder="Contraseï¿½a">
            <br>
            <button class="btn-info" name="login" value="login">Login</button>
            <button class="btn-info" name="register" value="register">Registrar</button>
        </form>
    </div>
</section></main>
</div>
<%}else{%>
	<h1>USUARIO IDENTIFICADO</h1>
	<form id="logout">
	<button class="btn-info" name="logout" value="logout">Deslogear</button>
	</form>
	
	<% 
	// Si queremos cambiar de usuario, deslogeamos y limpiamos la session.
	if(request.getParameter("logout")!=null && request.getParameter("logout").equals("logout")){
		session.invalidate();
		response.sendRedirect("#");
		return;
	}%>
	
<%}%>
	<%=message %>
</body>
</html>