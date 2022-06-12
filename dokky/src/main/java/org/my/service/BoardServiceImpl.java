/*
- 마지막 업데이트 2022-06-12
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.commonVO;
	import org.my.domain.donateVO;
	import org.my.domain.reportVO;
	import org.my.mapper.BoardAttachMapper;
	import org.my.mapper.BoardMapper;
	import org.my.mapper.CommonMapper;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Log4j
@Service//비즈니스 영역담당 어노테이션
public class BoardServiceImpl implements BoardService {

	private final BoardMapper boardMapper;
	private final BoardAttachMapper attachMapper;
	private final CommonMapper commonMapper;
	
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
	public boolean checkBoardLikeButton(BoardLikeVO vo) {
		
		log.info("checkBoardLikeButton");
		
		return boardMapper.checkBoardLikeButton(vo) == 1; 
	}
	
	@Override
	public boolean checkBoardDisLikeButton(BoardDisLikeVO vo) {
		
		log.info("checkBoardDisLikeButton");
		
		return boardMapper.checkBoardDisLikeButton(vo) == 1; 
	}
	
	@Transactional
	@Override
	public boolean pushBoardLikeButton(commonVO vo) {//글 좋아요 버튼 누르기
		
		log.info("pushBoardLikeButton...." + vo);
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		return boardMapper.pushBoardLikeButton(boardLikeVO) == 1 && boardMapper.plusBoardLikeCount(boardLikeVO.getBoard_num()) == 1; 
	}
	
	@Transactional
	@Override
	public boolean pushBoardDisLikeButton(commonVO vo) {//글 싫어요 버튼 누르기
		
		log.info("pushBoardDisLikeButton...." + vo);
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		return boardMapper.pushBoardDisLikeButton(boardDisLikeVO) == 1 && boardMapper.plusBoardDisLikeCount(boardDisLikeVO.getBoard_num()) == 1; 
	}
	
	@Transactional
	@Override
	public boolean pullBoardLikeButton(commonVO vo) {//글 좋아요 당기기(취소)
		
		log.info("pullBoardLikeButton...." + vo);
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("deleteAlarm");
		
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		return boardMapper.pullBoardLikeButton(boardLikeVO) == 1 && boardMapper.minusBoardLikeCount(boardLikeVO.getBoard_num()) == 1; 
	}
	
	@Transactional
	@Override
	public boolean pullBoardDisLikeButton(commonVO vo) {//글 싫어요 당기기(취소)
		
		log.info("pullBoardDisLikeButton...." + vo);
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("deleteAlarm");
		
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		return boardMapper.pullBoardDisLikeButton(boardDisLikeVO) == 1 && boardMapper.minusBoardDisLikeCount(boardDisLikeVO.getBoard_num()) == 1; 
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
	public String getMyCash(String userId) { 
 
		log.info("getMyCash");
		
		return boardMapper.getMyCash(userId);
	}
	
	@Transactional
	@Override 
	public String giveBoardWriterMoney(commonVO vo) {
		  
		donateVO donateVO = vo.getDonateVO();
		
		log.info("minusMycash");
		boardMapper.minusMycash(donateVO.getMoney(), donateVO.getUserId());
		
		log.info("createMyCashHistory");
		boardMapper.createMyCashHistory(donateVO);
		
		log.info("plusBoardUserCash");
		boardMapper.plusBoardUserCash(donateVO);
		
		log.info("createBoardUserCashHistory");
		boardMapper.createBoardUserCashHistory(donateVO);
		
		log.info("plusBoardMoney");
		boardMapper.plusBoardMoney(donateVO);
		
		log.info("insertAlarm");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("getBoardMoney");
		return boardMapper.getBoardMoney(donateVO);
	}
	    
	@Override
	public boolean createReportdata(reportVO vo) {//신고

		log.info("createReportdata");
		
		return boardMapper.createReportdata(vo) == 1;
	}
	
	@Override
	public List<BoardAttachVO> getAttachList(Long board_num) {
		//특정 게시물의 번호로 첨부파일을 찾는 작업 

		log.info("get Attach list by board_num" + board_num);

		return attachMapper.getAttachList(board_num);
	}
	
	@Override
	public int postScrapData(int board_num, String userId) {
		
		log.info("postScrapData");
		
		return boardMapper.postScrapData(board_num, userId);
	}
	
	@Override
	public int deleteScrapData(int board_num, String userId) {
		
		log.info("deleteScrapData");
		
		return boardMapper.deleteScrapData(board_num, userId);
	}
	
	@Override
	public Long getRecentBoard_num() {
		
		return boardMapper.getRecentBoard_num();
	}
}
