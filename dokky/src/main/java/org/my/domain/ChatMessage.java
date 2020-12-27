package org.my.domain;
	import java.util.Date;
	import lombok.Data;

@Data
public class ChatMessage {
	
    private String chatRoomNum;
    private Long chatContentNum;
    private String chat_writerId;
    private String chat_writerNick;
    private String message;
    private Date regDate;
    private int headCount;
    private String memberIds;
    private String memberNicks;
    private ChatMessageType type;
}

