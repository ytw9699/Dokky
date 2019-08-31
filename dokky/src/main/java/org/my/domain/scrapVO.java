package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class scrapVO {
	  private int category;
	  private Long num;
	  private String userId;
	  private String nickName; 
	  private String title;
	  private Date regDate;
	  private int replyCnt;
	  private Long hitCnt;
	  private int likeCnt;  
	  private int money;
	  private Long scrap_num;
}
