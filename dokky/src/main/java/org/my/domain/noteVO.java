package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class noteVO { 
	  private Long note_num;
	  private String content;
	  private String from_nickname;
	  private String from_id;
	  private String to_nickname;
	  private String to_id;
	  private String read_check;
	  private String from_check;
	  private String to_check;
	  private Date regdate;
}
