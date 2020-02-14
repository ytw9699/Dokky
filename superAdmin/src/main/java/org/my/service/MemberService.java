package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.MemberVO;

public interface MemberService {
	 
	public boolean registerMembers(MemberVO vo);
	
	public boolean registerAdminMembers(MemberVO vo);

	public boolean getIdCheckedVal(String inputId);

	public boolean getNicknameCheckedVal(String inputNickname);

	public boolean getEmailCheckedVal(String inputEmail);

	public List<BoardVO> getRealtimeList();

	public List<BoardVO> getMonthlyList();

	public List<BoardVO> getDonationList();
	
}
