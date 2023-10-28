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

<body>

	<%

	ArrayList<Company> result = null;

			try{

				result = (ArrayList<Company>) dbRepository.findAll(Company.class);

			}catch(Exception e){

		

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

</html>