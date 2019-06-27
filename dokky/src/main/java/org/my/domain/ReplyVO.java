package org.my.domain;

import java.util.Date;
import lombok.Data;

@Data
public class ReplyVO {

  private Long reply_num;
  private Long num;
  private String reply_content;
  private String nickName;
  private String userId;
  private Date replyDate;
  private Date updateDate;
  private int up;
  private int down;
  private int money;

	  
}
