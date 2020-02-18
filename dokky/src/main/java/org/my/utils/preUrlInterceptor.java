package org.my.utils;
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
		
		HttpSession session = request.getSession();
		
		String preUrl = request.getRequestURI();
		
		if(!preUrl.equals("http://localhost:8080/socialLogin)")){
			session.setAttribute("preUrl", preUrl);
		}
		
		System.out.println("인터셉터단위");
		//System.out.println(request.getHeader("referer"));
		System.out.println(preUrl);
		log.info(request.getRequestURL().toString());
		System.out.println("인터셉터단위");
		
	return true;
	}
	@Override
	public void postHandle(HttpServletRequest request,//클라이언트의 요청을 가로채되 컨트롤러 처리 후 하는작업들
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}
}
