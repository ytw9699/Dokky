/*
- 마지막 업데이트 2022-06-15
*/
package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.donateVO;
	import org.my.domain.reportVO;

public interface BoardMapper {

	public List<BoardVO> getList(Criteria cri); 
	
	public List<BoardVO> getListWithOrder(Criteria cri);
	
	public int getTotalCount(Criteria cri);
	
	public List<BoardVO> getAllList(Criteria cri);
	
	public List<BoardVO> getAllListWithOrder(Criteria cri);
	
	public int getAllTotalCount(Criteria cri);
	
	public int register(BoardVO board);
	
	public int getScrapCnt(@Param("board_num") Long board_num, @Param("userId") String userId);
	
	public int updateHitCnt(Long board_num);
	
	public BoardVO read(Long board_num);
	
	public int updateBoard(BoardVO board);
	
	public int deleteBoard(Long bno);
	
	public int checkBoardLikeButton(BoardLikeVO vo);
	
	public int pushBoardLikeButton(BoardLikeVO vo);
	
	public int pullBoardLikeButton(BoardLikeVO vo);
	
	public int plusBoardLikeCount(Long board_num);
	
	public int checkBoardDisLikeButton(BoardDisLikeVO vo);
	
	public int pushBoardDisLikeButton(BoardDisLikeVO vo);
	
	public int plusBoardDisLikeCount(Long board_num);
	
	public int pullBoardDisLikeButton(BoardDisLikeVO vo);

	public int minusBoardLikeCount(Long board_num);
	
	public int minusBoardDisLikeCount(Long board_num);
	
	public String getLikeCount(Long board_num);
	
	public String getDisLikeCount(Long board_num);
	
	public String getMyCash(String userId); 
	
	public void minusMycash(@Param("money") int money, @Param("userId") String userId);
	
	public void createMyCashHistory(donateVO vo);
	
	public void plusBoardUserCash(donateVO vo);
	
	public void createBoardUserCashHistory(donateVO vo);
	
	public void plusBoardMoney(donateVO vo);
	
	public String getBoardMoney(donateVO vo);

	public int createReportdata(reportVO vo);

	public int postScrapData(@Param("board_num") int board_num, @Param("userId") String userId);
	 
	public int deleteScrapData(@Param("board_num") int board_num, @Param("userId") String userId);
	
	public void updateReplyCnt(@Param("board_num") Long board_num, @Param("amount") int amount);
	
	public Long getRecentBoard_num();
}
