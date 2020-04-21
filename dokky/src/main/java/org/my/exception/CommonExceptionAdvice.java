package org.my.exception;
	import org.springframework.http.HttpStatus;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.ControllerAdvice;
	import org.springframework.web.bind.annotation.ExceptionHandler;
	import org.springframework.web.bind.annotation.ResponseStatus;
	import org.springframework.web.servlet.NoHandlerFoundException;
	import lombok.extern.log4j.Log4j;

@ControllerAdvice//@ControllerAdvice는 해당 객체가 스프링의 컨트롤러에서 발생하는 예외를 처리하는 존재임을 명시하는 용도로 사용
@Log4j
public class CommonExceptionAdvice {

	@ExceptionHandler(Exception.class)//ExceptionHandler는 해당 메서드가 () 들어가는 예외 타입을 처리한다는 것을 의미, 지금 설정은 모든예외에 대한 처리가 except()만을 이용해서 처리
	//@ResponseStatus(아무코드를 지정안하면 200이 날라가게된다..)
	public String except(Exception ex, Model model) {

		log.error("Exception ......." + ex.getMessage());
		
		model.addAttribute("exception", ex);
		
		log.error(model);
		
		return "error/errorPage";  
		
	}

	@ExceptionHandler(NoHandlerFoundException.class)//잘못된 URL을 호출할 때 보이는 404 에러 메시지의 경우는 위와는 조금 다르게 처리하는 것이 좋다.
	@ResponseStatus(HttpStatus.NOT_FOUND) //404코드를 강제로 지정해주는것
	public String handle404(NoHandlerFoundException ex) {

		return "error/404errorPage";
	}

}
