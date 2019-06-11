package org.my.service;

import java.util.List;
import org.my.domain.BoardVO;
import org.my.domain.Criteria;
import org.my.domain.BoardAttachVO;


public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);

	public void register(BoardVO board);

	public BoardVO get(Long num);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public int getTotalCount(Criteria cri);

	public int updateLike(Long num);

	public BoardVO getModifyForm(Long num);

	public List<BoardAttachVO> getAttachList(Long num);
	
	//public void removeAttach(Long num);
}
