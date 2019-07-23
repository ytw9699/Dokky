package org.my.mapper;
	import java.util.List;

import org.my.domain.VisitCountVO;
import org.my.domain.alarmVO;

public interface CommonMapper {

	public int insertVisitor(VisitCountVO vo);

	public int getVisitTodayCount();

	public int getVisitTotalCount();

	public int getAlarmCount();

	public List<alarmVO> getAlarmList();

}
