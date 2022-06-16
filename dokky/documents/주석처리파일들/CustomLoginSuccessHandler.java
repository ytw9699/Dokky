/*
- 마지막 업데이트 2022-05-18
- 슈퍼 관리자 인증 성공시 후처리 핸들링
- 1. 인증후 사용자 로긴 날짜 업데이트
- 2. 인증후 웹소켓 세션 관리를 위한 사용자별 아이디 세션에 저장
- 3. 인증후에 인터셉터에서 세션에 저장해둔 로그인전의 마지막 페이지로 이동후 다시 세션에서 삭제 

package org.my.security;
	import java.io.IOException;
	import java.util.Enumeration;
	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import javax.servlet.http.HttpSession;
	import org.my.domain.common.CustomUser;
	import org.my.service.CommonService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	
	import org.springframework.security.web.DefaultRedirectStrategy; 
	import org.springframework.security.web.RedirectStrategy; 
	import org.springframework.security.web.savedrequest.HttpSessionRequestCache; 
	import org.springframework.security.web.savedrequest.RequestCache; 
	import org.springframework.security.web.savedrequest.SavedRequest; 

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth)
			throws IOException, ServletException {

		 	log.warn("onAuthenticationSuccess");
		 
			SavedRequest saveRequest = (SavedRequest)request.getSession().getAttribute("SPRING_SECURITY_SAVED_REQUEST");
			
			String redirectUrl = saveRequest.getRedirectUrl();
			
			log.info(redirectUrl);
			
			String uri = request.getHeader("Referer");
			log.info("/Referer");
			log.info(uri);
			
		 log.warn(request.getRequestURI());
		 
		 Enumeration<String> e = request.getParameterNames();
	           
	        while(e.hasMoreElements()){
	    	   
	    	   String nextElement = e.nextElement();
	    	   log.warn(nextElement);
	        }
		 
		 CustomUser user = (CustomUser)auth.getPrincipal();
		 
		 String userId = user.getUsername();
		 
		 commonService.updateLoginDate(userId);
		 
		 HttpSession session = request.getSession();
		 
		 session.setAttribute("userId", userId);//웹소켓이 끊겼을때 사용하기 위해 세션에 저장해둔다.

		 String redirectUrl = (String)session.getAttribute("preUrl");
         
		 log.info("redirectUrl="+redirectUrl);
			
		 RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
		 RequestCache requestCache = new HttpSessionRequestCache();
		 SavedRequest savedRequest = requestCache.getRequest(request, response);
		 String targetUrl = savedRequest.getRedirectUrl();
		 
		 log.info("targetUrl="+targetUrl);
			
		 
         if (redirectUrl != null) {
       	   
         	  log.info("redirectUrl="+redirectUrl);
           	 
              session.removeAttribute("preUrl");
               
              response.sendRedirect(redirectUrl);
              
         }else {
        	 
        	 response.sendRedirect("/admin/userList");
         }
         
     	
	}
}


*/