package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data//생성자와 getter/setter, toString()
public class BoardVO {
	  private int category;
	  private Long num;
	  private String title;
	  private String nickName;
	  private String content;
	  private String status;
	  private Date regDate;
	  private Date updateDate;
	  private int up;
	  private int down;
	  private int money;
	  private int hitCnt;
	  private int replyCnt;
}
