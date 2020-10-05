package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class ChatMemberVO {  
	
	  private Long chatRoomNum;
	  private String chat_memberId;
	  private String chat_memberNick;
	  private Date recentOutDate;
}
