/*
-  마지막 업데이트 2022-06-13
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.AlarmVO;
	import org.my.domain.CashVO;
	import org.my.domain.CommonVO;
	import org.my.domain.ReportVO;
	import org.my.mapper.AdminMapper;
	import org.my.mapper.CommonMapper;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Log4j
@Service
public class AdminServiceImpl implements AdminService {

	private final AdminMapper adminMapper;
	private final CommonMapper commonMapper;
	
	@Override
	public List<MemberVO> getUserList(Criteria cri) {

		log.info("getMemberList" + cri);

		return adminMapper.getUserList(cri);
	}
	
	@Override
	public int getMemberTotalCount(Criteria cri) {

		log.info("getMemberTotalCount");

		return adminMapper.getMemberTotalCount(cri);
	}
	
	@Override
	public List<CashVO> getCashRequestList(Criteria cri) {

		log.info("getCashRequestList" + cri);

		return adminMapper.getCashRequestList(cri);
	}
	
	@Override
	public int getCashListTotalCount() {

		log.info("getTotalCount");

		return adminMapper.getCashListTotalCount();
	}
	
	@Override
	public List<ReportVO> getUserReportList(Criteria cri){
	
		log.info("getUserReportList" + cri);

		return adminMapper.getUserReportList(cri);
	}
	
	@Override
	public int getUserReportCount(Criteria cri){

		log.info("getUserReportCount");

		return adminMapper.getUserReportCount(cri);
	}
	
	@Override
	public MemberVO getUserForm(String userId) {

		log.info("getUserForm" + userId);

		return adminMapper.getUserForm(userId);
	}
	
	@Transactional
	@Override
	public int limitLogin(String userId, AlarmVO vo) {
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo);
		
		log.info("limitLogin :"+userId);
		 
		return adminMapper.updateAccountNonLocked(userId, 0);
	}
	
	@Transactional
	@Override
	public int permitLogin(String userId, AlarmVO vo) {
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo);
		
		log.info("limitLogin :"+userId);
		 
		return adminMapper.updateAccountNonLocked(userId, 1);
	}
	
	@Transactional
	@Override
	public int insertRole(String userId, String role, AlarmVO vo) {
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo);
		
		log.info("insertRole :"+userId);
		
		return adminMapper.insertRole(userId, role);
	}
	
	@Transactional
	@Override
	public int deleteRole(String userId, String role, AlarmVO vo) {
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo);
		
		log.info("deleteRole :"+userId);
		
		return adminMapper.deleteRole(userId, role);
	}
	
	@Transactional
	@Override
	public int approveCash(CommonVO vo) {

		CashVO cashVO = vo.getCashVO();
		
		if(cashVO.getCashKind().equals("충전")) {
			
			adminMapper.updatePluscash(cashVO);
			
			log.info("updatePluscash");
			
		}else if(cashVO.getCashKind().equals("환전")) {
			
			adminMapper.updateMinuscash(cashVO);
			
			log.info("updateMinuscash");
		}
			
		log.info("insertAlarm");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		return adminMapper.approveCash(cashVO.getCash_num());
	}
}
