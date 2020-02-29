package org.my.security;
	import java.io.IOException;
	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import javax.servlet.http.HttpSession;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth)
			throws IOException, ServletException {

		 log.warn("Login Success");
		 
		 HttpSession session = request.getSession();

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


