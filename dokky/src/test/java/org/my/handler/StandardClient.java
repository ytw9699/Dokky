/*package org.my.handler;
	import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.client.WebSocketClient;
	import org.springframework.web.socket.client.WebSocketConnectionManager;
	import org.springframework.web.socket.client.standard.StandardWebSocketClient;

public class StandardClient{
	
	public static void main(String[] args) {
		String address = "wss://dokky.site/";
		
		WebSocketClient client = new StandardWebSocketClient();
		
		WebSocketConnectionManager websockManager = new WebSocketConnectionManager(
				new StandardWebSocketClient(), 
				new chatWebsocketHandler(), 
				"/a"
				);
		
		public WebSocketConnectionManager(WebSocketClient client,
				WebSocketHandler webSocketHandler, String uriTemplate, Object... uriVariables) {

			super(uriTemplate, uriVariables);
			this.client = client;
			this.webSocketHandler = decorateWebSocketHandler(webSocketHandler);
		}
		
		 WebSocketConnectionManager manager = new WebSocketConnectionManager(client, chatWebsocketHandler , "/a");
		 
		 manager.startInternal();
		 assertTrue(client.isRunning());
		 manager.stopInternal();
		 assertFalse(client.isRunning());
		  
	}
}*/