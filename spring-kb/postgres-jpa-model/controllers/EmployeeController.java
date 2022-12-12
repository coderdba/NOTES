package myco.com.sbpgcrudjpa1.controllers;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import myco.com.sbpgcrudjpa1.domains.Employee;
import myco.com.sbpgcrudjpa1.repository.EmployeeRepository;
import myco.com.sbpgcrudjpa1.services.EmployeeService;

@CrossOrigin(origins = "http://localhost:4200")
@RestController
@RequestMapping("/api/v1/")
public class EmployeeController {
	
	private static Logger logger = LogManager.getLogger(EmployeeController.class.getName());
	
	@Autowired
	private ObjectMapper objectMapper;
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Autowired
	private EmployeeService employeeService;
	
	// get all employees
	@GetMapping("/employees")
	public List<Employee> getAllEmployees(){
			// original line of code
		return employeeRepository.findAll(); 
	}
	
	@GetMapping("/employees/{id}")
	public Employee getEmployeeById(@PathVariable int id) {
		
		// need orElseThrow or other method call to convert findById return value from List to Object
		return employeeRepository.findById(id).orElseThrow(IllegalArgumentException::new);
	}
	
	@GetMapping("/service/employees/{id}")
	public ResponseEntity<Employee> getEmployeeByIdFromService0(@PathVariable int id) throws Exception {
		
		Employee employee=null;
		
		try {
			employee = employeeService.getEmployeeById(id);
			return new ResponseEntity<Employee>(employee,HttpStatus.OK);
		} catch(Exception ex) {
			logger.error("ERR - Caught exception in EmployeeController:getEmployeeByIdFromService() for id " + id + ": "+ ex.getMessage());
			throw ex;
		}
	}
	
	@GetMapping("/service/employees/id/{id}")
	public ResponseEntity<Employee> getEmployeeByIdFromService(@PathVariable("id") int id) throws Exception {
		
		Employee employee=null;
		
		try {
			employee = employeeService.getEmployeeById(id);
			return new ResponseEntity<Employee>(employee,HttpStatus.OK);
		} catch(Exception ex) {
			logger.error("ERR - Caught exception in EmployeeController:getEmployeeByIdFromService() for id " + id + ": "+ ex.getMessage());
			throw ex;
		}
	}
}
