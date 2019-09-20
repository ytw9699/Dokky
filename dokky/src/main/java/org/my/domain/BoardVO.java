package org.my.domain;
	import java.util.Date;
	import java.util.List;
	import org.my.domain.BoardAttachVO;
	import lombok.Data;
	
@Data//생성자와 getter/setter, toString()
public class BoardVO {
	  private int category;
	  private Long board_num;
	  private String title;
	  private String nickName;
	  private String userId;
	  private String content;
	  private String blind;
	  private Date regDate;
	  private Date updateDate;
	  private int likeCnt;
	  private int dislikeCnt;
	  private int money;
	  private Long hitCnt;
	  private int replyCnt;
	  private String delete_check;
	  private List<BoardAttachVO> attachList;//첨부파일관련
}
