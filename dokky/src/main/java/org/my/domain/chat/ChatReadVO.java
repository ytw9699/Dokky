package org.my.domain.chat;
	import lombok.Data;
	
@Data
public class ChatReadVO {  
	
	  private Long chatReadNum;
	  private Long chatContentNum;
	  private String chat_memberId;
	  private String chat_memberNick;
	  private int read_type;
}

