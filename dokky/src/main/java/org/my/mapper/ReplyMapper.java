package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.Criteria;
	import org.my.domain.ReplyDisLikeVO;
	import org.my.domain.ReplyLikeVO;
	import org.my.domain.ReplyVO;
	import org.my.domain.replyDonateVO;

public interface ReplyMapper {

	public int insert(ReplyVO vo);
	
	public ReplyVO read(Long reply_num);
	
	public List<ReplyVO> readReplyListWithPaging( @Param("cri") Criteria cri,
												 @Param("board_num") Long board_num );
	
	public int update(ReplyVO reply);
	
	public int delete(Long reply_num);
	
	public void plusReplyUserCash(replyDonateVO vo);

	public void plusReplyMoney(replyDonateVO vo);

	public String getReplyMoney(replyDonateVO vo);

	public void createMyCashHistory(replyDonateVO vo);

	public void createReplyUserCashHistory(replyDonateVO vo);
	
	public int reInsert(ReplyVO replyVO);

	public int getCountBynum(Long board_num);
	
	public int checkReplyLikeButton(ReplyLikeVO vo);
	
	public int pushReplyLikeButton(ReplyLikeVO vo);
	
	public int plusReplyLikeCount(Long reply_num);
	
	public int pullReplyLikeButton(ReplyLikeVO vo);
	
	public int minusReplyLikeCount(Long reply_num);

	public String getLikeCount(Long reply_num);
	
	public int pullDisLike(Long reply_num);
	
	public int pushDisLike(Long reply_num);
	
	public String checkDisLikeValue(ReplyDisLikeVO vo);
	
	public int registerDisLike(ReplyDisLikeVO vo);
	
	public void pulldislikeCheck(ReplyDisLikeVO vo);
	
	public void pushDislikeValue(ReplyDisLikeVO vo);
	
	public String getDisLikeCount(Long reply_num);

	public List<ReplyVO> selectNextReply(ReplyVO replyVO);

	public int lastReplyStep(int group_num);

	public int updateOrder_step(ReplyVO replyVO);

	public Long getBoardNum(Long reply_num);
	
	public Long getRecentReply_num();
}
