package org.my.domain;
	import lombok.Data;
	
@Data
public class BoardDisLikeVO {
	  private Long board_num;
	  private String userId;
	  private String dislikeValue;
}
