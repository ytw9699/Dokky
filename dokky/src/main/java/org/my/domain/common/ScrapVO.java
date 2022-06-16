package org.my.domain.common;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class ScrapVO {
	  private int category;
	  private Long board_num;
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
