package myco.com.sbpgcrudjpa1.services;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.stereotype.Service;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

import myco.com.sbpgcrudjpa1.domains.Employee;
import myco.com.sbpgcrudjpa1.repository.EmployeeRepository;
import myco.com.sbpgcrudjpa1.services.EmployeeService;
import myco.com.sbpgcrudjpa1.exceptions.NoRowsFoundException;
import myco.com.sbpgcrudjpa1.exceptions.InvalidInputException;

@Component  // can instead use @Service also
public class EmployeeServiceImpl implements EmployeeService {
	
	private static Logger logger = LogManager.getLogger(EmployeeService.class.getName());
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	
	// validation methods
	private void validateId(int id) throws Exception {
		
		logger.info("Exception caught in EmployeeServiceImpl:validateId()");
		
		if (id < 1) {
			throw (new InvalidInputException("ERR - Input id is not valid. Retry."));
		}
	}
	
	/* This is not working as expected, so, commenting out
	private void validateId(Object id) throws Exception {
		
		System.out.println("In validateId()");
		logger.info("In validateId()");
		System.out.println("ID type is: " + id.getClass().getName());
		
		throw (new Exception());
	}
	*/
	
	// data fetch methods
	public List<Employee> getAllEmployees() throws Exception {
		
		List<Employee> employees=null;
		
		try {
			employees=employeeRepository.findAll();
			if(employees==null) {
				logger.error("ERR - NoRowsFoundException caught in EmployeeService:getAllEmployees()");
				throw new NoRowsFoundException("No employee records were found in database.");
			}else {
				return employees;
			}
		}catch(Exception ex){
			logger.error("ERR - Exception caught in EmployeeService:getAllEmployees()" + ex);
			throw ex;
		}
	}
	
	public Employee getEmployeeById(int id) throws Exception {
		
		// validate the id 
		validateId(id);
		
		Employee employee=null;
		
		try {
			employee = employeeRepository.findById(id).orElse(null);
			
			if(employee==null) {
				logger.error("ERR - NoRowsFoundException caught in EmployeeService:getEmployeeById() for Id " + id);
				throw new NoRowsFoundException("Employee with id " + id + " could not be found.");
			}else {
				return employee;
			}
		}catch(Exception ex){
			logger.error("ERR - Exception caught in EmployeeService:getEmployeeById() for Id " + id + ":" + ex);
			throw ex;
		}
	}
}
