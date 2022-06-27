/*
- 마지막 업데이트 2022-06-12
*/
package org.my.service;
	import org.my.domain.common.MemberVO;
	import org.my.mapper.MemberMapper;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Log4j
@Service
public class MemberServiceImpl implements MemberService {

	private final MemberMapper mapper;
	
	@Transactional
	@Override 
	public boolean registerMembers(MemberVO vo) {

		log.info("registerMembers..." + vo);
		
		log.info("registerMember_auth...");
		
		return mapper.registerMembers(vo) == 1 && mapper.registerMember_auth(vo) == 1;
	}
	
	@Override 
	public MemberVO readMembers(String userId){

		log.info("readMembers..."+userId);
		
		return mapper.readMembers(userId);
	}
	
	@Override 
	public boolean reRegisterMembers(MemberVO vo) {

		log.info("reRegisterMembers..." + vo);
		
		return mapper.reRegisterMembers(vo) == 1;
	}
	
	/*@Transactional
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
	}*/
}
