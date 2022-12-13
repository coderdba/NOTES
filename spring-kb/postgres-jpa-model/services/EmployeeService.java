package myco.com.sbpgcrudjpa1.services;

import java.util.List;

import org.springframework.stereotype.Service;

import myco.com.sbpgcrudjpa1.domains.Employee;

@Service  // can instead use @Component also
public interface EmployeeService {
	
	public List<Employee> getAllEmployees() throws Exception;
	public Employee getEmployeeById(int Id) throws Exception;

}
