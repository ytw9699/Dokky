package org.my.handler;
	import java.io.IOException;
	import java.util.Date;
	import java.util.LinkedHashMap;
	import java.util.Map;
	import org.my.domain.ChatMessage;
	import org.my.domain.ChatRoom;
	import org.my.domain.ChatMessageType;
	import org.my.domain.ChatContentVO;
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
	
	Map<String, String> chatRoomNumMap = new LinkedHashMap<>();
	
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
    	    	
    	    	chatMessage.setRegDate(new Date());
    	    	
    	    	ChatContentVO chatContentVO = new ChatContentVO();
    	    	
    	    	chatContentVO.setChat_content(chatMessage.getMessage());
    	    	chatContentVO.setChat_writerId(chatMessage.getChat_writerId());
    	    	chatContentVO.setChat_writerNick(chatMessage.getChat_writerNick());
    	    	chatContentVO.setRegDate(chatMessage.getRegDate());
    	    	chatContentVO.setChatRoomNum(Long.parseLong(chatMessage.getChatRoomNum()));
    	    	chatContentVO.setReadCount(chatMessage.getHeadCount());
    	    	
    	    	log.info("chatContentVO"+chatContentVO);
    	    	
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
    
    @Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{
		
		log.info("chatWebsocketHandler afterConnectionEstablished:" + session);
		
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		
		log.info("chatWebsocketHandler afterConnectionClosed:" + session + ":" + status);
		
		if(chatRoomNumMap.containsKey(session.getId())){//정상적으로 웹소켓이 닫힌게 아닌 경우 핸들러가 처리한다.
			
			String chatRoomNum = chatRoomNumMap.get(session.getId());
			
			ChatRoom chatRoom = chatService.findChatRoom(chatRoomNum);
			
			if(chatRoom.removeWebSocketSession(session)){
				
				log.info("비정상적인 웹소켓 닫힘이 발생되어, 해당 채팅방에서 웹소켓 객체를 삭제하였습니다.");				
			}
		}
	}
	
	@Override//Handle an error from the underlying WebSocket message transport. 
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		log.info("handleTransportError = " + exception.getMessage());
		log.info("error session = " + session); 
	}
}
      


