package org.my.service;
	import org.my.domain.MemberVO;

public interface MemberService {
	 
	public boolean registerMembers(MemberVO vo);

	public boolean getIdCheckedVal(String inputId);
	
}
