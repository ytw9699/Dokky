package org.my.domain.common;
	import org.my.domain.board.BoardDisLikeVO;
	import org.my.domain.board.BoardLikeVO;
	import org.my.domain.chat.ChatMemberVO;
	import org.my.domain.chat.ChatRoomVO;
	import org.my.domain.reply.ReplyDisLikeVO;
	import org.my.domain.reply.ReplyDonateVO;
	import org.my.domain.reply.ReplyLikeVO;
	import org.my.domain.reply.ReplyVO;
	import lombok.Data;
	
@Data
public class CommonVO { 
	  private CashVO cashVO;
	  private AlarmVO alarmVO;
	  private ReplyVO replyVO;
	  private ReportVO reportVO;
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
