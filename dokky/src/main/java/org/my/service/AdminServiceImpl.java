package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.alarmVO;
	import org.my.domain.cashVO;
	import org.my.domain.commonVO;
	import org.my.domain.reportVO;
	import org.my.mapper.AdminMapper;
	import org.my.mapper.CommonMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class AdminServiceImpl implements AdminService {

	@Setter(onMethod_ = @Autowired)
	private AdminMapper adminMapper;
	
	@Setter(onMethod_ = @Autowired)
	private CommonMapper commonMapper;
	
	@Override
	public List<MemberVO> getUserList(Criteria cri) {

		log.info("getMemberList: " + cri);

		return adminMapper.getUserList(cri);
	}
	
	@Override
	public int getMemberTotalCount(Criteria cri) {

		log.info("getMemberTotalCount: ");

		return adminMapper.getMemberTotalCount(cri);
	}
	
	@Override
	public List<cashVO> getCashRequestList(Criteria cri) {

		log.info("getCashRequestList: " + cri);

		return adminMapper.getCashRequestList(cri);
	}
	
	@Override
	public int getCashListTotalCount() {

		log.info("getTotalCount: ");

		return adminMapper.getCashListTotalCount();
	}
	
	@Override
	public List<reportVO> getUserReportList(Criteria cri){
	
		log.info("getUserReportList: " + cri);

		return adminMapper.getUserReportList(cri);
	}
	
	@Override
	public int getUserReportCount(Criteria cri){

		log.info("getUserReportCount: ");

		return adminMapper.getUserReportCount(cri);
	}
	
	@Override
	public MemberVO getUserForm(String userId) {

		log.info("getUserForm: " + userId);

		return adminMapper.getUserForm(userId);
	}
	
	@Transactional
	@Override
	public int updateRoleLimit(String userId, alarmVO vo) {
		
		log.info("insertAlarm: ");
		
		commonMapper.insertAlarm(vo);
		
		log.info("updateRoleLimit.."+userId);
		
		return adminMapper.updateRoleLimit(userId);
	}
	
	@Transactional
	@Override
	public int updateRoleStop(String userId,alarmVO vo) {
		
		log.info("insertAlarm: ");
		
		commonMapper.insertAlarm(vo);
		
		log.info("updateRoleStop.."+userId);
		
		return adminMapper.updateRoleStop(userId);
	}
	
	@Transactional
	@Override
	public int updateRoleUser(String userId, alarmVO vo) {
		
		log.info("insertAlarm: ");
		
		commonMapper.insertAlarm(vo);
		
		log.info("updateRoleUser.."+userId);
		
		return adminMapper.updateRoleUser(userId);
	}
	
	@Transactional
	@Override
	public int updateRoleAdmin(String userId, alarmVO vo) {
		
		log.info("insertAlarm: ");
		
		commonMapper.insertAlarm(vo);
		
		log.info("updateRoleAdmin.."+userId);
		
		return adminMapper.updateRoleAdmin(userId);
	}
	
	@Transactional
	@Override
	public int updateApprove(commonVO vo) {

		log.info("updateApprove");
		log.info(vo);
		
		cashVO cashVO = vo.getCashVO();
		
		log.info("updateUsercash");
		
		if(cashVO.getCashKind().equals("충전")) 
			adminMapper.updatePluscash(cashVO);
		else if(cashVO.getCashKind().equals("환전"))
			adminMapper.updateMinuscash(cashVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("updateApprove: ");

		return adminMapper.updateApprove(cashVO.getCash_num());
	}
}
