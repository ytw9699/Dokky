package org.my.service;
	import org.my.domain.VisitCountVO;

public interface CommonService {
	 
	public boolean insertVisitor(VisitCountVO vo);

	public int getVisitTodayCount();

	public int getVisitTotalCount();
	
}
