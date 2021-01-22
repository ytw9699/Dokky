package org.my.handler;
	import static org.junit.Assert.assertNotNull;
	import org.junit.FixMethodOrder;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.junit.runners.MethodSorters;
	import org.my.domain.ChatMessage;
	import org.my.domain.ChatMessageType;
	import org.my.domain.ChatRoom;
	import org.my.service.ChatService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.springframework.web.socket.WebSocketSession;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	  "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	  "file:src/main/webapp/WEB-INF/spring/security-context.xml"	
	  })
@Log4j
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class chatRoomTests {

	@Setter(onMethod_ = @Autowired)
	private ChatService chatService;
	
	public static WebSocketSession session1;
	public static WebSocketSession session2;
	public static WebSocketSession session3;
	public static ChatRoom chatRoom;
	
	@Test
	public void test1_AddChatRoom() throws Exception {
		
		chatRoom = chatService.addChatRoom("1000");
		assertNotNull(chatRoom);
	}
	
	@Test
	public void test2_OpenChatRoom() throws Exception {
		
		ChatMessage chatMessage = new ChatMessage();
		chatMessage.setType(ChatMessageType.OPEN);
		
		session1 = new testWebSocketSession();
		session2 = new testWebSocketSession();
		session3 = new testWebSocketSession();
		chatRoom.handleMessage(session1, chatMessage);
		chatRoom.handleMessage(session2, chatMessage);
		chatRoom.handleMessage(session3, chatMessage);
	}
	
	@Test
	public void test3_checkThreadSafe() throws Exception {
		
		for(int i=0; i<10; i++) {
        
        	new Thread(() -> {
        		chatRoom.testReadWebSocketSession();
            }).start();
        }
        
		chatRoom.removeWebSocketSession(session3);
	}
}
