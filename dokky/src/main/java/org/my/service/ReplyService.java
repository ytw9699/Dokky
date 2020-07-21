package org.my.service;
	import org.my.domain.Criteria;
	import org.my.domain.ReplyDisLikeVO;
	import org.my.domain.ReplyLikeVO;
	import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;
	import org.my.domain.commonVO;

public interface ReplyService {

	public int create(commonVO vo);

	public ReplyVO read(Long reply_num);
	
	public ReplyPageDTO readReplyList(Criteria cri, Long board_num);
	
	public int update(ReplyVO vo);
	
	public int delete(Long reply_num);
	
	public String checkLikeValue(ReplyLikeVO vo);

	public int registerLike(commonVO vo);

	public int pushLike(commonVO vo);

	public int pullLike(commonVO vo);

	public String getLikeCount(Long reply_num);
	
	public int pullDisLike(commonVO vo);
	
	public int pushDisLike(commonVO vo);
	
	public String checkDisLikeValue(ReplyDisLikeVO vo);
	
	public int registerDisLike(commonVO vo);
	
	public String getDisLikeCount(Long reply_num);

	public String giveReplyWriterMoney(commonVO vo);

}
