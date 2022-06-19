package org.my.handler;
	import java.util.ArrayList;
	import java.util.HashMap;
	import java.util.Map;
	import org.springframework.web.socket.CloseStatus;
	import org.springframework.web.socket.TextMessage;
	import org.springframework.web.socket.WebSocketSession;
	import org.springframework.web.socket.handler.TextWebSocketHandler;
	import lombok.extern.log4j.Log4j;
	
@Log4j 
public class CommonWebsocketHandler extends TextWebSocketHandler {
	
	Map<String, ArrayList<WebSocketSession>> userSessionsMap = new HashMap<>();//중복된 유저의 웹소켓 객체들을 아이디 별로 맵에 관리 
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {//소켓에다가 메시지를 보냈을때
		
		log.info("commonWebsocket handleTextMessage session=" + session + " : message=" + message);
		
		String msg = message.getPayload();
		
		String[] strs = msg.split(",");
			
		if (strs != null) {
			
			String kind = strs[0];//요청의 종류
			String userId = strs[1];//유저의 아이디
			
			ArrayList<WebSocketSession> userSessionList = userSessionsMap.get(userId);
			
			if(userSessionList != null) {
				
				for(WebSocketSession userSession : userSessionList) {
					
					if(kind.equals("sendAlarmMsg") && userSession != null){//모든 알람 메시지
					
						userSession.sendMessage(new TextMessage("allAlarmUpdateRequestToUser"));
					
					}else if(kind.equals("noteAlarm") && userSession != null){//쪽지를 쓰고 알림 업데이트 요청을 사용자에게 보낸다
						
						userSession.sendMessage(new TextMessage("noteAlarmUpdateRequestToUser"));
						
					}else if(kind.equals("chatAlarm") && userSession != null){//채팅 메시지를 보내고 알림 업데이트 요청을 사용자에게 보낸다
						
						userSession.sendMessage(new TextMessage("chatAlarmUpdateRequestToUser"));
						
					}else if(kind.equals("limit") && userSession != null) {//접속 제한
							userSession.sendMessage(new TextMessage("limitAndLogoutSuccessMessageToUser"));//유저에게 메시지를 보낸다
						}
					}
				}
			}
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{//클라이언트가 서버에 접속한후
		
		log.info("commonWebsocket afterConnectionEstablished session=" + session);
		
		String userId = getUserId(session);
		
		ArrayList<WebSocketSession> userSessionList = userSessionsMap.get(userId);
		
		if(userSessionList == null) {
			
			userSessionList = new ArrayList<>();
			
			userSessionList.add(session);
			
			userSessionsMap.put(userId, userSessionList);
			
		}else {
			
			userSessionList.add(session);
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {//연결이 끊겼을때
		
		log.info("commonWebsocket afterConnectionClosed session=" + session + ": status=" + status);
		
		String userId = getUserId(session);
		
		ArrayList<WebSocketSession> userSessionList = userSessionsMap.get(userId);
		
		if(userSessionList != null) {
			
			userSessionList.remove(session);//해당 유저의 객체를 삭제
			
			if(userSessionList.isEmpty()){
				userSessionsMap.remove(userId);
			}
		}
	}
	
	@Override//Handle an error from the underlying WebSocket message transport. 
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		log.info("commonWebsocket handleTransportError = " + exception.getMessage());
		log.info("commonWebsocket error session = " + session); 
	}
	
	private String getUserId(WebSocketSession session) {
		log.info("commonWebsocket getUserId="+(String)session.getAttributes().get("userId")); 
		return (String)session.getAttributes().get("userId");
	}
}
      
    
