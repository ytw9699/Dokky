package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class ChatContentVO {  
	
	  private Long chatContentNum;
	  private Long chatRoomNum;
	  private String chat_content;
	  private String chat_writerId;
	  private String chat_writerNick;
	  private int content_type;
	  private int readCount;
	  private int read_type;
	  private Date regDate;
}

