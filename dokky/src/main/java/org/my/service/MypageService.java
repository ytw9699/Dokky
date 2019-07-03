package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;

public interface MypageService {

	public MemberVO getMyInfo(String userId);

	public boolean updateMyInfo(MemberVO vo);

	public String getMemberPW(String userId);

	public boolean updateMyPassword(String userId, String userPw);

	public List<BoardVO> getMyBoardList(Criteria cri);

	public int getMyBoardCount(Criteria cri);
	
}
