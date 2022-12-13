package myco.com.sbpgcrudjpa1.exceptions;

import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

@ControllerAdvice
public class ExceptionHelper {
	
    private static Logger logger = LogManager.getLogger(ExceptionHelper.class.getName());
    
    // for exceptions not handled by other helpers
    @ExceptionHandler(value = { Exception.class })
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ResponseEntity<?> handleException(Exception ex) {
        logger.error("Exception: " + ex.getClass() + ": " + ex.getMessage());
        ErrorDetails errorDetails = new ErrorDetails(new Date(), ex.getClass() + ": " + ex.getMessage());
        return new ResponseEntity<>(errorDetails, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    // handled exceptions 
    @ExceptionHandler(value = { MethodArgumentTypeMismatchException.class })
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<?> handleMethodArgumentTypeMismatchExceptionException(MethodArgumentTypeMismatchException ex) {
        logger.error("Exception: " + ex.getClass() + ": " + ex.getMessage());
        //ErrorDetails errorDetails = new ErrorDetails(new Date(), ex.getClass() + ": " + ex.getMessage());
        ErrorDetails errorDetails = new ErrorDetails(new Date(), 
        		"Provide correct type of input value, like integer or character etc." 
        		+ " Exception type: " + ex.getClass());
        return new ResponseEntity<>(errorDetails,HttpStatus.INTERNAL_SERVER_ERROR);
    }
    

    @ExceptionHandler(value = { InvalidInputException.class })
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<?> handleInvalidInputException(InvalidInputException ex) {
        logger.error("Exception: " + ex.getClass() + ": " + ex.getMessage());
        ErrorDetails errorDetails = new ErrorDetails(new Date(), ex.getClass() + ": " + ex.getMessage());
        return new ResponseEntity<>(errorDetails, HttpStatus.BAD_REQUEST);
    }

}
