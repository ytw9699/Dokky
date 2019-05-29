package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data//생성자와 getter/setter, toString()
public class BoardVO {
	  private int KIND;
	  private Long NUM;
	  private String TITLE;
	  private String NICKNAME;
	  private String CONTENT;
	  private String STATUS;
	  private Date REGDATE;
	  private Date UPDATEDATE;
	  private int UP;
	  private int DOWN;
	  private int MONEY;
	  private int HITCNT;
	  private int REPLYCNT;
}
