/*
- 마지막 업데이트 2022-06-13
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.ReplyVO;
	import org.my.domain.CashVO;
	import org.my.domain.ScrapVO;

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
