/*
- 마지막 업데이트 2022-05-25
- 접근제한시 후처리 핸들링
1. 관리자 페이지 접근 권한 에러
2. 일반 사용자 페이지 접근 권한 에러 
*/
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
  public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessException)
      throws IOException, ServletException {

    log.error("Access Denied Handler");
    
    String URI = request.getRequestURI();
    
    if(URI.contains("superAdmin")){//슈퍼 관리자 권한 접근 에러
    	
    	response.sendRedirect("/accessError?authorization=superAdmin");
    	
    }else if(URI.contains("admin")){//일반 관리자 권한 접근 에러
    	
    	response.sendRedirect("/accessError?authorization=admin");
    	
    }else {//그외 모든 권한 접근 에러
    	response.sendRedirect("/accessError?authorization=common");
    }
  }
}
