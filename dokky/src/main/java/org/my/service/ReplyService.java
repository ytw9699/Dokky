package org.my.service;

	import org.my.domain.BoardDisLikeVO;
import org.my.domain.Criteria;
import org.my.domain.ReplyDisLikeVO;
import org.my.domain.ReplyLikeVO;
import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;
import org.my.domain.replyDonateVO;

public interface ReplyService {

	public int register(ReplyVO vo);

	public ReplyVO get(Long reply_num);

	public int modify(ReplyVO vo);

	public int remove(Long reply_num);
	
	public ReplyPageDTO getListPage(Criteria cri, Long num);
	
	public String checkLikeValue(ReplyLikeVO vo);

	public int registerLike(ReplyLikeVO vo);

	public int pushLike(ReplyLikeVO vo);

	public int pullLike(ReplyLikeVO vo);

	public String getLikeCount(Long reply_num);
	
	public int pullDisLike(ReplyDisLikeVO vo);
	
	public int pushDisLike(ReplyDisLikeVO vo);
	
	public String checkDisLikeValue(ReplyDisLikeVO vo);
	
	public int registerDisLike(ReplyDisLikeVO vo);
	
	public String getDisLikeCount(Long num);

	public String replyDonateMoney(replyDonateVO vo);

}
