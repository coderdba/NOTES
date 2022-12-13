package myco.com.sbpgcrudjpa1.domains;

import myco.com.sbpgcrudjpa1.enums.EmployeeActiveStatus;
import lombok.*;

//import java.io.Serializable;
//import org.springframework.data.annotation.Id; // use javax.persistence.Id instead
import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
//import javax.persistence.Lob;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

//import org.hibernate.type.TextType;

/**
 * Class which is responsible to define the test template
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "employees0", schema = "sp") // sp is the schema, employees is the table
//public class Employee {
public class Employee {
    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	//private long id;
    private int id;

    // Employee Name
    //@Column(name = "name", columnDefinition = "text")
    @Column(name = "name")
    private String name;
    
    // Status of the template
    @Column(name = "active_status")
    private EmployeeActiveStatus activeStatus;
    
    // Created time - UTC datetime
    @Column(name = "created_datetime")
    public LocalDateTime createdDateTime;
    
    // Updated time - UTC datetime
    @Column(name = "updated_datetime")
    public LocalDateTime updatedDateTime;

    // Creator of the record
    //@Column(name = "created_by", columnDefinition = "text")
    @Column(name = "created_by")
    private String createdBy;
    
    // Updator of the record
    //@Column(name = "updated_by", columnDefinition = "text")
    @Column(name = "updated_by")
    private String updatedBy;  
}
