package org.my.service;
	import org.my.domain.MemberVO;

public interface MypageService {

	public MemberVO getMyInfo(String userId);

	public boolean updateMyInfo(MemberVO vo);

	public String getMemberPW(String userId);
	
}
