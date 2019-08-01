package org.my.mapper;

	import java.util.List;
	
	import org.apache.ibatis.annotations.Param;
import org.my.domain.BoardDisLikeVO;
import org.my.domain.Criteria;
import org.my.domain.ReplyDisLikeVO;
import org.my.domain.ReplyLikeVO;
import org.my.domain.ReplyVO;
import org.my.domain.replyDonateVO;

public interface ReplyMapper {

	public int insert(ReplyVO vo);
	
	public int reInsert(ReplyVO replyVO);

	public ReplyVO read(Long num);

	public int delete(Long num);

	public int update(ReplyVO reply);

	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("num") Long num );

	public int getCountBynum(Long num);
	
	public String checkLikeValue(ReplyLikeVO vo);

	public int pushLike(Long reply_num);

	public int registerLike(ReplyLikeVO vo);

	public void pushLikeValue(ReplyLikeVO vo);

	public int pullLike(Long reply_num); 

	public void pullLikeValue(ReplyLikeVO vo);

	public String getLikeCount(Long reply_num);
	
	public int pullDisLike(Long num);
	
	public int pushDisLike(Long num);
	
	public String checkDisLikeValue(ReplyDisLikeVO vo);
	
	public int registerDisLike(ReplyDisLikeVO vo);
	
	public void pulldislikeCheck(ReplyDisLikeVO vo);
	
	public void pushDislikeValue(ReplyDisLikeVO vo);
	
	public String getDisLikeCount(Long num);

	public void updateReplyUserCash(replyDonateVO vo);

	public void updateReplyMoney(replyDonateVO vo);

	public String getReplyMoney(replyDonateVO vo);

	public void insertMyCashHistory(replyDonateVO vo);

	public void insertReplyUserCashHistory(replyDonateVO vo);

	public List<ReplyVO> selectNextReply(ReplyVO replyVO);

	public int lastReplyStep(int parent_num);

}
