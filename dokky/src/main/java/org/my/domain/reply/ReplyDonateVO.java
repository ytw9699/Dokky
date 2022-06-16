package org.my.domain.reply;
	import lombok.Data;
	
@Data
public class ReplyDonateVO { 
	  private Long board_num;//글번호
	  private Long reply_num;//댓글번호
	  private String userId;//기부하는 아이디
	  private String donatedId;//기부받는 아이디
	  private int money;//기부금액
	  private int cash;//내 캐시
}
