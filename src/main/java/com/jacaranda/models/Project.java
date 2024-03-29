package com.jacaranda.models;

import java.util.List;
import java.util.Objects;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "project")
public class Project {
	
	@Id
	private int id;
	private String name;
	private String butget;
	
	@OneToMany(mappedBy = "project")
	private List<CompanyProject> companyProject;
	
	@OneToMany(mappedBy = "project")
	private List<EmployeeProject> employeeProject;
	
	public List<CompanyProject> getCompanyProject() {
		return companyProject;
	}
	public void setCompanyProject(List<CompanyProject> companyProject) {
		this.companyProject = companyProject;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getButget() {
		return butget;
	}
	public List<EmployeeProject> getEmployeeProject() {
		return employeeProject;
	}
	public void setEmployeeProject(List<EmployeeProject> employeeProject) {
		this.employeeProject = employeeProject;
	}
	public void setButget(String butget) {
		this.butget = butget;
	}
	@Override
	public int hashCode() {
		return Objects.hash(id);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (!(obj instanceof Project)) {
			return false;
		}
		Project other = (Project) obj;
		return id == other.id;
	}
	
	
	

}
