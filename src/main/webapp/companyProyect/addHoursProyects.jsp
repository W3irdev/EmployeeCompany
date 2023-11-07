<%@page import="java.util.Iterator"%>
<%@page import="com.jacaranda.models.EmployeeProject"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.jacaranda.exceptions.CompanyDatabaseException"%>
<%@page import="com.jacaranda.exceptions.CompanyProjectException"%>
<%@page import="com.jacaranda.models.CompanyProject"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.List"%>
<%@page import="com.jacaranda.models.Project"%>
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
// Comprobamos si estamos logeado y si somos el usuario del horario
if(session.getAttribute("userSession")!=null && session.getAttribute("userSession").equals("user")){ 
Employee user = (Employee) dbRepository.find(Employee.class, ((Employee)session.getAttribute("empleado")).getId());
List<CompanyProject> companiesProyects = user.getCompany().getCompanyProject();
Project project = null;


%>
<body>

<%
	String message = "";
	EmployeeProject employeeProject = null;
	if(request.getParameter("start")!=null && request.getParameter("company")!=null){
		String paro = "";
		
	}
		
	
	
%>
<%@ include file="/navbar.jsp" %>
<form>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañias</label> 
    <div class="col-8">
          <select id="company" name="company" class="custom-select" required="required" multiple="multiple">
      	<%for(CompanyProject c : companiesProyects){ %>
     	<%if(request.getParameter("company")!=null && Integer.valueOf(request.getParameter("company"))==c.getProject().getId()){ %>
			<option value="<%= c.getProject().getId()%>" selected="selected"><%= c.getProject().getName()%></option>
			<%}else{%> <option value="<%= c.getProject().getId()%>"><%= c.getProject().getName()%></option><%}%>
      	<%} %>
      </select>
    </div>
  </div> 

   	<%if(request.getParameter("start")!=null){ %>
	<button class="btn-info" type="submit" name="stop" value="stop">Stop</button>
   <%}else{ %>
   <button class="btn-info" type="submit" name="start" value="start">Start</button>
   <% }%>

  
</form>
<%=message %>


</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe ser empleado");  %>
</html>