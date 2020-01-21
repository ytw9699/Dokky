package org.my.security;
	import java.io.IOException;
	import java.security.Principal;
	import javax.servlet.ServletException;
		import javax.servlet.http.HttpServletRequest;
		import javax.servlet.http.HttpServletResponse;
		import org.springframework.security.access.AccessDeniedException;
		import org.springframework.security.web.access.AccessDeniedHandler;
		import lombok.extern.log4j.Log4j;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
	/*쿠키나 세션에 특정한 작업을 하거나 HttpServletResponse에 특정한 헤더 정보를 추가하는 등의 행위를 할
	경우에는 지금처럼 직접 구현하는 방식이 더 권장*/
	
  @Override
  public void handle(HttpServletRequest request, 
      HttpServletResponse response, AccessDeniedException accessException)
      throws IOException, ServletException {

    log.error("Access Denied Handler");
    
    if(request.getRequestURI().equals("/admin/userList")) {//관리자메인 페이지 접속시
		if(!request.isUserInRole("ROLE_ADMIN")) {//관리자가 아니라면
			response.sendRedirect("/adminError");
			return;
		}
	}
    //Principal userinfo = request.getUserPrincipal();//로그인 한 사용자 정보를 가지고 있는 객체를 반환. 기본은 UserDetails 타입의 객체
	//log.error(userinfo); 
    //String request.getRemoteUser() :  사용자 아이디가 반환. UserDetails객체의 getUsername() 을 호출한 반환값.
    response.sendRedirect("/accessError");//공통 에러페이지
  }
}
