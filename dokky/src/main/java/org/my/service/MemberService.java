package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.MemberVO;

public interface MemberService {
	 
	public MemberVO readMembers(String userId);
	
	public boolean registerMembers(MemberVO vo);
	
	public boolean reRegisterMembers(MemberVO vo);
	
	public boolean registerAdminMembers(MemberVO vo);

	public boolean getIdCheckedVal(String inputId);

	public boolean getEmailCheckedVal(String inputEmail);

	public List<BoardVO> getRealtimeList();

	public List<BoardVO> getMonthlyList();

	public List<BoardVO> getDonationList();
	
	public boolean updateLoginDate(String userName);

	
}
