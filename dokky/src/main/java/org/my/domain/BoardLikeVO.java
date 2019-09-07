package org.my.domain;
	import lombok.Data;
	
@Data
public class BoardLikeVO {
	  private Long board_num;
	  private String userId;
	  private String likeValue;
}
