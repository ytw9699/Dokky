package org.my.domain.common;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class AlarmVO { 
	  private Long alarmNum;
	  private String checking;
	  private String target;
	  private String writerNick;
	  private String writerId;
	  private String kind;
	  private String commonVar1;
	  private String commonVar2;
	  private Long commonVar3;
	  private Date regdate;
}
