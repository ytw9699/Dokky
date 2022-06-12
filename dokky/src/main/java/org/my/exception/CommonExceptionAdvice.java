package org.my.exception;
	import org.springframework.http.HttpStatus;
	import org.springframework.jdbc.BadSqlGrammarException;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.ControllerAdvice;
	import org.springframework.web.bind.annotation.ExceptionHandler;
	import org.springframework.web.bind.annotation.ResponseStatus;
	import org.springframework.web.servlet.NoHandlerFoundException;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;
	import org.springframework.security.access.AccessDeniedException;
	import org.springframework.validation.BindException;
	
@RequiredArgsConstructor
@ControllerAdvice
@Log4j
public class CommonExceptionAdvice {
	
	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND) 
	public String handleNoHandlerFoundException(NoHandlerFoundException ex, Model model) {
		
		log.error("handleNoHandlerFoundException .......");
		ex.printStackTrace();
		
		model.addAttribute("message", "해당 URL은 존재하지 않습니다.");

		return "error/commonError";
	}
	
	@ExceptionHandler(BindException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST) 
	public String handleBindException(BindException ex, Model model) {
		
		log.error("handleBindException .......");
		ex.printStackTrace();
	
		model.addAttribute("message", "잘못된 요청입니다.");

		return "error/commonError";  
	}
	
	@ExceptionHandler(BadSqlGrammarException.class)
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR) 
	public String handleBadSqlGrammarException(BadSqlGrammarException ex, Model model) {
		
		log.error("handleBadSqlGrammarException .......");
		ex.printStackTrace();
	
		model.addAttribute("message", "서버 에러 입니다.");

		return "error/commonError";  
	}
	
	@ExceptionHandler(AccessDeniedException.class)//AccessDeniedExceptiond은 CustomAccessDeniedHandler에서 예외 처리하는중이니 시큐리티에게 던지자.
	public void handleAccessDeniedException(AccessDeniedException ex) throws AccessDeniedException {
		
		log.error("handleAccessDeniedException .......");
		ex.printStackTrace();
		
		throw ex;
	}
	
	@ExceptionHandler(Exception.class)
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR) 
	public String handleException(Exception ex, Model model) {
		
		log.error("handleException .......");
		ex.printStackTrace();
	
		model.addAttribute("message", "서버 에러 입니다.");

		return "error/commonError";  
	}
}

