package org.my.mapper;
	import java.util.List;
	import org.my.domain.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	
	public int deleteAll(Long board_num);

	public void delete(String uuid);

	public List<BoardAttachVO> findByNum(Long board_num);//특정 게시물의 번호로 첨부파일을 찾는 작업 
	
	public List<BoardAttachVO> getYesterdayFiles();

}
