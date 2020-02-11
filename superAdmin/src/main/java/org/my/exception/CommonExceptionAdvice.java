package org.my.exception;
	import org.springframework.http.HttpStatus;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.ControllerAdvice;
	import org.springframework.web.bind.annotation.ExceptionHandler;
	import org.springframework.web.bind.annotation.ResponseStatus;
	import org.springframework.web.servlet.NoHandlerFoundException;
	import lombok.extern.log4j.Log4j;

@ControllerAdvice
@Log4j
public class CommonExceptionAdvice {

	@ExceptionHandler(Exception.class)
	//@ResponseStatus(아무코드를 지정안하면 200이 날라가게된다..)
	public String except(Exception ex, Model model) {

		log.error("Exception ......." + ex.getMessage());
		
		model.addAttribute("exception", ex);
		
		log.error(model);
		
		return "error/errorPage";  
		
	}

	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND) //404코드를 강제로 지정해주는것
	public String handle404(NoHandlerFoundException ex) {

		return "error/404errorPage";
	}

}
