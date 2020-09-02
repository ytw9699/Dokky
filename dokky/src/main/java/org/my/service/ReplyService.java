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
	
	public String giveReplyWriterMoney(commonVO vo);
	
	public boolean checkReplyLikeButton(ReplyLikeVO vo);
	
	public boolean checkReplyDislikeButton(ReplyDisLikeVO vo);
	
	public boolean pushReplyLikeButton(commonVO vo);
	
	public boolean pushReplyDislikeButton(commonVO vo);
	
	public boolean pullReplyLikeButton(commonVO vo);
	
	public boolean pullReplyDislikeButton(commonVO vo);

	public String getLikeCount(Long reply_num);
	
	public String getDislikeCount(Long reply_num);

	public int getReplyPageNum(Long board_num, Long reply_num);

}
