package org.my.domain;
	import lombok.Data;
	
@Data
public class ChatReadVO {  
	
	  private Long chatReadNum;
	  private Long chatContentNum;
	  private String chat_memberId;
	  private int read_type;
}

