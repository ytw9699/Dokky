package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.common.Criteria;
	import org.my.domain.reply.ReplyDisLikeVO;
	import org.my.domain.reply.ReplyDonateVO;
	import org.my.domain.reply.ReplyLikeVO;
	import org.my.domain.reply.ReplyVO;

public interface ReplyMapper {

	public int insertParentReply(ReplyVO vo);
	
	public List<ReplyVO> selectReplylistToDecideStep(ReplyVO replyVO);

	public int lastReplyStep(int group_num);
	
	public int insertChildReply(ReplyVO replyVO);

	public int plusOrder_step(ReplyVO replyVO);
	
	public ReplyVO read(Long reply_num);
	
	public int getReplyCnt(Long board_num);
	
	public List<ReplyVO> readReplyListWithPaging( @Param("cri") Criteria cri,
												 @Param("board_num") Long board_num );
	
	public int update(ReplyVO reply);
	
	public Long getBoardNum(Long reply_num);

	public int delete(Long reply_num);
	
	public void createMyCashHistory(ReplyDonateVO vo);
	
	public void plusReplyUserCash(ReplyDonateVO vo);

	public void createReplyUserCashHistory(ReplyDonateVO vo);
	
	public void plusReplyMoney(ReplyDonateVO vo);

	public String getReplyMoney(ReplyDonateVO vo);
	
	public int checkReplyLikeButton(ReplyLikeVO vo);
	
	public int checkReplyDislikeButton(ReplyDisLikeVO vo);
	
	public int pushReplyLikeButton(ReplyLikeVO vo);
	
	public int pushReplyDislikeButton(ReplyDisLikeVO vo);
	
	public int plusReplyLikeCount(Long reply_num);

	public int plusReplyDislikeCount(Long reply_num);
	
	public int pullReplyLikeButton(ReplyLikeVO vo);
	
	public int pullReplyDislikeButton(ReplyDisLikeVO vo);
	
	public int minusReplyLikeCount(Long reply_num);
	
	public int minusReplyDislikeCount(Long reply_num);

	public String getLikeCount(Long reply_num);
	
	public String getDislikeCount(Long reply_num);
	
	public Long getRecentReply_num();

	public int[] getReplyNums(Long board_num);

}
