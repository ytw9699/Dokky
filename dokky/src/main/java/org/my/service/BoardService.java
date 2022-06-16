/*
- 마지막 업데이트 2022-06-16
*/
package org.my.service;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import org.my.domain.BoardAttachVO;
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
	
	public List<BoardAttachVO> getAttachList(Long board_num);

	public boolean removeBoard(Long board_num, HttpServletRequest request);
	
	public boolean removeBoards(String checkRow, HttpServletRequest request);
	
	public String likeBoard(commonVO vo);
	
	public String disLikeBoard(commonVO vo);
	
	public String getMyCash(String userId);

	public String giveBoardWriterMoney(commonVO vo);

	public boolean createReportdata(reportVO vo);

	public int postScrapData(int board_num, String userId);
	
	public int deleteScrapData(int board_num, String userId);

	public Long getRecentBoard_num();//테스트 코드용
}
