package org.my.service;
	import java.util.List;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.commonVO;
	import org.my.domain.reportVO;

public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);
	
	public List<BoardVO> getListWithOrder(Criteria cri);
	
	public int getTotalCount(Criteria cri);
	
	public List<BoardVO> getAllList(Criteria cri);
	
	public List<BoardVO> getAllListWithOrder(Criteria cri);
	
	public int getAllTotalCount(Criteria cri);
	
	public void register(BoardVO board);
	
	public int getScrapCnt(Long board_num, String userId);
	
	public BoardVO getBoard(Long board_num, Boolean hitChoice);
	
	public boolean modifyBoard(BoardVO board);

	public boolean removeBoard(Long board_num, boolean hasAttach);
	
	public boolean checkBoardLikeButton(BoardLikeVO vo);
	
	public boolean checkBoardDisLikeButton(BoardDisLikeVO vo);
	
	public boolean pushBoardLikeButton(commonVO vo);
	
	public boolean pushBoardDisLikeButton(commonVO vo);
	
	public boolean pullBoardLikeButton(commonVO vo);
	
	public boolean pullBoardDisLikeButton(commonVO vo);
	
	public String getLikeCount(Long board_num);
	
	public String getDisLikeCount(Long board_num);

	public String getMyCash(String userId);

	public String giveBoardWriterMoney(commonVO vo);

	public boolean createReportdata(reportVO vo);
	
	public List<BoardAttachVO> getAttachList(Long board_num);

	public int postScrapData(int board_num, String userId);
	
	public int deleteScrapData(int board_num, String userId);

	public Long getRecentBoard_num();

}
