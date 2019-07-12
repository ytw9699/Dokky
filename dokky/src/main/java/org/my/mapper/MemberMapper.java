package org.my.mapper;
	import org.my.domain.MemberVO;

public interface MemberMapper {

	public MemberVO read(String userId);

	public int registerMembers(MemberVO vo);

	public int registerMember_auth(MemberVO vo);
	
}
