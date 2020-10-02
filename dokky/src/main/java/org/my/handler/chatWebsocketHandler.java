package org.my.handler;
	import java.util.Date;
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

	
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
    	
    	log.info("chatWebsocketHandler 세션 ="+session);
        
    	String msg = message.getPayload();
        
        ChatMessage chatMessage = objectMapper.readValue(msg, ChatMessage.class);
        
        log.info("chatMessage="+chatMessage);
        
        ChatRoom chatRoom = null;
        
        
        if(chatMessage.getType() == ChatMessageType.OPEN){
        	
        	log.info("MessageType.OPEN");
        	
        	chatRoom = chatService.addChatRoom(chatMessage.getChatRoomNum());
        
        }else if(chatMessage.getType() == ChatMessageType.CLOSED){
        	
        	log.info("MessageType.CLOSED");
        	
       	 	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
       	 	
        }else if(chatMessage.getType() == ChatMessageType.LEAVE){
        	
        	log.info("MessageType.LEAVE");
        	
        	String leaveMessage = chatMessage.getChat_writerNick()+"님이 나갔습니다.";
        	
        	chatMessage.setMessage(leaveMessage);
        	
        	ChatContentVO chatContentVO = new ChatContentVO();
        	
        	chatContentVO.setChatRoomNum(Long.parseLong(chatMessage.getChatRoomNum()));
        	chatContentVO.setChat_content(leaveMessage);
        	
        	log.info("chatContentVO"+chatContentVO);
        	
        	chatService.createNoticeContent(chatContentVO);
        	
        	Long ChatRoomNum = Long.parseLong(chatMessage.getChatRoomNum());
        	
        	chatService.updateOutDate(ChatRoomNum, chatMessage.getChat_writerId());
        	
        	chatService.updateRoomStatus(ChatRoomNum, chatMessage.getChat_writerId());
        	
        	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
        
        }else if(chatMessage.getType() == ChatMessageType.INVITE){
        	
        	log.info("MessageType.INVITE");
	    	
	    }else if(chatMessage.getType() == ChatMessageType.OUT){
	    	
	    	log.info("MessageType.OUT");
	    	
        }else if(chatMessage.getType() == ChatMessageType.CHAT){
    	
	    	log.info("MessageType.CHAT");
	    	
	    	chatMessage.setRegDate(new Date());
	    	
	    	ChatContentVO chatContentVO = new ChatContentVO();
	    	
	    	chatContentVO.setChat_content(chatMessage.getMessage());
	    	chatContentVO.setChat_writerId(chatMessage.getChat_writerId());
	    	chatContentVO.setChat_writerNick(chatMessage.getChat_writerNick());
	    	chatContentVO.setRegDate(chatMessage.getRegDate());
	    	chatContentVO.setChatRoomNum(Long.parseLong(chatMessage.getChatRoomNum()));
	    	
	    	log.info("chatContentVO"+chatContentVO);
	    	
	    	chatService.createChatContent(chatContentVO);
	    	
	    	chatRoom = chatService.findChatRoom(chatMessage.getChatRoomNum());
	    }
        
        chatRoom.handleMessage(session, chatMessage);
    }
    
    @Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{
		
		log.info("chatWebsocketHandler afterConnectionEstablished:" + session);
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		
		log.info("chatWebsocketHandler afterConnectionClosed:" + session + ":" + status);
	}
}
      


