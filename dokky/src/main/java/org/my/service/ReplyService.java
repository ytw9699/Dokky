/*
- 마지막 업데이트 2022-06-26
*/
package org.my.service;
	import org.my.domain.common.CommonVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.reply.ReplyDisLikeVO;
	import org.my.domain.reply.ReplyLikeVO;
	import org.my.domain.reply.ReplyPageDTO;
	import org.my.domain.reply.ReplyVO;

public interface ReplyService {

	public int create(CommonVO vo);

	public ReplyVO read(Long reply_num);
	
	public ReplyPageDTO readReplyList(Criteria cri, Long board_num);
	
	public int update(ReplyVO vo);
	
	public int delete(Long reply_num);
	
	boolean deleteReplies(String checkRow);
	
	public String giveReplyWriterMoney(CommonVO vo);
	
	public boolean checkReplyLikeButton(ReplyLikeVO vo);
	
	public boolean checkReplyDislikeButton(ReplyDisLikeVO vo);
	
	public boolean pushReplyLikeButton(CommonVO vo);
	
	public boolean pushReplyDislikeButton(CommonVO vo);
	
	public boolean pullReplyLikeButton(CommonVO vo);
	
	public boolean pullReplyDislikeButton(CommonVO vo);

	public String getLikeCount(Long reply_num);
	
	public String getDislikeCount(Long reply_num);

	public int getReplyPageNum(Long board_num, Long reply_num);

}
