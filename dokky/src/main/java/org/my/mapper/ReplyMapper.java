package org.my.mapper;

	import java.util.List;
	
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.Criteria;
	import org.my.domain.ReplyVO;

public interface ReplyMapper {

	public int insert(ReplyVO vo);

	public ReplyVO read(Long num);

	public int delete(Long num);

	public int update(ReplyVO reply);

	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("num") Long num );

	public int getCountBynum(Long num);
}
