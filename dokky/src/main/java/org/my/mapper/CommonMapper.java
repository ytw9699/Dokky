package org.my.mapper;
	import org.my.domain.VisitCountVO;

public interface CommonMapper {

	public int insertVisitor(VisitCountVO vo);

	public int getVisitTodayCount();

	public int getVisitTotalCount();

}
