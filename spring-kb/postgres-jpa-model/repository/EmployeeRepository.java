package myco.com.sbpgcrudjpa1.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;

import myco.com.sbpgcrudjpa1.domains.Employee;

@Repository
//public interface EmployeeRepository extends JpaRepository<Employee, Long>{
public interface EmployeeRepository extends JpaRepository<Employee, Integer>{

}
