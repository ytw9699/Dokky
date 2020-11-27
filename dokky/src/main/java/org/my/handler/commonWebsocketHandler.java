package org.my.handler;
	import java.util.HashMap;
import java.util.LinkedHashMap;
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
public class commonWebsocketHandler extends TextWebSocketHandler {
	
	Map<String, Map<String, WebSocketSession>> userSessionsMap = new LinkedHashMap<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{//클라이언트가 서버에 접속한후
		
		log.info("commonWebsocket afterConnectionEstablished:" + session);
		
		String userId = getUserId(session);
		
		Map<String, WebSocketSession> innerMap = userSessionsMap.get(userId);
		
		if(innerMap == null) {
			
			innerMap = new LinkedHashMap<>();
			
			innerMap.put(session.getId(), session);
			
			userSessionsMap.put(userId, innerMap);
			
		}else {
			
			innerMap.put(session.getId(), session);
		}
		
		/*for (String key : userSessionsMap.keySet()) {
			
			log.info("value"+userSessionsMap.get(key));
	    }*/
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {//소켓에다가 메시지를 보냈을때
		
		log.info("commonWebsocket handleTextMessage:" + session + " : " + message);
	
		String msg = message.getPayload();
		
		String[] strs = msg.split(",");
			
		if (strs != null) {
			
			String kind = strs[0];//요청의 종류
			String userId = strs[1];//유저의 아이디
			
			Map<String, WebSocketSession> innerMap = userSessionsMap.get(userId);
			
			for(Map.Entry<String, WebSocketSession> entry : innerMap.entrySet()) {
				
				WebSocketSession userSession = entry.getValue();
				
				if(kind.equals("sendAlarmMsg") && userSession != null) {//모든 알람 메시지
				
					userSession.sendMessage(new TextMessage("allAlarmUpdateRequestToUser"));
				
				}else if(kind.equals("noteAlarm") && userSession != null) {//쪽지를 쓰고 알림 업데이트 요청을 사용자에게 보낸다
					
					userSession.sendMessage(new TextMessage("noteAlarmUpdateRequestToUser"));
					
				}else if(kind.equals("limit") && userSession != null){//요청의 종류가 계정 제한 이고 해당 유저의 세션이 존재한다면
					
					userSession.sendMessage(new TextMessage("limitAndLogoutSuccessMessageToUser"));//유저에게  메시지를 보낸다
					
					session.sendMessage(new TextMessage("limitAndLogoutSuccessMessageToAdmin"));//관리자에게도 메시지를 보낸다
					
				}else if(kind.equals("limit") && userSession == null) {//계정 제한은 하였지만 유저의 세션이 존재하지 않는다면 로그아웃 시키지 않는다.
					
					session.sendMessage(new TextMessage("limitSuccessMessageToAdmin"));//관리자에게만 메시지를 보낸다
				} 
			}
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {//연결이 끊겼을때
		
		log.info("commonWebsocket afterConnectionClosed:" + session + ":" + status);
		
		String userId = getUserId(session);
		
		Map<String, WebSocketSession> innerMap = userSessionsMap.get(userId);
		
		innerMap.remove(session.getId());
		
		if(innerMap.isEmpty()) {
			userSessionsMap.remove(userId);
		}
		
		/*for (String key : userSessionsMap.keySet()) {
			
			log.info("value"+userSessionsMap.get(key));
	    }*/
	}

	private String getUserId(WebSocketSession session) {
		
		SecurityContext context = (SecurityContext)session.getAttributes().get(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);
		//SPRING_SECURITY_CONTEXT를 세션에서 꺼내온다.
		
		CustomUser user = (CustomUser)context.getAuthentication().getPrincipal();//인증된 유저의 정보를 가져온다.
		
		return user.getUsername();//유저 아이디를 반환한다.
	}
}
      
    
