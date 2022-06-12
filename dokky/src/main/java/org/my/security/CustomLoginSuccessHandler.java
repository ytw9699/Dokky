/*
- 마지막 업데이트 2022-05-31
- 슈퍼 관리자 인증 성공시 후처리 핸들링
- 1. 인증후 사용자 로긴 날짜 업데이트
- 2. 인증후 웹소켓 세션 관리를 위한 사용자별 아이디 세션에 저장
- 3. 인증후 로그인전 페이지로 이동
- 4. 세션에 저장해둔  preUrl 삭제
*/
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
	import org.springframework.security.web.savedrequest.SavedRequest; 

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, 
			Authentication auth) throws IOException, ServletException {

		 	 log.warn("onAuthenticationSuccess");
		 	
		 	 CustomUser user = (CustomUser)auth.getPrincipal();
			 
			 String userId = user.getUsername();
			 
			 HttpSession session = request.getSession();
			 
			 String preUrl = (String)session.getAttribute("preUrl");
			 
			 String securitySavedUrl = null;
			 
			 SavedRequest saveRequest = (SavedRequest)request.getSession().getAttribute("SPRING_SECURITY_SAVED_REQUEST");
			 
			 if(saveRequest != null) {
				 securitySavedUrl = saveRequest.getRedirectUrl();
			 }
			 
			 setWebsocketUserId(userId, session);
			 
			 updateLoginDate(userId, commonService);
			 
			 if(securitySavedUrl != null) {//1순위 : 시큐리티가 저장해둔 인증이 필요했던 이전 페이지 이동
				 
				 removePreUrl(session);
	             response.sendRedirect(securitySavedUrl);
			
			 }else if(preUrl != null) {//2순위: 인증이 필요없는 이전의 페이지로 이동
				
				removePreUrl(session);
				response.sendRedirect(preUrl);
	              
			 }else { 
				
	        	 response.sendRedirect("/admin/userList");//3순위 : 슈퍼관리자 기본 디폴트 페이지 이동
	         }
	}
	
	private void setWebsocketUserId(String userId, HttpSession session) {
		session.setAttribute("userId", userId);//웹소켓이 끊겼을때 사용하기 위해 세션에 아이디 저장
	}
	
	private void updateLoginDate(String userId, CommonService commonService){
		 commonService.updateLoginDate(userId);
	}
	
	private void removePreUrl(HttpSession session) {
		 session.removeAttribute("preUrl");
	}
}


