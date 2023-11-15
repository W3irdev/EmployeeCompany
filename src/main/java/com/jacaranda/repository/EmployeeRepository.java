package com.jacaranda.repository;

import java.util.ArrayList;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.NativeQuery;

import com.jacaranda.exceptions.EmployeeCompanyException;
import com.jacaranda.exceptions.EmployeeProjectException;
import com.jacaranda.models.EmployeeProject;
import com.jacaranda.utility.BdUtil;

public class EmployeeRepository extends dbRepository {


	public static ArrayList<EmployeeProject> getEmployeeProject(Integer employeeId) throws EmployeeProjectException{
		
		Session session = null;
		Transaction transaction = null;
		ArrayList<EmployeeProject> result = null;
		
		if(employeeId == null) {
			throw new EmployeeProjectException("No se ha introducido id de empleado");
		}
		
		try {
			session = BdUtil.getSessionFactory().openSession();
			transaction = session.beginTransaction();
		} catch (Exception e) {
			throw new EmployeeProjectException(e.getMessage());
		}
		
		try {
			
			NativeQuery<EmployeeProject> statement = session.createNativeQuery("Select * from employeeProject where idEmployee = :employeeId", EmployeeProject.class);
			
			statement.setParameter("employeeId", employeeId);
			result = (ArrayList<EmployeeProject>) statement.getResultList();
		} catch (Exception e) {
			throw new EmployeeProjectException(e.getMessage());
		}
		
		
		return result;
		
		
	}
	
}
