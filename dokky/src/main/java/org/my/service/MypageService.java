package org.my.service;
	import org.my.domain.MemberVO;

public interface MypageService {

	MemberVO getMyInfo(String userId);
	
}
