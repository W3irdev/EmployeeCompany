<%@page import="com.jacaranda.models.CompanyProject"%>
<%@page import="com.jacaranda.models.Company"%>
<%@page import="java.util.ArrayList"%>

<%@page import="com.jacaranda.models.Employee"%>

<%@page import="java.util.List"%>

<%@page import="com.jacaranda.repository.dbRepository"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Listado cines</title>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">


</head>
<%
// Comprobamos la session, si somos usuario o admin muestra la pagina, en caso de que no seamos ninguno nos pedira que logeemos
if(session.getAttribute("userSession") != null && (session.getAttribute("userSession").equals("user") || session.getAttribute("userSession").equals("admin"))){ %>
<%@ include file="/navbar.jsp" %>
<body>



	<%
	// Variables
	ArrayList<Company> result = null;
	String message = "";
			try{
				// Inicializamos la lista de companias
				result = (ArrayList<Company>) dbRepository.findAll(Company.class);
			}catch(Exception e){
				response.sendRedirect("/error500.jsp?msg="+e.getMessage());
				return;
		

			}

	%>


	<table class="table">
	
	<%for(Company c : result){ %>
	<tr>
	<th>Nombre</th>
	<th>Num Empleados</th>
	<th>Numero de proyectos</th>
	</tr>
	<tr>
	<td>Nombre: <%=c.getName() %></td>
	<td>Numero empleados: <%=c.getEmployeeList().size() %></td>
	<td>Numero de proyectos: <%=c.getCompanyProject().size() %></td>
	</tr>
	<tr><td>
	<table>
	<tr><th>Empleados</th></tr>
	<% for(Employee e : c.getEmployeeList()){ %>
	<tr>
	<td>Nombre <%= e.getFirstName() %></td>
	<td>Apellidos <%= e.getLastName() %></td>
	</tr>
	<%} %>
	</table>
	</td></tr>
	<tr><td>
	<table>
	<tr><th>Proyectos</th></tr>
	<% for(CompanyProject p : c.getCompanyProject()){ %>
	<tr>
	<td>Proyecto <%= p.getProject().getName() %></td>
	<td>Presupuesto <%= p.getProject().getButget() %></td>
	</tr>
	<%} %>
	</table>
	</td></tr>
	
	<%} %>

	</table>

</body>
<%}else{ %>
<%response.sendRedirect("../error500.jsp?msg=Debe estar logeado"); } %>

</html>