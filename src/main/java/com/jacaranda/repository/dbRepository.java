package com.jacaranda.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import com.jacaranda.exceptions.CompanyDatabaseException;
import com.jacaranda.exceptions.EmployeeCompanyException;
import com.jacaranda.utility.BdUtil;

public class dbRepository {

	
	public static <T> T find(Class<T> c, int id) throws Exception {
	
		Session session=null;
		T result = null;
		
		try {
			session = BdUtil.getSessionFactory().openSession();
		
		} catch (Exception e) {
			throw new Exception("Error en la base de datos");
		}
		try {
			result = (T) session.find(c, id);
		} catch (Exception e) {
			throw new Exception("Error al obtener la entidad");

		}
		
		return result;
		
	}
	
	public static <T> T find(Class<T> c, String name) throws Exception {
		
		Session session=null;
		T result = null;
		
		try {
			session = BdUtil.getSessionFactory().openSession();
		} catch (Exception e) {
			throw new Exception("Error en la base de datos");
		}
		try {
			result = (T) session.find(c, name);
		} catch (Exception e) {
			throw new Exception("Error al obtener la entidad");

		}
		
		return result;
		
	}
	
	
	
	@SuppressWarnings("unchecked")
	public static <T> T getInstance(Class<T> c, String name) throws Exception {
		Session session=null;
		T result = null;
		
		try {
			session = BdUtil.getSessionFactory().openSession();
		} catch (Exception e) {
			throw new Exception("Error en la base de datos");
		}
		try {
			result = (T) session.createSelectionQuery("From "+c.getName()+ " where name = :name").setParameter("name", name).getResultList().get(0);
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Error al obtener la entidad");

		}
		session.close();
		return result;
		
	}
	
	@SuppressWarnings("unchecked")
	public static <T> T getUserEmployee(Class<T> c, String email) throws Exception {
		Session session=null;
		T result = null;
		
		try {
			session = BdUtil.getSessionFactory().openSession();
		} catch (Exception e) {
			throw new Exception("Error en la base de datos");
		}
		try {
			result = (T) session.createSelectionQuery("From "+c.getName()+ " where email = :email").setParameter("email", email).getSingleResultOrNull();
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Error al obtener la entidad");

		}
		
		return result;
		
	}
	
	@SuppressWarnings("unchecked")
	public static <T> List<T> findAll(Class<T> c) throws CompanyDatabaseException {
		
		Session session=null;
		List<T> result = null;
		
		try {
			session = BdUtil.getSessionFactory().openSession();
		} catch (Exception e) {
			throw new CompanyDatabaseException("Error en la base de datos");
		}
		try {
			result = (List<T>) session.createSelectionQuery("From " + c.getName()).getResultList();
		} catch (Exception e) {
			throw new CompanyDatabaseException("Error al obtener la Lista");

		}
		
		return result;
	}
	
	public static <T> void save(T c) throws EmployeeCompanyException {
		
		Session session = (Session) BdUtil.getSessionFactory().openSession();
		Transaction transaction = (Transaction) session.beginTransaction();
		
		try {
			session.persist(c);
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			throw new EmployeeCompanyException("No se ha podido añadir a la tabla " + c.getClass());
		}
		session.close();
		
	}
	
	
	public static <T> void delete(T c) throws EmployeeCompanyException {
		
		Session session = (Session) BdUtil.getSessionFactory().openSession();
		Transaction transaction = (Transaction) session.beginTransaction();
		
		try {
			session.remove(c);
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			throw new EmployeeCompanyException("No se ha podido eliminar de la tabla " + c.getClass());
		}
		
		session.close();
	}
	
	public static <T> void modify(T c) throws EmployeeCompanyException {

		Session session = (Session) BdUtil.getSessionFactory().openSession();
		Transaction transaction = (Transaction) session.beginTransaction();
		
		try {
			session.merge(c);
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			throw new EmployeeCompanyException("No se ha podido añadir a la tabla " + c.getClass());
		}
		
		session.close();
	}
	
}
