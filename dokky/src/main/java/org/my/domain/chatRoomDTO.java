package org.my.domain;
	import java.util.List;
	import lombok.AllArgsConstructor;
	import lombok.Data;

@Data
@AllArgsConstructor
public class chatRoomDTO {
	  private ChatRoomVO chatRoomVo;
	  private ChatContentVO chatContentVo;
	  private List<ChatReadVO> chatReadVoList;
	  private int notReadCnt;
}

/*public chatRoomDTO(ChatRoomVO chatRoomVo, ChatContentVO chatContentVo, List<ChatReadVO> chatReadVoList, int notReadCnt) {

    this.chatRoomVo = chatRoomVo;
    this.chatContentVo = chatContentVo;
    this.chatReadVoList = chatReadVoList;
    this.notReadCnt = notReadCnt;
}*/