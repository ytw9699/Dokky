/*
- 마지막 업데이트 2022-05-20
- 인증 실패시 후처리 핸들링
*/
package org.my.security;
	import java.io.IOException;
	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.springframework.security.authentication.BadCredentialsException;
	import org.springframework.security.authentication.DisabledException;
	import org.springframework.security.authentication.LockedException;
	import org.springframework.security.core.AuthenticationException;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomLoginFailHandler extends SimpleUrlAuthenticationFailureHandler  {
	 
	 @Override
	 public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
	   AuthenticationException exception) throws IOException, ServletException {
		
	  log.error("==========================================");
	  log.error(exception.getStackTrace());
	  
	  String errormsg;
	  
	  if(exception instanceof BadCredentialsException){//비밀번호가 틀린경우
		  //사용자가 입력한 비밀번호가 연속해서 틀릴 경우 계정 잠금 처리기능 위해 분기만 일단 해두고 기능 확장시 쓰자
          
		  errormsg = "아이디가 없거나 비밀번호가 틀립니다.";//보안상 똑같은 결과를 보여줘야한다.
          
      }else if(exception instanceof UsernameNotFoundException){//아이디가 없는 경우
    	  
    	  errormsg = "아이디가 없거나 비밀번호가 틀립니다.";//보안상 똑같은 결과를 보여줘야한다.
    	  
      }else if(exception instanceof LockedException) {
    	  
    	  errormsg = "접속제한 계정입니다.";
          
      }else if(exception instanceof DisabledException) {
    	  
    	  errormsg = "탈퇴한 계정입니다.";
      
      }else {
    	  errormsg = "로그인 할 수 없습니다. 관리자에게 문의해주세요";
      }
	
	  request.setAttribute("AuthenticationFailureMsg", errormsg);
	  request.getRequestDispatcher("/superAdminLogin").forward(request, response);
	}
} 
