package org.my.domain;
	import java.util.Date;
	import java.util.List;
	import org.my.domain.BoardAttachVO;
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
	  private Long hitCnt;
	  private int replyCnt;
	  
	  private List<BoardAttachVO> attachList;//첨부파일관련
}
