
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">Menu Empleados</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/employee/addEmployee.jsp">Añadir Empleado</a>
        
      </li>
          <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/companyProyect/addCompanyProject.jsp">Añadir Company Proyect</a>
        
      </li>
            <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/employee/listEmployee.jsp">Empleados</a>
        
      </li>
        <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/company/listCompanies.jsp">Compañias</a>
      </li>
       <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/companyProyect/listCompaniesProjects.jsp">Proyectos de compañias</a>
      </li>
    </ul>
    <form class="form-inline my-2 my-lg-0">
      <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
    </form>
  </div>
</nav>
