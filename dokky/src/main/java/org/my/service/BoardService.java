package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.BoardAttachVO;
import org.my.domain.BoardLikeVO;

public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);

	public void register(BoardVO board);

	public BoardVO get(Long num);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public int getTotalCount(Criteria cri);

	public int upLike(BoardLikeVO vo);
	
	public int downLike(BoardLikeVO vo);

	public BoardVO getModifyForm(Long num);

	public List<BoardAttachVO> getAttachList(Long num);

	public String checkLike(BoardLikeVO vo);

	public int registerLike(BoardLikeVO vo);

	public String getLikeCount(Long num);

	//public void removeAttach(Long num);
}
