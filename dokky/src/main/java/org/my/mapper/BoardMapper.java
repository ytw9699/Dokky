package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
import org.my.domain.BoardDisLikeVO;
import org.my.domain.BoardLikeVO;
import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
import org.my.domain.ReplyLikeVO;
import org.my.domain.donateVO;

public interface BoardMapper {

	public List<BoardVO> getList(Criteria cri);

	public Integer insertSelectKey(BoardVO board);

	public BoardVO read(Long num);

	public int delete(Long bno);

	public int update(BoardVO board);

	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("num") Long num, @Param("amount") int amount);

	public int updateHitCnt(Long num);//조회수 증가

	public int pushLike(Long num);
	
	public int pullDisLike(Long num);
	
	public int pullLike(Long num);
	
	public int pushDisLike(Long num);

	public String checkLikeValue(BoardLikeVO vo);
	
	public String checkDisLikeValue(BoardDisLikeVO vo);

	public int registerLike(BoardLikeVO vo);
	
	public int registerDisLike(BoardDisLikeVO vo);

	public void pushLikeValue(BoardLikeVO vo);
	
	public void pulldislikeCheck(BoardDisLikeVO vo);
	
	public void pullLikeValue(BoardLikeVO vo);

	public void pushDislikeValue(BoardDisLikeVO vo);
	
	public String getLikeCount(Long num);

	public String getDisLikeCount(Long num);

	public String getuserCash(String username); 

	public String donateMoney(donateVO vo);
	
	public void updateMycash(@Param("money") int money, @Param("userId") String userId);
		
	public void updateBoardUserCash(donateVO vo);

	public void updateBoardMoney(donateVO vo);

	public String getBoardMoney(donateVO vo);


}
