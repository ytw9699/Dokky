package org.my.mapper;
	import java.util.List;

import org.my.domain.Criteria;
import org.my.domain.VisitCountVO;
import org.my.domain.alarmVO;

public interface CommonMapper {

	public int insertVisitor(VisitCountVO vo);

	public int getVisitTodayCount();

	public int getVisitTotalCount();

	public int getAlarmCount(Criteria cri);

	public List<alarmVO> getAlarmList(Criteria cri);

	public int insertAlarm(alarmVO vo);

}
