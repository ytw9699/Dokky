package org.my.domain;
	import lombok.Data;
	
@Data
public class DonateVO { 
	  private Long board_num;//글번호
	  private String userId;//기부하는 아이디
	  private String nickName;//기부하는 닉네임
	  private String donatedId;//기부받는 아이디
	  private String donatedNickName;//기부받는 닉네임
	  private int money;//기부금액
	  private int cash;//내 캐시
}
