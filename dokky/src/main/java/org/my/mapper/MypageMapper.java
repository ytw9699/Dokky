package org.my.mapper;
	import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.my.domain.BoardVO;
import org.my.domain.Criteria;
import org.my.domain.MemberVO;
import org.my.domain.ReplyVO;

public interface MypageMapper {

	public MemberVO getMyInfo(String userId);

	public int updateMyInfo(MemberVO board);

	public String getMemberPW(String userId);
	
	public int updateMyPassword(@Param("userId") String userId, @Param("userPw") String userPw);

	public List<BoardVO> getMyBoardList(Criteria cri);

	public int getMyBoardCount(Criteria cri);

	public List<ReplyVO> getMyReplylist(Criteria cri);

	public int getMyReplyCount(Criteria cri);

	public int insertScrapData(@Param("num") int num, @Param("userId") String userId);
 
	public int getScrapCnt(@Param("num") int num, @Param("userId") String userId);
	
}
