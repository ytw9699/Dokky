package org.my.domain;
	import lombok.Data;
	
@Data
public class commonVO { 
	  private cashVO cashVO;
	  private AlarmVO alarmVO;
	  private ReplyVO replyVO;
	  private reportVO reportVO;
	  private BoardLikeVO boardLikeVO;
	  private BoardDisLikeVO boardDisLikeVO;
	  private donateVO donateVO;
	  private replyDonateVO replyDonateVO;
	  private ReplyLikeVO replyLikeVO;
	  private ReplyDisLikeVO replyDisLikeVO;
	  private ChatRoomVO chatRoomVO;
	  private ChatMemberVO chatMemberVO;
	  private ChatMemberVO[] chatMemberVoArray;
}
