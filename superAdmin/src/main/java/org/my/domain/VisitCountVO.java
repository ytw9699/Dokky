package org.my.domain;
	import java.util.Date;
	import lombok.Data;
	
@Data
public class VisitCountVO {
	    private Long visitor_num;
	    private String ip;
	    private Date visit_time;
	    private String refer;
	    private String agent;
}


