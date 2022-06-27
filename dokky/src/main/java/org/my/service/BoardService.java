/*
- 마지막 업데이트 2022-06-16
*/
package org.my.service;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import org.my.domain.board.BoardAttachVO;
	import org.my.domain.board.BoardVO;
	import org.my.domain.common.CommonVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.ReportVO;

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
	
	public List<BoardAttachVO> getAttachList(Long board_num);

	public boolean removeBoard(Long board_num, HttpServletRequest request);
	
	public boolean removeBoards(String checkRow, HttpServletRequest request);
	
	public String likeBoard(CommonVO vo);
	
	public String disLikeBoard(CommonVO vo);
	
	public String getMyCash(String userId);

	public String giveBoardWriterMoney(CommonVO vo);

	public boolean createReportdata(ReportVO vo);

	public int postScrapData(int board_num, String userId);
	
	public int deleteScrapData(int board_num, String userId);

	public Long getRecentBoard_num();//테스트 코드용
}
