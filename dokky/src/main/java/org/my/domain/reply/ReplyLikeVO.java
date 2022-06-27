package org.my.domain.reply;
	import lombok.Data;
	
@Data
public class ReplyLikeVO {
	  private Long reply_num;
	  private String userId;
	  private String likeValue;
}
