package org.my.service;

import java.util.List;
import org.my.domain.BoardVO;
import org.my.domain.Criteria;


public interface BoardService {

	public void register(BoardVO board);

	public BoardVO get(Long bno);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public List<BoardVO> getList();

	public List<BoardVO> getList(Criteria cri);
	
	public List<BoardVO> getList(int kind);

	//추�?
	public int getTotal(Criteria cri);

}
