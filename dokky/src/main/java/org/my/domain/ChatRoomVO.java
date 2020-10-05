package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class ChatRoomVO {  
	
	  private Long chatRoomNum;
	  private String chat_title;
	  private String roomOwnerId;
	  private String roomOwnerNick;
	  private int chat_type;
	  private int headCount;
	  private Date regDate;
}
