package org.my.domain.chat;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class ChatMemberVO {  
	
	  private Long chatRoomNum;
	  private String chat_memberId;
	  private String chat_memberNick;
	  private Date recentOutDate;
	  private int present_position;
}
