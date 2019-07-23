package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class alarmVO {
	  private Long alarmNum;
	  private String checking;
	  private String target;
	  private String writer;
	  private String kind;
	  private String commonVar;
	  private Date regdate;
}
