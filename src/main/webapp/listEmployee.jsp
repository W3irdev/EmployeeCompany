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

	ArrayList<Employee> result = null;

			try{

				result = (ArrayList<Employee>) dbRepository.findAll(Employee.class);

			}catch(Exception e){

		

			}

	%>



	<table class="table">

		<thread>

			<tr>

				<th scope="col">Id</th>

				<th scope="col">Nombre</th>

				<th scope="col">Apellidos</th>

				<th scope="col">Email</th>

				<th scope="col">Género</th>

				<th scope="col">Fecha de nacimiento</th>

				<th scope="col">Nombre Compañía</th>



			</tr>

		</thread>

		<%

		for (Employee e: result){

		%>

				<tr>

					<td><%=e.getId()%></td>

					<td><%=e.getFirstName()%></td>

					<td><%=e.getLastName()%></td>

					<td><%=e.getEmail()%></td>

					<td><%=e.getGender()%></td>

					<td><%=e.getDateOfBirth()%></td>

					<td><%=e.getCompany().getName()%></td>

					<form><td>
					<input type="text" name="idEmp" value="<%=e.getId()%>" hidden/>
					<input type="submit" name="emp" value="infoemp"/></td></form>
				</tr>

		<% }%>

	</table>

</body>

</html>