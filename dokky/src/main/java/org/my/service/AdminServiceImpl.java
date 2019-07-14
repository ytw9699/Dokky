package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
import org.my.domain.MemberVO;
import org.my.domain.cashVO;
import org.my.domain.reportVO;
import org.my.mapper.AdminMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class AdminServiceImpl implements AdminService {

	@Setter(onMethod_ = @Autowired)
	private AdminMapper mapper;
	
	@Override
	public List<cashVO> getCashRequest(Criteria cri) {

		log.info("getCashRequest: " + cri);

		return mapper.getCashRequest(cri);
	}
	@Transactional
	@Override
	public int updateApprove(cashVO vo) {

		log.info("updateUsercash");
		log.info(vo);
		
		if(vo.getCashKind().equals("충전")) 
			mapper.updatePluscash(vo);
		else if(vo.getCashKind().equals("환전"))
			mapper.updateMinuscash(vo);
		
		log.info("updateApprove: ");

		return mapper.updateApprove(vo.getCash_num());
	}
	
	@Override
	public int getTotalCount() {

		log.info("getTotalCount: ");

		return mapper.getTotalCount();
	}
	
	@Override
	public int getMemberTotalCount(Criteria cri) {

		log.info("getMemberTotalCount: ");

		return mapper.getMemberTotalCount(cri);
	}
	
	@Override
	public List<MemberVO> getMemberList(Criteria cri) {

		log.info("getMemberList: " + cri);

		return mapper.getMemberList(cri);
	}
	
	@Override
	public MemberVO getUserForm(String userId) {

		log.info("getUserForm: " + userId);

		return mapper.getUserForm(userId);
	}
	
	@Override
	public List<reportVO> getUserReportList(Criteria cri){
	
		log.info("getUserReportList: " + cri);

		return mapper.getUserReportList(cri);
	}
	
	@Override
	public int getUserReportCount(Criteria cri){

		log.info("getUserReportCount: ");

		return mapper.getUserReportCount(cri);
	}
	
	@Override
	public int updateRoleStop(String userId) {
		
		log.info("updateRoleStop.."+userId);
		
		return mapper.updateRoleStop(userId);
	}
	@Override
	public int updateRoleLimit(String userId) {
		
		log.info("updateRoleLimit.."+userId);
		
		return mapper.updateRoleLimit(userId);
	}
	
	@Override
	public int updateRoleUser(String userId) {
		
		log.info("updateRoleUser.."+userId);
		
		return mapper.updateRoleUser(userId);
	}
	
}
