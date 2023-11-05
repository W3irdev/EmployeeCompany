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
// Comprobamos si estamos logeado y ademas si somos admin
if(session.getAttribute("userSession")!=null && session.getAttribute("userSession").equals("admin")){ %>
<body>

<%
try{
	
	// Definimos variables
	String message = request.getParameter("msg")!=null?"No se ha podido add":"";
	int idCompany =-1;
	int idProject =-1;
	Company company = null;
	Project project = null;
	Date begin = null;
	Date end = null;
	List<Company> companies = new ArrayList<Company>();
	// Inicializamos listas
	if(companies.isEmpty()){
		companies = dbRepository.findAll(Company.class);
	}
	List<Project> projects = new ArrayList<Project>();
	if(projects.isEmpty()){
		projects = dbRepository.findAll(Project.class);
	}
	
	// Comprobamos que los campos esten rellenos
	if(request.getParameter("submit")!=null && request.getParameter("company")!=null && request.getParameter("project")!=null
			&& request.getParameter("begin")!=null && request.getParameter("end")!=null){
	try{	
		// Si alguno de los campos no puede formatearse correctamente nos enviara a la pagina de error.
		idCompany=Integer.valueOf(request.getParameter("company"));
		idProject=Integer.valueOf(request.getParameter("project"));
		begin = Date.valueOf(request.getParameter("begin"));
		end = Date.valueOf(request.getParameter("end"));
	}catch(NumberFormatException nfe){
		 response.sendRedirect("../error500.jsp?msg=Los campos numericos solo pueden ser numeros");
	}catch(IllegalArgumentException iae){
		response.sendRedirect("../error500.jsp?msg=Asegurese de que la fecha es correcta");
	}
	// Comprobamos que la fecha de inicio no sea posterior a la de finalizacion
		if(idCompany!=-1 && idProject!=-1 && begin!=null && end!=null && begin.before(end)){
			try{
				// Rescatamos las instancias de la base de datos y creamos el CompanyProject
				company = dbRepository.find(Company.class, idCompany);
				project = dbRepository.find(Project.class, idProject);
				CompanyProject comProject = new CompanyProject(company, project, begin, end);
				if(comProject!=null){
					dbRepository.save(comProject);
					message="Add exitosamente";
				}
			}catch(CompanyProjectException cpe){
				message="No se ha podido add";
				response.sendRedirect("addCompanyProject?msg='No se ha podido add'");
				return;
			}catch(EmployeeCompanyException ece){
				message="Ese registro ya existe";
			}
		}
	}

%>
<%@ include file="/navbar.jsp" %>
<form>
  <div class="form-group row">
    <label for="company" class="col-4 col-form-label">Compañia</label> 
    <div class="col-8">
          <select id="company" name="company" class="custom-select" required="required">
      	<%for(Company c : companies){ %>
			<option value="<%= c.getId()%>"><%= c.getName()%></option>
      	<%} %>
      </select>
    </div>
  </div> 
  <div class="form-group row">
    <label for="project" class="col-4 col-form-label">Proyecto</label> 
    <div class="col-8">
          <select id="project" name="project" class="custom-select" required="required">
      	<%for(Project p : projects){ %>
			<option value="<%= p.getId()%>"><%= p.getName()%></option>
      	<%} %>
      </select>
    </div>
  </div> 
  <div class="form-group row">
    <label for="begin" class="col-4 col-form-label">Begin</label> 
    <div class="col-8">
      <input id="begin" name="begin" type="date" class="form-control" required="required">
    </div>
  </div>
  <div class="form-group row">
    <label for="end" class="col-4 col-form-label">End</label> 
    <div class="col-8">
      <input id="end" name="end" type="date" class="form-control" required="required">
    </div>
  </div>
  

  <div class="form-group row">
    <div class="offset-4 col-8">
      <button name="submit" type="submit" class="btn btn-primary" value="submit">Enviar</button>
    </div>
  </div>
</form>
<%=message %>

<%}catch(CompanyDatabaseException cde){
	response.sendRedirect("/error500.jsp?msg="+cde.getMessage());
	return;
} %>
</body>

<%}else response.sendRedirect("../error500.jsp?msg=Debe ser administrador");  %>
</html>