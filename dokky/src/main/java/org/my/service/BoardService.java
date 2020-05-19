package org.my.service;
	import java.util.List;

	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.commonVO;

public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);
	
	public List<BoardVO> getListWithOrder(Criteria cri);
	
	public List<BoardVO> getAllListWithOrder(Criteria cri);
	
	public void register(BoardVO board);

	public Long getRecentBoard_num();
	
	public BoardVO get(Long board_num);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public int getTotalCount(Criteria cri);

	public int pushLike(commonVO vo);
	
	public int pullDisLike(commonVO vo);
	
	public int pullLike(commonVO vo);
	
	public int pushDisLike(commonVO vo);

	public BoardVO getModifyForm(Long board_num);

	public List<BoardAttachVO> getAttachList(Long board_num);

	public String checkLikeValue(BoardLikeVO vo);
	
	public String checkDisLikeValue(BoardDisLikeVO vo);

	public int registerLike(commonVO vo); 
	
	public int registerDisLike(commonVO vo);

	public String getLikeCount(Long board_num);

	public String getDisLikeCount(Long board_num);

	public String getuserCash(String userId);

	public String donateMoney(commonVO vo);

	public boolean insertReportdata(commonVO vo);

	public List<BoardVO> getAllList(Criteria cri);

	public int getAllTotalCount(Criteria cri);

	//public void removeAttach(Long num);
}
