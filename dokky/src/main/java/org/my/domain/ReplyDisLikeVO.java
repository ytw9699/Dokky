package org.my.domain;
	import lombok.Data;
	
@Data
public class ReplyDisLikeVO {
	  private Long reply_num;
	  private String userId;
	  private String dislikeValue;
}
