package myco.com.sbpgcrudjpa1.exceptions;

public class NoRowsFoundException extends RuntimeException {
	
	   public NoRowsFoundException(String message) {
		   super(message);
	   }
}
