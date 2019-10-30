package org.my.domain;
	import lombok.Data;

@Data
public class BoardAttachVO {
	  private String uuid;
	  private String uploadPath;
	  private String fileName;
	  private Long board_num;
	  private boolean fileType;
}
