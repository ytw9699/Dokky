/*
- 마지막 업데이트 2022-06-13
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.board.BoardVO;
	import org.my.domain.common.CashVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.ScrapVO;
	import org.my.domain.reply.ReplyVO;

public interface MypageService {

	public boolean updateMyInfo(MemberVO vo);
	
	public List<BoardVO> getMyBoardList(Criteria cri);

	public int getMyBoardCount(Criteria cri);
	
	public List<ReplyVO> getMyReplylist(Criteria cri);

	public int getMyReplyCount(Criteria cri);
	
	public List<ScrapVO> getMyScraplist(Criteria cri);

	public int getMyScrapCount(String userId);
	
	public void removeScrap(Long scrap_num);
	
	public boolean insertChargeData(CashVO vo);

	public boolean insertReChargeData(CashVO vo);
	
	public List<CashVO> getMyCashHistory(Criteria cri);
	
	public int getMyCashHistoryCount(String userId);
	
	public boolean myWithdrawal(String userId);
	
	public String getMemberPW(String userId);
	
	public boolean changeMyPassword(String userId, String userPw);
}
