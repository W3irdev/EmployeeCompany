<%@page import="java.util.ArrayList"%>

<%@page import="com.jacaranda.models.Employee"%>

<%@page import="java.util.List"%>

<%@page import="com.jacaranda.repository.dbRepository"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="es">

<head>

<meta charset="UTF-8">

<title>Listado cines</title>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"> 

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

</head>
<body>
<%
// Comprobamos la session, si somos usuario o admin muestra la pagina, en caso de que no seamos ninguno nos pedira que logeemos
if(session.getAttribute("userSession") != null && (session.getAttribute("userSession").equals("user") || session.getAttribute("userSession").equals("admin"))){ %>
<%@ include file="../navbar.jsp" %>
	<%

	ArrayList<Employee> result = null;

			try{
				
				result = (ArrayList<Employee>) dbRepository.findAll(Employee.class);

			}catch(Exception e){

				response.sendRedirect("/error500.jsp?msg="+e.getMessage());
				return;

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
		// Mostramos por pantalla la lista de empleados
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
					<%if(session.getAttribute("userSession")!=null && session.getAttribute("empleado")!=null && session.getAttribute("userSession").equals("user")){
						Employee user = (Employee)session.getAttribute("empleado");
						
						if(user.getEmail().equals(e.getEmail())){%>
						<td><form action="../companyProyect/addHoursProyect.jsp">
						<input type="text" name="hourId" value="<%=user.getId()%>" hidden/>
						<input type="submit" name="hour" value="Add Hour"/></form></td>
						<form action="editEmployee.jsp"><td>
						<input type="text" name="id" value="<%=e.getId()%>" hidden/>
						<input type="submit" name="emp" value="Editar"/></td></form>
						<% }%>
						
						<%}%>
					<%if(session.getAttribute("userSession").equals("admin")){ %>
					<form action="editEmployee.jsp"><td>
					<input type="text" name="id" value="<%=e.getId()%>" hidden/>
					<input type="submit" name="emp" value="Editar"/></td></form>
					<form action="delEmployee.jsp"><td>
					<input type="text" name="id" value="<%=e.getId()%>" hidden/>
					<input type="submit" name="empDel" value="Borrar"/></td></form>
					<%}
					%>
				</tr>

		<% }%>

	</table>
<%}else{ %>
<%response.sendRedirect("../error500.jsp?msg=Debe estar logeado"); } %>
</body>

</html>