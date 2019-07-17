package org.my.service;
	import java.util.List;

import org.my.domain.BoardVO;
import org.my.domain.Criteria;
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
	
	@Transactional
	@Override 
	public boolean registerMembers(MemberVO vo) {

		log.info("registerMembers..." + vo);
		
		log.info("registerMember_auth..." + vo);
		
		return mapper.registerMembers(vo) == 1 && mapper.registerMember_auth(vo) == 1;
	}
	
	@Override 
	public boolean getIdCheckedVal(String inputId) {

		log.info("getDuplicatedId...");
		
		return mapper.IdCheckedCount(inputId) == 1;
	}
	
	@Override 
	public boolean getNicknameCheckedVal(String inputNickname){

		log.info("getNicknameCheckedVal...");
		
		return mapper.nicknameCheckedCount(inputNickname) == 1;
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
