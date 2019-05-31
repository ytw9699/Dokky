package org.my.service;

import java.util.List;
import org.my.domain.BoardVO;
import org.my.domain.Criteria;


public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);

	public void register(BoardVO board);

	public BoardVO get(Long num);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public int getTotal(Criteria cri);

	public boolean updateHitCnt(Long num);

}
