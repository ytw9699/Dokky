package org.my.domain.board;
	import lombok.Data;
	
@Data
public class BoardLikeVO {
	  private Long board_num;
	  private String userId;
	  private String likeValue;
}
