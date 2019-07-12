package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.ReplyLikeVO;
	import org.my.domain.donateVO;
import org.my.domain.reportVO;
import org.my.mapper.BoardAttachMapper;
	import org.my.mapper.BoardMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service//비즈니스 영역담당 어노테이션
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Override
	public List<BoardVO> getList(Criteria cri) {

		log.info("get List with criteria: " + cri);

		return mapper.getList(cri);
	}
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		//log.info("register......" + board);

		mapper.insertSelectKey(board); 

		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}

		board.getAttachList().forEach(attach -> {// attach는 BoardAttachVO

			attach.setNum(board.getNum());
			attachMapper.insert(attach);
		});
	}
	
	@Transactional
	@Override
	public BoardVO get(Long num) {

		log.info("get..." + num);
		
		log.info("updateHitCnt..." + num);
		
		mapper.updateHitCnt(num);//조회수 증가
		
		return mapper.read(num);
	}
	@Override
	public BoardVO getModifyForm(Long num) {

		log.info("getModifyForm" + num);
		
		return mapper.read(num);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {

		log.info("modify......" + board); 

		attachMapper.deleteAll(board.getNum());//일단 첨부파일 모두 삭제

		boolean modifyResult = mapper.update(board) == 1; 
		
		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {

			board.getAttachList().forEach(attach -> {

				attach.setNum(board.getNum());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {

		log.info("remove...." + bno);

		attachMapper.deleteAll(bno);

		return mapper.delete(bno) == 1;
	}

	@Override
	public int getTotalCount(Criteria cri) {

		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
	@Override
	public List<BoardAttachVO> getAttachList(Long num) {

		log.info("get Attach list by num" + num);

		return attachMapper.findByNum(num);
	}
	
	/*@Override
	public void removeAttach(Long num) {

		log.info("remove all attach files");

		attachMapper.deleteAll(num);
	}*/
	
	@Transactional
	@Override
	public int registerLike(BoardLikeVO vo) {//좋아요 컬럼 등록 및 좋아요 push

		log.info("registerLike...." + vo);
		
		mapper.registerLike(vo);
		
		log.info("pushLike...."+vo.getNum());
		
		return mapper.pushLike(vo.getNum()); 
	}
	
	@Transactional
	@Override
	public int registerDisLike(BoardDisLikeVO vo) {//싫어요 컬럼 등록 및 싫어요 push

		log.info("registerDisLike...." + vo);
		
		mapper.registerDisLike(vo);
		
		log.info("pushDisLike...."+vo.getNum());
		
		return mapper.pushDisLike(vo.getNum()); 
	}
	
	@Transactional
	@Override
	public int pushLike(BoardLikeVO vo) {//좋아요 누르기  
		
		log.info("pushLikeValue...."+vo);  
		
		mapper.pushLikeValue(vo);
		
		log.info("pushLike...."+vo.getNum());
		
		return mapper.pushLike(vo.getNum()); 
	}
	
	@Transactional
	@Override
	public int pullDisLike(BoardDisLikeVO vo) {//싫어요 취소 pull
		
		log.info("pulldislikeCheck...."+vo);
		
		mapper.pulldislikeCheck(vo); 
		
		log.info("pullDisLike...."+vo.getNum());
		
		return mapper.pullDisLike(vo.getNum()); 
	}
	
	@Transactional
	@Override
	public int pullLike(BoardLikeVO vo) {//좋아요 취소 pull
		
		log.info("pullLikeValue...."+vo);
		
		mapper.pullLikeValue(vo);
		
		log.info("pullLike...."+vo.getNum());
		
		return mapper.pullLike(vo.getNum());
	}
	
	@Transactional
	@Override 
	public int pushDisLike(BoardDisLikeVO vo) {//싫어요 누르기
		
		log.info("pushDislikeValue...."+vo);
		
		mapper.pushDislikeValue(vo); 
		
		log.info("pushDisLike...."+vo.getNum());
		 
		return mapper.pushDisLike(vo.getNum());
	}
	
	@Override
	public String checkLikeValue(BoardLikeVO vo) {
		
		log.info("checkLikeValue");
		return mapper.checkLikeValue(vo); 
	}
	
	@Override
	public String checkDisLikeValue(BoardDisLikeVO vo) {
		
		log.info("checkDisLikeValue"); 
		return mapper.checkDisLikeValue(vo); 
	}
	
	@Override
	public String getLikeCount(Long num) {
  
		log.info("getLikeCount");
		return mapper.getLikeCount(num);
	}
	@Override
	public String getDisLikeCount(Long num) {
 
		log.info("getDisLikeCount");
		return mapper.getDisLikeCount(num);
	}
	
	@Override
	public String getuserCash(String username) { 
 
		log.info("getuserCash");
		
		return mapper.getuserCash(username);
	}
	
	@Transactional
	@Override 
	public String donateMoney(donateVO vo) {
		
		log.info("updateMycash");
		mapper.updateMycash(vo.getMoney(),vo.getUserId());
		
		log.info("insertMyCashHistory");
		mapper.insertMyCashHistory(vo);
		
		log.info("updateBoardUserCash");
		mapper.updateBoardUserCash(vo);
		
		log.info("insertBoardUserCashHistory");
		mapper.insertBoardUserCashHistory(vo);
		
		log.info("updateBoardMoney");
		mapper.updateBoardMoney(vo);
		
		log.info("getBoardMoney");
		return mapper.getBoardMoney(vo);
	}
	
	@Override
	public boolean insertReportdata(reportVO vo) {

		log.info("insertReportdata");
		
		return mapper.insertReportdata(vo) == 1;
	}
	
	
	
}
