package org.my.utils;
	import java.util.Enumeration;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import javax.servlet.http.HttpSession;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
	import lombok.extern.log4j.Log4j;
	
@Log4j
public class preUrlInterceptor extends HandlerInterceptorAdapter{
		
	@Override
	public boolean preHandle(HttpServletRequest request, //오버라이드 요청을 가로채서 컨트롤러까지 일단 요청 못들어감
			HttpServletResponse response, Object handler) throws Exception {
		
		log.info("인터셉터 시작");
		
		HttpSession session = request.getSession();
		
		String preURI = request.getRequestURI();
		
		//if(!(preURI.equals("/socialLogin") || preURI.equals("/superAdminLogin"))){
			
        Enumeration<String> e = request.getParameterNames();
            
        if(e.hasMoreElements()) {
        	   preURI = preURI +"?";
        }
           
        while(e.hasMoreElements()){
    	   
    	   String nextElement = e.nextElement();
    	   preURI = preURI + nextElement + "=";
    	   preURI = preURI + request.getParameter(nextElement);
    	   
    	   if(e.hasMoreElements()) {
        	   preURI = preURI +"&";
           }
        }
		
		session.setAttribute("preUrl", preURI);
		
		log.info("preURI="+preURI);
		log.info("인터셉터 끝");
	
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request,//클라이언트의 요청을 가로채되 컨트롤러 처리 후 하는작업들
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}
}
