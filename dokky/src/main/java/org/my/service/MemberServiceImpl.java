package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.MemberVO;
	import org.my.mapper.MemberMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class MemberServiceImpl implements MemberService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	@Override 
	public MemberVO readMembers(String userId){

		log.info("readMembers..."+userId);
		
		return mapper.readMembers(userId);
	}
	
	@Transactional
	@Override 
	public boolean registerMembers(MemberVO vo) {

		log.info("registerMembers..." + vo);
		
		log.info("registerMember_auth..." + vo);
		
		return mapper.registerMembers(vo) == 1 && mapper.registerMember_auth(vo) == 1;
	}
	
	@Transactional
	@Override 
	public boolean reRegisterMembers(MemberVO vo) {

		log.info("reRegisterMembers..." + vo);
		
		return mapper.reRegisterMembers(vo) == 1;
	}
	
	@Transactional
	@Override 
	public boolean registerAdminMembers(MemberVO vo) {

		log.info("registerAdminMembers..." + vo);
		
		log.info("registerAdminMembers_auth..." + vo);
		
		return mapper.registerMembers(vo) == 1 && mapper.registerMember_auth(vo) == 1;
	}
	
	@Override 
	public boolean getEmailCheckedVal(String inputEmail){

		log.info("getEmailCheckedVal...");
		
		return mapper.emailCheckedCount(inputEmail) == 1;
	}
	
	@Override
	public List<BoardVO> getRealtimeList() {

		log.info("getRealtimeList: ");

		return mapper.getRealtimeList();
	}
	@Override
	public List<BoardVO> getMonthlyList() {

		log.info("getMonthlyList: ");

		return mapper.getMonthlyList();
	}
	@Override
	public List<BoardVO> getDonationList() {

		log.info("getDonationList: ");

		return mapper.getDonationList();
	}
}
