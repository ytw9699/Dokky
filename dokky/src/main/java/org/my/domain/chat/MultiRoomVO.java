package org.my.domain.chat;
	import lombok.Data;

@Data
public class MultiRoomVO {
	
	  private String chat_title;//제목
	  private String roomOwnerId;//방장 아이디
	  private String roomOwnerNick;//방장 닉네임
}

