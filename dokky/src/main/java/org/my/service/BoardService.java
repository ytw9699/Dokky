package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
import org.my.domain.ReplyLikeVO;
import org.my.domain.BoardAttachVO;
import org.my.domain.BoardDisLikeVO;
import org.my.domain.BoardLikeVO;

public interface BoardService {
	
	public List<BoardVO> getList(Criteria cri);

	public void register(BoardVO board);

	public BoardVO get(Long num);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public int getTotalCount(Criteria cri);

	public int pushLike(BoardLikeVO vo);
	
	public int pullDisLike(BoardDisLikeVO vo);
	
	public int pullLike(BoardLikeVO vo);
	
	public int pushDisLike(BoardDisLikeVO vo);

	public BoardVO getModifyForm(Long num);

	public List<BoardAttachVO> getAttachList(Long num);

	public String checkLikeValue(BoardLikeVO vo);
	
	public String checkDisLikeValue(BoardDisLikeVO vo);

	public int registerLike(BoardLikeVO vo);
	
	public int registerDisLike(BoardDisLikeVO vo);

	public String getLikeCount(Long num);

	public String getDisLikeCount(Long num);

	public String checkReplyLikeValue(ReplyLikeVO vo);

	public int registerReplyLike(ReplyLikeVO vo);

	public int pushReplyLike(ReplyLikeVO vo);

	public int pullReplyLike(ReplyLikeVO vo);

	public String getReplyLikeCount(Long reply_num);

	//public void removeAttach(Long num);
}
