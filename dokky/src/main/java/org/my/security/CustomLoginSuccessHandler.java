package org.my.security;
	import java.io.IOException;
	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import javax.servlet.http.HttpSession;
	import org.my.security.domain.CustomUser;
	import org.my.service.CommonService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth)
			throws IOException, ServletException {

		 log.warn("Login Success");
		 
		 CustomUser user = (CustomUser)auth.getPrincipal();
		 
		 String userId = user.getUsername();
		 
		 commonService.updateLoginDate(userId);
		 
		 HttpSession session = request.getSession();
		 
		 session.setAttribute("userId", userId);//웹소켓이 끊겼을때 사용하기 위해 세션에 저장해둔다.

		 String redirectUrl = (String)session.getAttribute("preUrl");
         
		 log.info("redirectUrl="+redirectUrl);
		 
         if (redirectUrl != null) {
       	   
         	  log.info("redirectUrl="+redirectUrl);
           	 
              session.removeAttribute("preUrl");
               
              response.sendRedirect(redirectUrl);
              
         }else {
        	 
        	 response.sendRedirect("/admin/authorizationList");
         }
	}
}


