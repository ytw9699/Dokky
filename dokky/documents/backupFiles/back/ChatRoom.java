package org.my.chat.domain;
	import com.fasterxml.jackson.databind.ObjectMapper;
	import lombok.Data;
	import lombok.Getter;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	import org.my.service.ChatServiceImpl;
	import org.springframework.web.socket.TextMessage;
	import org.springframework.web.socket.WebSocketSession;
	import java.io.IOException;

@Log4j
@Data
public class ChatRoom {
	
    private String roomId;
    private String name;//채팅방 이름
    //private HashSet<WebSocketSession> sessionsSet = new HashSet<>();//채팅방에 접속해있는 세션들
    private Map<String, WebSocketSession> sessionsMap = new LinkedHashMap<>();//채팅방에 접속해있는 세션들
    
    public static ChatRoom create(String name){
    	
        ChatRoom chatRoom = new ChatRoom();
        chatRoom.roomId = UUID.randomUUID().toString();
        chatRoom.name = name;
        return chatRoom;
    }

    public void handleMessage(WebSocketSession session, ChatMessage chatMessage, ObjectMapper objectMapper) throws IOException {
    	
    	log.info("handleMessage="+session+chatMessage+objectMapper);
    	
        if(chatMessage.getType() == ChatMessageType.ENTER){
        	
        	log.info("sessionsMap.put="+session);
        	
        	sessionsMap.put(session.getId(), session);
            
            chatMessage.setMessage(chatMessage.getWriter() + "님이 입장하셨습니다.");
        }
        else if(chatMessage.getType() == ChatMessageType.LEAVE){
        	
        	log.info("sessionsMap.remove"+session);
        	sessionsMap.remove(session.getId());
            
            chatMessage.setMessage(chatMessage.getWriter() + "님임 퇴장하셨습니다.");
        }
        else{
        	
            chatMessage.setMessage(chatMessage.getWriter() + " : " + chatMessage.getMessage());
        }
        
        send(chatMessage, objectMapper);
    }

    private void send(ChatMessage chatMessage, ObjectMapper objectMapper) throws IOException {
    	
        TextMessage textMessage = new TextMessage(objectMapper.writeValueAsString(chatMessage.getMessage()));
        
        
        for( Map.Entry<String, WebSocketSession> map : sessionsMap.entrySet() ){
        	
        	WebSocketSession sess = map.getValue();
        	
        	String key = map.getKey();
        	
        	log.info("sess="+sess);
        	
        	if(sess.isOpen()) {
        		
        		log.info("sendmessage="+sess);
        		
        		sess.sendMessage(textMessage);//채팅방 모든 사람에게 메시지 보내는것
        	
        	}else{
        		
        		log.info("remove="+sess);
        		sessionsMap.remove(key);
        	}
        	
        }
	
      /*  for(WebSocketSession sess : sessionsMap){
        	
        	log.info("sess="+sess);
        	
        	if(sess.isOpen()) {
        		
        		log.info("sendmessage="+sess);
        		
        		sess.sendMessage(textMessage);//채팅방 모든 사람에게 메시지 보내는것
        	
        	}else{
        		
        		log.info("remove="+sess);
        		sessionsMap.remove(sess);
        	}
        }*/
    }
}