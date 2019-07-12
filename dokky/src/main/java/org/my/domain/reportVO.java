package org.my.domain;
	import java.util.Date;
	import lombok.Data;

@Data
public class reportVO {

	private Long report_num;
	private String reportKind;
	private String reportingId;
	private String reportingNick;
	private String reportedId;
	private String reportedNick;
	private Long board_num;
	private Long reply_num;
	private String reason;
	private Date regDate;
	
}
