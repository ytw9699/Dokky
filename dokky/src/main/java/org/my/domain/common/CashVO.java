package org.my.domain.common;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class CashVO {  
	  private Long cash_num;
	  private String cashKind;
	  private Long cashAmount;
	  private String userId;
	  private String nickName;
	  private String specification;
	  private String title;
	  private String reply_content;
	  private Long board_num;
	  private Date regDate;
}
