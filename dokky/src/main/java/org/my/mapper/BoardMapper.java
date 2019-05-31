package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;

public interface BoardMapper {

	public List<BoardVO> getList(int category);

	public List<BoardVO> getListWithPaging(Criteria cri);

	public Integer insertSelectKey(BoardVO board);

	public BoardVO read(Long num);

	public int delete(Long bno);

	public int update(BoardVO board);

	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);

	public int updateHitCnt(Long num);

}
