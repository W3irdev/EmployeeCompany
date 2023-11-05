package com.jacaranda.models;

import java.util.Objects;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "employeeProject")
public class EmployeeProject {

	@Id
	@ManyToOne
	@JoinColumn(name = "idEmployee")
	private Employee employee;
	
	@Id
	@ManyToOne
	@JoinColumn(name = "idProject")
	private Project project;
	
	private int totalTime;
	
	
	public EmployeeProject() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public EmployeeProject(Employee employee, Project project, long totalTime) {
		super();
		this.employee = employee;
		this.project = project;
		this.totalTime = (int)totalTime;
	}


	public int getTotalTime() {
		return totalTime;
	}



	public Employee getEmployee() {
		return employee;
	}

	public void setEmployee(Employee employee) {
		this.employee = employee;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	@Override
	public int hashCode() {
		return Objects.hash(employee, project);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (!(obj instanceof EmployeeProject)) {
			return false;
		}
		EmployeeProject other = (EmployeeProject) obj;
		return Objects.equals(employee, other.employee) && Objects.equals(project, other.project);
	}

	public void setTotalTime(int totalTime) {
		this.totalTime = totalTime;
	}

	
	
	
	
	
	
}
