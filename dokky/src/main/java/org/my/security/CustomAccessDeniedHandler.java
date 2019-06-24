package org.my.security;

	import java.io.IOException;
	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.springframework.security.access.AccessDeniedException;
	import org.springframework.security.web.access.AccessDeniedHandler;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

  @Override
  public void handle(HttpServletRequest request, 
      HttpServletResponse response, AccessDeniedException accessException)
      throws IOException, ServletException {

    log.error("Access Denied Handler");

    log.error("Redirect....");
    
    if(request.getRequestURI().equals("/dokky/board/admin")) {//관리자메인 페이지 접속시
		if(!request.isUserInRole("ROLE_ADMIN")) {//관리자가 아니라면
			response.sendRedirect("/dokky/adminError");
			return;
		}
	}
  //String password = (String) request.getSession().getAttribute("password");
    //String username = (String) request.getSession().getAttribute("username");
    //String password = request.getParameter("password");
    //String username = request.getParameter("username"); 
    //System.out.println(password);
    //System.out.println(username);
    //System.out.println(request.getSession());

    response.sendRedirect("/dokky/accessError");//공통 에러페이지
  }

}
