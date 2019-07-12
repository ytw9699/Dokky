package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.donateVO;
import org.my.domain.reportVO;
import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;

public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);

	public void register(BoardVO board);

	public BoardVO get(Long num);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public int getTotalCount(Criteria cri);

	public int pushLike(BoardLikeVO vo);
	
	public int pullDisLike(BoardDisLikeVO vo);
	
	public int pullLike(BoardLikeVO vo);
	
	public int pushDisLike(BoardDisLikeVO vo);

	public BoardVO getModifyForm(Long num);

	public List<BoardAttachVO> getAttachList(Long num);

	public String checkLikeValue(BoardLikeVO vo);
	
	public String checkDisLikeValue(BoardDisLikeVO vo);

	public int registerLike(BoardLikeVO vo); 
	
	public int registerDisLike(BoardDisLikeVO vo);

	public String getLikeCount(Long num);

	public String getDisLikeCount(Long num);

	public String getuserCash(String username);

	public String donateMoney(donateVO vo);

	public boolean insertReportdata(reportVO vo);

	//public void removeAttach(Long num);
}
