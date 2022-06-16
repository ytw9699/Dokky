package org.my.domain;
	import java.util.Date;
	import lombok.Data;

@Data
public class ReportVO {
		private Long report_num;
		private String reportKind;
		private String reportingId;
		private String reportingNick;
		private String reportedId;
		private String reportedNick;
		private Long board_num;
		private String reason;
		private Date regDate;
}
