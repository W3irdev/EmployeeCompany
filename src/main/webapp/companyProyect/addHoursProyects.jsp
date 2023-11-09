<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays"%>
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
Map<Integer, LocalDateTime> inWork = session.getAttribute("inWork")!=null?(HashMap<Integer, LocalDateTime>)session.getAttribute("inWork"):new HashMap<Integer, LocalDateTime>();
Project project = null;

%>
<body>
<%
String message = "";
		
%>
<%@ include file="/navbar.jsp" %>
<%
	long totalTime = session.getAttribute("totalTime2")!=null?(long)session.getAttribute("totalTime2"):0;
	if(request.getParameter("startButton")!=null){
		
		int idProject = Integer.valueOf(request.getParameter("startButton"));
			
			inWork.put(idProject, LocalDateTime.now());
			session.setAttribute("inWork", inWork);
	}else if(request.getParameter("finishButton")!=null){
		if(inWork.containsKey(Integer.valueOf(request.getParameter("finishButton")))){
			totalTime =  ChronoUnit.MINUTES.between(LocalDateTime.now(), inWork.get(Integer.valueOf(request.getParameter("finishButton")))) ;
			inWork.remove(Integer.valueOf(request.getParameter("finishButton")));
			session.setAttribute("totalTime2", totalTime);
			session.setAttribute("inWork", inWork);
			if(user.getEmployeProjects().contains(new EmployeeProject(user, dbRepository.find(Project.class, Integer.valueOf(request.getParameter("finishButton"))), totalTime))){
				dbRepository.modify(new EmployeeProject(user, dbRepository.find(Project.class, Integer.valueOf(request.getParameter("finishButton"))), totalTime)) ;
				
			}else{
				dbRepository.save(new EmployeeProject(user, dbRepository.find(Project.class, Integer.valueOf(request.getParameter("finishButton"))), totalTime));
			}
			
		}
	}

%>

<form>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañias</label> 
    <div class="col-8">
    <ul style="list-style-type: none;">
      	<%for(CompanyProject c : companiesProyects){ %>
      	<li>
     	<%if(inWork.containsKey(c.getProject().getId())){ %>
			<button type="submit" name="finishButton" value="<%= c.getProject().getId()%>">Terminar</button><%= c.getProject().getName()%>
			<%}else{%> <button type="submit" name="startButton" value="<%= c.getProject().getId()%>">Empezar</button><%= c.getProject().getName()%><%}%>
      	<%} %>
      	</li>
      </ul>
    </div>
  </div>  
</form>

<%=message %>


</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe ser empleado");  %>
</html>