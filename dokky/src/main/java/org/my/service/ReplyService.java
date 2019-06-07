package org.my.service;

	import org.my.domain.Criteria;
	import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;

public interface ReplyService {

	public int register(ReplyVO vo);

	public ReplyVO get(Long reply_num);

	public int modify(ReplyVO vo);

	public int remove(Long reply_num);
	
	public ReplyPageDTO getListPage(Criteria cri, Long num);

}
