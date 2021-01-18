package org.my.handler;
	import java.io.BufferedWriter;
	import java.io.FileWriter;
	import java.io.IOException;
	import java.util.Date;
	import java.util.HashMap;
	import java.util.Map;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMessage;
	import org.my.domain.ChatMessageType;
	import org.my.domain.ChatRoom;
	import org.my.service.ChatService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.web.socket.CloseStatus;
	import org.springframework.web.socket.TextMessage;
	import org.springframework.web.socket.WebSocketSession;
	import org.springframework.web.socket.handler.TextWebSocketHandler;
	import com.fasterxml.jackson.databind.ObjectMapper;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j 
@Service
public class chatWebsocketHandler extends TextWebSocketHandler {
	
	@Setter(onMethod_ = @Autowired)
	private ChatService chatService;
	
	@Setter(onMethod_ = @Autowired)
    private ObjectMapper objectMapper;
	
	Map<String, String> chatRoomNumMap = new HashMap<>();
	
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message){
    	
    	try {
    		
    		log.info("chatWebsocketHandler 세션 ="+session);
            
        	String msg = message.getPayload();
            
            ChatMessage chatMessage = objectMapper.readValue(msg, ChatMessage.class);
            
            log.info("chatMessage="+chatMessage);
            
            ChatRoom chatRoom = null;
            
            
            if(chatMessage.getType() == ChatMessageType.OPEN){//기존의 채팅 방을 열때 or 내가 채팅방을 새롭게 만들때
            	
            	log.info("MessageType.OPEN");
            	
            	chatRoom = chatService.addChatRoom(chatMessage.getChatRoomNum());
            	
            	chatRoomNumMap.put(session.getId(), chatMessage.getChatRoomNum());
            
            }else if(chatMessage.getType() == ChatMessageType.CLOSED){//방을 닫을때
            	
            	log.info("MessageType.CLOSED");
            	
           	 	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
           	 	
           	 	chatRoomNumMap.remove(session.getId());
           	 	
            }else if(chatMessage.getType() == ChatMessageType.LEAVE){//방에서 나갈때
            	
            	log.info("MessageType.LEAVE");
            	
            	Long ChatRoomNum = Long.parseLong(chatMessage.getChatRoomNum());
            	
            	if(chatService.getRoomHeadCount(ChatRoomNum) == 1){//남아있는 방 인원수가 1명이라면
            		
            		if(chatService.removeAllChatData(ChatRoomNum)){//해당 채팅방 관련 모든 데이터 삭제 
            		
            			return;
            		}
            		
            	}else{
            		
            		String leaveMessage = chatMessage.getChat_writerNick()+"님이 나갔습니다";

                	chatMessage.setMessage(leaveMessage);
                	
                	chatMessage.setRegDate(new Date());
                	
                	ChatContentVO chatContentVO = new ChatContentVO();
                	
                	chatContentVO.setChatRoomNum(ChatRoomNum);
                	chatContentVO.setChat_content(leaveMessage);
                	chatContentVO.setRegDate(chatMessage.getRegDate());
                	
                	chatService.createNoticeContent(chatContentVO);
                	
                	chatService.updateOutDate(ChatRoomNum, chatMessage.getChat_writerId(), new Date());//나간 날짜 기록
                	
                	chatService.updateRoomStatus(ChatRoomNum, chatMessage.getChat_writerId(), -1, 1);
                	
                	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
                	
                	chatRoomNumMap.remove(session.getId());
            	}
            
            }else if(chatMessage.getType() == ChatMessageType.INVITE){//초대할때
            	
            	log.info("MessageType.INVITE");
    	    	
    	    }else if(chatMessage.getType() == ChatMessageType.TITLE){//제목 바꿀때
    	    	
    	    	log.info("MessageType.TITLE");
    	    	
    	    	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
    	    	
            }else if(chatMessage.getType() == ChatMessageType.CHAT){//채팅할때
        	
    	    	log.info("MessageType.CHAT");
    	    	
    	    	Long ChatRoomNum = Long.parseLong(chatMessage.getChatRoomNum());
    	    	
    	    	int headCount = chatService.getHeadCount(ChatRoomNum);
    	    	
    	    	chatMessage.setHeadCount(headCount);
    	    	chatMessage.setRegDate(new Date());
    	    	
    	    	ChatContentVO chatContentVO = new ChatContentVO();
			    	    	  chatContentVO.setChat_content(chatMessage.getMessage());
			    	    	  chatContentVO.setChat_writerId(chatMessage.getChat_writerId());
			    	    	  chatContentVO.setChat_writerNick(chatMessage.getChat_writerNick());
			    	    	  chatContentVO.setRegDate(chatMessage.getRegDate());
			    	    	  chatContentVO.setChatRoomNum(ChatRoomNum);
			    	    	  chatContentVO.setReadCount(headCount);
			    	    	
    	    	chatService.createChatContent(chatContentVO);
    	    	
    	    	chatMessage.setChatContentNum(chatContentVO.getChatContentNum());
    	    	
    	    	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
    	    	
    	    }else if(chatMessage.getType() == ChatMessageType.READ){
    	    	
    	    	log.info("MessageType.READ");
    	    	
    	    	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
    	    	
            }
            
            chatRoom.handleMessage(session, chatMessage);
    		
    	} catch (IOException e) {
    		System.out.println("오류가 발생했습니다 : ");
    		e.printStackTrace();
    	}
    }
    
    @Override//웹소켓 클라이언트가 연결되면 호출된다.
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{
		
		log.info("chatWebsocketHandler afterConnectionEstablished:" + session);
		
	}
	
	@Override//웹소켓 클라이언트가 언결을 직접 끊거나 서버에서 타임아웃이 발생해서 연결을 끊을때 호출된다.
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		
		log.info("chatWebsocketHandler afterConnectionClosed:" + session + ":" + status);
		
		String sessionId = session.getId();
		
		if(chatRoomNumMap.containsKey(sessionId)){//웹소켓이 끊기면 핸들러가 처리한다.
			
			String chatRoomNum = chatRoomNumMap.get(sessionId);
			
			ChatRoom chatRoom = chatService.findChatRoom(chatRoomNum);
			
			chatRoomNumMap.remove(sessionId);
			
			if(chatRoom.removeWebSocketSession(session)) {
				
				log.info("해당 채팅방에서 웹소켓 객체를 삭제하였습니다.");				
			}
		}
	}
	
	@Override//Handle an error from the underlying WebSocket message transport. 웹소켓 클라이언트와의 연결에 문세가 발생하면 호출된다.
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		log.info("handleTransportError = " + exception.getMessage());
		log.info("error session = " + session); 
	}
}
      


