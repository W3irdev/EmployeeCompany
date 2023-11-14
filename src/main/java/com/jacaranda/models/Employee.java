package com.jacaranda.models;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Objects;

import org.apache.commons.codec.digest.DigestUtils;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "employee")
public class Employee {

	@Id
	private int id;
	private String firstName;
	private String lastName;
	private String email;
	private String gender;
	private Date dateOfBirth;
	@ManyToOne
	@JoinColumn(name = "idCompany")
	private Company company;
	private String role;
	private String password;
	
	@OneToMany(mappedBy = "employee")
	private List<EmployeeProject> employeProjects;
	
	

	public Employee() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Employee(String firstName, String lastName, String email, String gender, String dateOfBirth, Company company) throws Exception {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.gender = gender;
		setDateOfBirth(dateOfBirth);
		this.company = company;
	}
	
	public Employee(int id, String firstName, String lastName, String email, String gender, String dateOfBirth, Company company) throws Exception {
		super();
		this.id = id;
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.gender = gender;
		setDateOfBirth(dateOfBirth);
		this.company = company;
	}

	
	
	public Employee(int id, String firstName, String lastName, String email, String gender, String dateOfBirth,
			Company company, String role, String password) throws Exception {
		super();
		this.id = id;
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.gender = gender;
		setDateOfBirth(dateOfBirth);
		this.company = company;
		this.role = role;
		this.password = password;
	}
	
	

	public List<EmployeeProject> getEmployeProjects() {
		return employeProjects;
	}

	public void setEmployeProjects(List<EmployeeProject> employeProjects) {
		this.employeProjects = employeProjects;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = DigestUtils.md5Hex(password);
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(String dateOfBirth) throws Exception {
		try {	
			//this.dateOfBirth = new SimpleDateFormat("yyyy-MM-DD").parse(dateOfBirth);
			this.dateOfBirth = Date.valueOf(dateOfBirth);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Introduzca un formato adecuado de fecha");
		}
		
		
		
	}

	public Company getCompany() {
		return company;
	}

	public void setCompany(Company company) {
		this.company = company;
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
		if (!(obj instanceof Employee)) {
			return false;
		}
		Employee other = (Employee) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		return String.format("Empleado id: %s, Nombre: %s, Apellidos: %s, email: %s, Genero: %s, Fecha de Nacimiento: %s %n", id,
				firstName, lastName, email, gender, dateOfBirth);
	}

	
	
	
}
