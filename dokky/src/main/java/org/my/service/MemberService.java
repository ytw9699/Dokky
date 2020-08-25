package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.MemberVO;

public interface MemberService {
	 
	public boolean registerMembers(MemberVO vo);
	
	public MemberVO readMembers(String userId);
	
	public boolean reRegisterMembers(MemberVO vo);
	
	//public boolean registerAdminMembers(MemberVO vo);
	
	//public boolean getEmailCheckedVal(String inputEmail);
	
}
