package org.my.service;
	import java.util.List;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.commonVO;
	import org.my.domain.donateVO;
	import org.my.mapper.BoardAttachMapper;
	import org.my.mapper.BoardMapper;
	import org.my.mapper.CommonMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service//비즈니스 영역담당 어노테이션
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Setter(onMethod_ = @Autowired)
	private CommonMapper commonMapper;
	
	@Override
	public List<BoardVO> getList(Criteria cri) {

		log.info("get List with criteria: " + cri);

		return boardMapper.getList(cri);
	}
	
	@Override
	public List<BoardVO> getListWithOrder(Criteria cri) {

		log.info("getListWithOrder: " + cri);

		return boardMapper.getListWithOrder(cri);
	}
	
	@Override
	public int getTotalCount(Criteria cri) {

		log.info("getTotalCount");
		
		return boardMapper.getTotalCount(cri);
	}
	
	@Override
	public List<BoardVO> getAllList(Criteria cri) {

		log.info("getAllList with criteria: " + cri);

		return boardMapper.getAllList(cri);
	}
	
	@Override
	public List<BoardVO> getAllListWithOrder(Criteria cri) {

		log.info("getAllListWithOrder: " + cri);

		return boardMapper.getAllListWithOrder(cri);
	}
	
	@Override
	public int getAllTotalCount(Criteria cri) {

		log.info("getAllTotalCount");
		
		return boardMapper.getAllTotalCount(cri);
	}
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		log.info("register......" + board);

		if(boardMapper.register(board) == 1) {
		
			if (board.getAttachList() == null || board.getAttachList().size() <= 0) {//첨부파일이 없다면
				
				return;
				
			}else {//첨부파일이 있다면
				
				log.info("register......getAttachList");

				board.getAttachList().forEach(boardAttachVO -> {
					
					boardAttachVO.setBoard_num(board.getBoard_num());//새롭게 생성된 board_num값을 쓰고, 컨트롤러 쪽으로도 넘긴다
					
					attachMapper.insert(boardAttachVO);
				});
			}
		}
	}
	 
	@Override
	public int getScrapCnt(Long board_num, String userId) {
		
		log.info("getScrapCnt");
		
		int getResult = boardMapper.getScrapCnt(board_num,userId); 
		
		return getResult;
	}
	
	@Transactional
	@Override
	public BoardVO getBoard(Long board_num , Boolean hitChoice) {

		if(hitChoice) {
			
			log.info("updateHitCnt..." + board_num);
			
			boardMapper.updateHitCnt(board_num);//조회수 증가
		}
		
		log.info("getBoard..." + board_num);
		
		return boardMapper.read(board_num);
	}
	
	@Transactional
	@Override
	public boolean modifyBoard(BoardVO board) {

		log.info("modifyBoard......" + board); 

		attachMapper.deleteAll(board.getBoard_num());//일단 디비에서 첨부파일 정보 모두다 삭제,실제파일은 삭제안됨

		boolean result = boardMapper.updateBoard(board) == 1; 
		
		if (result && board.getAttachList() != null && board.getAttachList().size() > 0) {

			board.getAttachList().forEach(boardAttachVO -> {

				boardAttachVO.setBoard_num(board.getBoard_num());
				
				attachMapper.insert(boardAttachVO);//다시 모든파일 정보를 다 디비에 넣어준다
			});
		}
		
		return result;
	}

	@Transactional
	@Override
	public boolean removeBoard(Long board_num, boolean hasAttach) {

		log.info("removeBoard...." + board_num);
		
		if(hasAttach) {
			
			attachMapper.deleteAll(board_num);
		}
		
		return boardMapper.deleteBoard(board_num) == 1;
	}
	
		
	@Override
	public Long getRecentBoard_num() {
		
		return boardMapper.getRecentBoard_num();
	}
	
	
	
	@Override
	public List<BoardAttachVO> getAttachList(Long board_num) {
		//	특정 게시물의 번호로 첨부파일을 찾는 작업 

		log.info("get Attach list by board_num" + board_num);

		return attachMapper.findByNum(board_num);
	}
	
	/*@Override
	public void removeAttach(Long num) {

		log.info("remove all attach files");

		attachMapper.deleteAll(num);
	}*/
	
	@Override
	public String checkLikeValue(BoardLikeVO vo) {
		
		log.info("checkLikeValue");
		return boardMapper.checkLikeValue(vo); 
	}
	
	@Override
	public String checkDisLikeValue(BoardDisLikeVO vo) {
		
		log.info("checkDisLikeValue"); 
		return boardMapper.checkDisLikeValue(vo); 
	}
	
	@Transactional
	@Override
	public int registerLike(commonVO vo) {//좋아요 컬럼 첫 등록 및 좋아요 push
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("registerLike...." + vo);
		
		boardMapper.registerLike(boardLikeVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushLike....");
		
		return boardMapper.pushLike(boardLikeVO.getBoard_num()); 
	}
	
	@Transactional
	@Override 
	public int registerDisLike(commonVO vo) {//싫어요 컬럼 첫 등록 및 싫어요 push

		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("registerDisLike...." + vo);
		boardMapper.registerDisLike(boardDisLikeVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushDisLike....");
		return boardMapper.pushDisLike(boardDisLikeVO.getBoard_num()); 
	}
	
	@Transactional
	@Override
	public int pushLike(commonVO vo) {//좋아요 누르기  
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("pushLikeValue...."+vo);  
		
		boardMapper.pushLikeValue(boardLikeVO);
		
		log.info("insertAlarm: "+vo.getAlarmVO());
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushLike....");
		
		return boardMapper.pushLike(boardLikeVO.getBoard_num()); 
	}
	
	@Transactional
	@Override
	public int pullLike(commonVO vo) {//좋아요 취소 pull
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("pullLikeValue...."+vo);
		
		boardMapper.pullLikeValue(boardLikeVO);
		
		log.info("insertAlarm: ");
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		log.info("pullLike....");
		
		return boardMapper.pullLike(boardLikeVO.getBoard_num());
	}
	
	@Transactional
	@Override
	public int pullDisLike(commonVO vo) {//싫어요 취소 pull
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("pulldislikeCheck...."+vo);
		
		boardMapper.pulldislikeCheck(boardDisLikeVO); 
		
		log.info("insertAlarm: ");
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		log.info("pullDisLike....");
		
		return boardMapper.pullDisLike(boardDisLikeVO.getBoard_num()); 
	}
	
	@Transactional
	@Override 
	public int pushDisLike(commonVO vo) {//싫어요 누르기
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("pushDislikeValue...."+vo);
		boardMapper.pushDislikeValue(boardDisLikeVO); 
		
		log.info("insertAlarm: "); 
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushDisLike....");
		return boardMapper.pushDisLike(boardDisLikeVO.getBoard_num());
	}
	
	@Override
	public String getLikeCount(Long board_num) {
  
		log.info("getLikeCount");
		return boardMapper.getLikeCount(board_num);
	}
	@Override
	public String getDisLikeCount(Long board_num) {
 
		log.info("getDisLikeCount");
		return boardMapper.getDisLikeCount(board_num);
	}
	
	@Override
	public String getuserCash(String userId) { 
 
		log.info("getuserCash");
		
		return boardMapper.getuserCash(userId);
	}
	
	@Transactional
	@Override 
	public String donateMoney(commonVO vo) {
		  
		donateVO donateVO = vo.getDonateVO();
		
		log.info("minusMycash");
		boardMapper.minusMycash(donateVO.getMoney(), donateVO.getUserId());
		
		log.info("insertMyCashHistory");
		boardMapper.insertMyCashHistory(donateVO);
		
		log.info("updateBoardUserCash");
		boardMapper.updateBoardUserCash(donateVO);
		
		log.info("insertBoardUserCashHistory");
		boardMapper.insertBoardUserCashHistory(donateVO);
		
		log.info("updateBoardMoney");
		boardMapper.updateBoardMoney(donateVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("getBoardMoney");
		return boardMapper.getBoardMoney(donateVO);
	}
	    
	@Transactional
	@Override
	public boolean insertReportdata(commonVO vo) {//신고

		log.info("insertReportdata");
		
		//log.info("insertAlarm: ");
		//commonMapper.insertAlarm(vo.getAlarmVO());
		
		return boardMapper.insertReportdata(vo.getReportVO()) == 1;
	}
	
	
	@Override
	public int deleteScrapData(int board_num, String userId) {
		
		log.info("deleteScrapData");
		
		int deleteResult = boardMapper.deleteScrapData(board_num, userId); 
		
		return deleteResult;
	}
	
	@Override
	public boolean insertScrapData(int board_num, String userId) {
		
		log.info("insertScrapData");
		
		boolean inserResult = boardMapper.insertScrapData(board_num, userId) == 1; 
		
		return inserResult;
	}
	
	
	
}
