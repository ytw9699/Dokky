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
	
	public int updateHitCnt(Long board_num);//조회수 증가
	
	public BoardVO read(Long board_num);
	
	public int updateBoard(BoardVO board);

	public int deleteBoard(Long bno);

	
	
	public void updateReplyCnt(@Param("board_num") Long board_num, @Param("amount") int amount);

	

	public int pushLike(Long board_num);
	
	public int pullDisLike(Long board_num);
	
	public int pullLike(Long board_num);
	
	public int pushDisLike(Long board_num);

	public String checkLikeValue(BoardLikeVO vo);
	
	public String checkDisLikeValue(BoardDisLikeVO vo);

	public int registerLike(BoardLikeVO vo);
	
	public int registerDisLike(BoardDisLikeVO vo);

	public void pushLikeValue(BoardLikeVO vo);
	
	public void pulldislikeCheck(BoardDisLikeVO vo);
	
	public void pullLikeValue(BoardLikeVO vo);

	public void pushDislikeValue(BoardDisLikeVO vo);
	
	public String getLikeCount(Long board_num);

	public String getDisLikeCount(Long board_num);

	public String getuserCash(String userId); 

	public String donateMoney(donateVO vo);
	
	public void updateBoardUserCash(donateVO vo);

	public void updateBoardMoney(donateVO vo);

	public String getBoardMoney(donateVO vo);

	public void insertMyCashHistory(donateVO vo);

	public void insertBoardUserCashHistory(donateVO vo);

	public int insertReportdata(reportVO vo);

	public Long getRecentBoard_num();
	
	public int insertScrapData(@Param("board_num") int board_num, @Param("userId") String userId);
	 
	public int deleteScrapData(@Param("board_num") int board_num, @Param("userId") String userId);
	
	public void minusMycash(@Param("money") int money, @Param("userId") String userId);

}
