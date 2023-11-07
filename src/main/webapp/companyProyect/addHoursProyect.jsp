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
long totalTime = session.getAttribute("totalTime")!=null?(long)session.getAttribute("totalTime"):0;
%>
<body>

<%
	String message = "";
	EmployeeProject employeeProject = null;
%>
<%@ include file="/navbar.jsp" %>
<form>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañia</label> 
    <div class="col-8">
          <select id="company" name="company" class="custom-select" required="required">
      	<%for(CompanyProject c : companiesProyects){ %>
     	<%if(request.getParameter("company")!=null && Integer.valueOf(request.getParameter("company"))==c.getProject().getId()){ %>
			<option value="<%= c.getProject().getId()%>" selected="selected"><%= c.getProject().getName()%></option>
			<%}else{%> <option value="<%= c.getProject().getId()%>"><%= c.getProject().getName()%></option><%}%>
      	<%} %>
      </select>
    </div>
  </div> 
  
  

   
   <%
   // Cuando pulsemos el boton start, aseguramos que no tengamos valores nulos
   if(request.getParameter("start")!=null && request.getParameter("start").equals("start") && request.getParameter("company")!=null){
	   project = dbRepository.find(Project.class, request.getParameter("company"));
	   // Guardamos en session el tiempo actual, si ese EmployeeProject ya se ha iniciado alguna vez, cargamos la instancia y recuperamos su tiempo
	   if(user.getEmployeProjects().isEmpty()){
		   session.setAttribute("start", LocalDateTime.now());
	   }else{
		   EmployeeProject ep = null;
		   boolean found = false;
		  Iterator<EmployeeProject>  it = user.getEmployeProjects().iterator();
		  while(it.hasNext() && !found){
			  ep = it.next();
			  if(ep.getProject().getId()==project.getId()){
				  found = true; 
				  totalTime = (long)ep.getTotalTime();
				  session.setAttribute("totalTime", totalTime);
			  }
		  }
		  // Si no, empezamos el contador de esa instancia a 0
		  if(!found){
			  totalTime = 0;
			  session.setAttribute("totalTime", totalTime);
		  }
		 
	   }
		   session.setAttribute("start", LocalDateTime.now());
	   // Cuando pulsemos Stop, comprobamos que no tengamos valores nulos
   }else if(request.getParameter("stop")!=null && request.getParameter("stop").equals("stop") && request.getParameter("company")!=null){
	   
	   // Creamos un proyecto rescatando de la base de datos la compañia que esta seleccionada
	   // Buscamos en el usuario si ese EmployeeProject ya existe, si no, lo guardamos en la base de datos.
	   project = dbRepository.find(Project.class, request.getParameter("company"));
	   if(user.getEmployeProjects().isEmpty()){
	   totalTime += ChronoUnit.SECONDS.between((LocalDateTime)session.getAttribute("start"), LocalDateTime.now());
	   employeeProject = new EmployeeProject(user, project, totalTime);
		   try{
			   
		   dbRepository.save(employeeProject);
		   session.setAttribute("totalTime", totalTime);
		   session.setAttribute("empleado", user);
		   }catch(EmployeeCompanyException ece){
			   message=ece.getMessage();
		   }
		   
	   }else{
		   totalTime = (long)ChronoUnit.SECONDS.between((LocalDateTime)session.getAttribute("start"), LocalDateTime.now()) + totalTime;
		   employeeProject = new EmployeeProject(user, project, totalTime);
		   if(!user.getEmployeProjects().contains(employeeProject)){
			   try{
				   dbRepository.save(employeeProject);
				   session.setAttribute("totalTime", totalTime);
				   session.setAttribute("empleado", user);
			   }catch(EmployeeCompanyException ece){
				   message=ece.getMessage();
			   } 
		   }else{
			   try{
				   dbRepository.modify(employeeProject);
				   session.setAttribute("totalTime", totalTime);
				   session.setAttribute("empleado", user);
			   }catch(EmployeeCompanyException ece){
				   message=ece.getMessage();
			   }
		   }

	   }
	   
	   session.removeAttribute("start");
   }%>
  	<%
	// ToDoOOOOOO
	LocalDateTime dateStart = (LocalDateTime)session.getAttribute("start");
	if(dateStart==null || request.getParameter("stop")!=null){ %>
	<button class="btn-info" type="submit" name="start" value="start">Start</button>
   <%}else if(dateStart!=null || request.getParameter("start")!=null){ %>
   <button class="btn-info" type="submit" name="stop" value="stop">Stop</button>
   <% 
   }%>
</form>
<%=message %>
Tiempo total trabajado: <%=totalTime %>

</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe ser empleado");  %>
</html>