/*
- 마지막 업데이트 2022-06-20
*/
package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.board.BoardVO;
	import org.my.domain.common.CashVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.ScrapVO;
	import org.my.domain.reply.ReplyVO;

public interface MypageMapper {

	public MemberVO getMyInfo(String userId);

	public int updateMyInfo(MemberVO board);
	
	public String getMyNickName(String userId);
	
	public void updateBoardNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public void updateReplyNickName(@Param("userId") String userId, @Param("nickName") String nickName);

	public void updateNoteFromNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public void updateNoteToNickName(@Param("userId") String userId, @Param("nickName") String nickName);

	public void updateAlarmNickName(@Param("userId") String userId, @Param("nickName") String nickName);

	public void updateCashlistNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public void updateReportedNickName(@Param("userId") String userId, @Param("nickName") String nickName);

	public void updateReportingNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public void updateChatRoomNickName(@Param("userId") String userId, @Param("nickName") String nickName);

	public void updateChatMemberNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public void updateChatContentNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public void updateChatReadNickName(@Param("userId") String userId, @Param("nickName") String nickName);
	
	public List<BoardVO> getMyBoardList(Criteria cri);
	
	public int getMyBoardCount(Criteria cri);

	public List<ReplyVO> getMyReplylist(Criteria cri);

	public int getMyReplyCount(Criteria cri);
	
	public List<ScrapVO> getMyScraplist(Criteria cri);
	
	public int getMyScrapCount(String userId);
	
	public int removeScrap(Long scrap_num);
	
	public int insertChargeData(CashVO vo);

	public int insertReChargeData(CashVO vo);
	
	public List<CashVO> getMyCashHistory(Criteria cri);
	
	public int getMyCashHistoryCount(String userId);
	
	public int updateEnabled(String userId);
	
	public String getMemberPW(String userId);
	
	public int changeMyPassword(@Param("userId") String userId, @Param("userPw") String userPw);
}
