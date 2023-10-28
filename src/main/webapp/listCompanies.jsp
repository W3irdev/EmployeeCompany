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

		<thread>

			<tr>

				<th scope="col">Id</th>

				<th scope="col">Nombre</th>

				<th scope="col">Direccion</th>

				<th scope="col">Ciudad</th>

				<th scope="col">Empleados</th>




			</tr>

		</thread>

		<%

		for (Company c: result){

		%>

				<tr>

					<td><%=c.getId()%></td>
					<td><%=c.getName()%></td>
					<td><%=c.getAddress()%></td>
					<td><%=c.getCity()%></td>
					<td>
					<table>
					<%for(Employee e : c.getEmployeeList()){ %>
					<tr>
					<td>Id: <%=e.getId()%></td>
					<td>Nombre: <%=e.getFirstName()%></td>
					<td>Apellidos: <%=e.getLastName()%></td>
					<td>Email: <%=e.getEmail()%></td>
					<td>Genero: <%=e.getGender()%></td>
					<td>Fecha Nacimiento: <%=e.getDateOfBirth()%></td>
					</tr>
					<%} %>
					</table>
					</td>


				</tr>

		<% }%>

	</table>

</body>

</html>