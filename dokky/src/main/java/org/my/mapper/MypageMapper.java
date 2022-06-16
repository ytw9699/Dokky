/*
- 마지막 업데이트 2022-06-14
*/
package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.board.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.ReplyVO;
	import org.my.domain.CashVO;
	import org.my.domain.ScrapVO;

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
	
	public List<BoardVO> getMyBoardList(Criteria cri);
	
	public int getMyBoardCount(Criteria cri);

	public List<ReplyVO> getMyReplylist(Criteria cri);

	public int getMyReplyCount(Criteria cri);
	
	public List<ScrapVO> getMyScraplist(Criteria cri);
	
	public int getMyScrapCount(String userId);
	
	public void removeScrap(Long scrap_num);
	
	public int insertChargeData(CashVO vo);

	public int insertReChargeData(CashVO vo);
	
	public List<CashVO> getMyCashHistory(Criteria cri);
	
	public int getMyCashHistoryCount(String userId);
	
	public int updateEnabled(String userId);
	
	public String getMemberPW(String userId);
	
	public int changeMyPassword(@Param("userId") String userId, @Param("userPw") String userPw);
}
