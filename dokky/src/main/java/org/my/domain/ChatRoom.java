package org.my.domain;
	import java.io.IOException;
	import java.util.HashSet;
	import java.util.Iterator;
	import org.springframework.web.socket.TextMessage;
	import org.springframework.web.socket.WebSocketSession;
	import com.fasterxml.jackson.databind.ObjectMapper;
	import lombok.Data;
	import lombok.extern.log4j.Log4j;

@Log4j
@Data
public class ChatRoom {
	
    private HashSet<WebSocketSession> sessionsSet = new HashSet<>();//채팅방에 접속해있는 세션들
    
    
    public void handleMessage(WebSocketSession session, ChatMessage chatMessage) throws IOException {
    	
    	log.info("handleMessage");
    	
        if(chatMessage.getType() == ChatMessageType.OPEN){
        	
        	log.info("add session = "+session);
        	
        	sessionsSet.add(session);
        	
        	for(WebSocketSession sessions : sessionsSet){
            	
            	log.info("session"+sessions);
            }
        	
        }else if(chatMessage.getType() == ChatMessageType.CLOSED){
        	
        	log.info("remove session = "+session);
        	
    		sessionsSet.remove(session);
            
        }else if(chatMessage.getType() == ChatMessageType.LEAVE){
        	
        	log.info("remove session LEAVE= "+session);
        	
        	sessionsSet.remove(session);
            
            send(chatMessage);
        
        }else if(chatMessage.getType() == ChatMessageType.INVITE){
        	
	    }else if(chatMessage.getType() == ChatMessageType.OUT){
	    	
	    	log.info("remove session OUT= "+session);
        	
    		sessionsSet.remove(session);
        
        }else if(chatMessage.getType() == ChatMessageType.CHAT){
        	
        	log.info("chat session = "+session);
        	
        	send(chatMessage);
        	
        }else if(chatMessage.getType() == ChatMessageType.READ){
        	
        	log.info("READ session = "+session);
        	
        	send(chatMessage);
        }
    }
    
    public void reEnterChatRoom(ChatMessage chatMessage) throws IOException {
        	
    	log.info("reEnterChatRoom");
        	
    	send(chatMessage);
    }

    private void send(ChatMessage chatMessage)  {
    	
    	try {
    		
    		String customMessage = null;
        	
        	if(chatMessage.getType() == ChatMessageType.CHAT){
            	
            	customMessage = 	"{\"chatRoomNum\":\""+chatMessage.getChatRoomNum()+
        								"\", \"chat_writerNick\":\""+chatMessage.getChat_writerNick()+
        								"\", \"chat_writerId\":\""+chatMessage.getChat_writerId()+
        								"\", \"message\":\""+chatMessage.getMessage()+
        								"\", \"type\":\""+chatMessage.getType()+
        								"\", \"headCount\":\""+chatMessage.getHeadCount()+
        								"\", \"chatContentNum\":\""+chatMessage.getChatContentNum()+
        								"\", \"regDate\":\""+chatMessage.getRegDate().getTime()+"\"}";
            	
            }else if(chatMessage.getType() == ChatMessageType.LEAVE){
            	
            	customMessage = 	"{\"message\":\""+chatMessage.getMessage()+
            							"\", \"type\":\""+chatMessage.getType()+
            							"\", \"chat_writerId\":\""+chatMessage.getChat_writerId()+
    				        			"\", \"regDate\":\""+chatMessage.getRegDate().getTime()+"\"}";
            
            }else if(chatMessage.getType() == ChatMessageType.IN){
            	
            	customMessage = 	"{\"message\":\""+chatMessage.getMessage()+
            							"\", \"type\":\""+chatMessage.getType()+
    				        			"\", \"regDate\":\""+chatMessage.getRegDate().getTime()+"\"}";
            
            }else if(chatMessage.getType() == ChatMessageType.READ){
            	
            	customMessage = 	"{\"chatContentNum\":\""+chatMessage.getChatContentNum()+
    					"\", \"type\":\""+chatMessage.getType()+"\"}";
            }
        	
        	TextMessage textMessage = new TextMessage(customMessage); 
        	
        	for(WebSocketSession session : sessionsSet){
            	
            	log.info("session"+session);
            }
        	 
            Iterator<WebSocketSession> iterator = sessionsSet.iterator();
            
            while(iterator.hasNext()){
            	
	            	WebSocketSession session = iterator.next();
	            	
	            	log.info(session);
	            	log.info("textMessage"+textMessage);
	            	
	            	if(session.isOpen()) {
	            		
	            		log.info("send message ="+session);
	            		session.sendMessage(textMessage);
	            		
	            	}else{
	            		
	            		log.info("remove session ="+session);
	            		iterator.remove();
	            	}
            }
            
    	} catch (IOException e) {
    		e.printStackTrace();
    	}
    }
}