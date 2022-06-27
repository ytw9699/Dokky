package org.my.mapper;
	import java.util.List;
	import org.my.domain.board.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	
	public int deleteAll(Long board_num);

	public void delete(String uuid);

	public List<BoardAttachVO> getAttachList(Long board_num); 
	
	public List<BoardAttachVO> getYesterdayFiles();

}
