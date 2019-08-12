package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.VisitCountVO;
	import org.my.domain.alarmVO;
	import org.my.mapper.CommonMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CommonServiceImpl implements CommonService {

	@Setter(onMethod_ = @Autowired)
	private CommonMapper mapper;
	
	@Override 
	public boolean insertVisitor(VisitCountVO vo) {  

		log.info("insertVisitor..." + vo); 
		 
		return mapper.insertVisitor(vo) == 1 ;
	}
	
	@Override 
	public int getVisitTodayCount() {
		
		log.info("getVisitTodayCount..."); 
		
		return mapper.getVisitTodayCount();
	}
	
	@Override 
	public int getVisitTotalCount() {
		
		log.info("getVisitTotalCount..."); 
		
		return mapper.getVisitTotalCount();
	}
	
	@Override 
	public int getAlarmCount(Criteria cri) {
		log.info("getAlarmCount");
		
		return mapper.getAlarmCount(cri);
	}
	@Override 
	public String getAlarmRealCount(String userId) {
		log.info("getAlarmRealCount");
		
		return mapper.getAlarmRealCount(userId);
	}
	
	@Override
	public List<alarmVO> getAlarmList(Criteria cri){
		log.info("getAlarmList");
		
		return mapper.getAlarmList(cri);
	}
	
	@Override
	public boolean deleteAllAlarm(Long alarmNum) {

		log.info("remove...." + alarmNum);

		return mapper.deleteAllAlarm(alarmNum) == 1;
	}
	
	@Override 
	public int insertAlarm(alarmVO vo) {  

		log.info("insertAlarm..." + vo); 
		 
		return mapper.insertAlarm(vo) ;
	}
	
	@Override
	public int updateAlarmCheck(String alarmNum){
		log.info("updateAlarmCheck");
		
		return mapper.updateAlarmCheck(alarmNum);
	}
	
	
}
