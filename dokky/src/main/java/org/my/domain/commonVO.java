package org.my.domain;
	import lombok.Data;
	
@Data
public class commonVO { 
	  private CashVO cashVO;
	  private AlarmVO alarmVO;
	  private ReplyVO replyVO;
	  private reportVO reportVO;
	  private BoardLikeVO boardLikeVO;
	  private BoardDisLikeVO boardDisLikeVO;
	  private DonateVO donateVO;
	  private ReplyDonateVO replyDonateVO;
	  private ReplyLikeVO replyLikeVO;
	  private ReplyDisLikeVO replyDisLikeVO;
	  private ChatRoomVO chatRoomVO;
	  private ChatMemberVO chatMemberVO;
	  private ChatMemberVO[] chatMemberVoArray;
}
