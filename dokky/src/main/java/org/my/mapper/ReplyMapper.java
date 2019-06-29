package org.my.mapper;

	import java.util.List;
	
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.Criteria;
import org.my.domain.ReplyLikeVO;
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
	
	public String checkReplyLikeValue(ReplyLikeVO vo);

	public int pushReplyLike(Long reply_num);

	public int registerReplyLike(ReplyLikeVO vo);

	public void pushReplyLikeValue(ReplyLikeVO vo);

	public int pullReplyLike(Long reply_num);

	public void pullReplyLikeValue(ReplyLikeVO vo);

	public String getReplyLikeCount(Long reply_num);

}
