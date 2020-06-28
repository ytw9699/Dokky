package org.my.handler;
	import java.util.HashMap;
	import java.util.Map;
	import org.my.security.domain.CustomUser;
	import org.springframework.security.core.context.SecurityContext;
	import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
	import org.springframework.web.socket.CloseStatus;
	import org.springframework.web.socket.TextMessage;
	import org.springframework.web.socket.WebSocketSession;
	import org.springframework.web.socket.handler.TextWebSocketHandler;
	import lombok.extern.log4j.Log4j;
	
@Log4j 
public class websocketHandler extends TextWebSocketHandler {
	
	Map<String, WebSocketSession> userSessions = new HashMap<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{//클라이언트가 서버에 접속한후
		
		log.info("afterConnectionEstablished:" + session);
		
		String userId = getUserId(session);
		
		userSessions.put(userId, session);//로그인한 유저들의 세션을 (키가 아이디의 값으로) 보관해둔다. 
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {//소켓에다가 메시지를 보냈을때
		
		log.info("handleTextMessage:" + session + " : " + message);
	
		String msg = message.getPayload();
		
		String[] strs = msg.split(",");
			
			if (strs != null) {
				
				String kind = strs[0];//요청의 종류
				String userId = strs[1];//유저의 아이디
				
				WebSocketSession userSession = userSessions.get(userId);//유저 아이디에 해당하는 웹소켓 세션을 가져온다.
				
				if(kind.equals("limit") && userSession != null){//요청의 종류가 계정 제한 이고 해당 유저의 세션이 존재한다면
					
					userSession.sendMessage(new TextMessage("logout"));//유저에게 로그아웃 메시지를 보낸다
				}
			}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {//연결이 끊겼을때
		System.out.println("afterConnectionClosed:" + session + ":" + status);
	}

	private String getUserId(WebSocketSession session) {
		
		SecurityContext context = (SecurityContext)session.getAttributes().get(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);
		//SPRING_SECURITY_CONTEXT를 세션에서 꺼내온다.
		
		CustomUser user = (CustomUser)context.getAuthentication().getPrincipal();//인증된 유저의 정보를 가져온다.
		
		return user.getUsername();//유저 아이디를 반환한다.
	}
}
      
    
