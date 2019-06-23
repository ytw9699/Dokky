package org.my.mapper;
	import org.my.domain.MemberVO;

public interface MemberMapper {

	public MemberVO read(String userid);

	public void registerMembers(MemberVO vo);

	public void registerMember_auth(MemberVO vo);
	
}
