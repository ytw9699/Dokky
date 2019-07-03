package org.my.mapper;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.MemberVO;

public interface MypageMapper {

	public MemberVO getMyInfo(String userId);

	public int updateMyInfo(MemberVO board);

	public String getMemberPW(String userId);
	
	public int updateMyPassword(@Param("userId") String userId, @Param("userPw") String userPw);

}
