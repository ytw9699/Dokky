package org.my.mapper;
	import java.util.List;
	import org.my.domain.board.BoardVO;
	import org.my.domain.MemberVO;

public interface MemberMapper {

	public int registerMembers(MemberVO vo);
	
	public int registerMember_auth(MemberVO vo);
	
	public MemberVO readMembers(String userId);
	
	public int reRegisterMembers(MemberVO vo);

	public int emailCheckedCount(String inputEmail);
}
