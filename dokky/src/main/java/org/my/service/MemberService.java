package org.my.service;
	import org.my.domain.common.MemberVO;

public interface MemberService {
	 
	public boolean registerMembers(MemberVO vo);
	
	public MemberVO readMembers(String userId);
	
	public boolean reRegisterMembers(MemberVO vo);
	
	//public boolean registerAdminMembers(MemberVO vo);
	
	//public boolean getEmailCheckedVal(String inputEmail);
	
}
