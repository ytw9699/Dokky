package org.my.domain;
	import lombok.Data;
	
@Data
public class replyDonateVO { 
	  private Long reply_num;//댓글번호
	  private String userId;//기부하는 아이디
	  private String boardId;//기부받는 아이디
	  private int money;//기부금액
	  private int cash;//내 캐시
	
}