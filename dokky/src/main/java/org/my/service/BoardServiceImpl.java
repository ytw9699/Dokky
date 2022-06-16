/*
- 마지막 업데이트 2022-06-16
*/
package org.my.service;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.alarmVO;
	import org.my.domain.commonVO;
	import org.my.domain.donateVO;
	import org.my.domain.reportVO;
	import org.my.mapper.BoardAttachMapper;
	import org.my.mapper.BoardMapper;
	import org.my.mapper.CommonMapper;
	import org.my.s3.myS3Util;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Log4j
@Service
public class BoardServiceImpl implements BoardService {

	private final BoardMapper boardMapper;
	private final BoardAttachMapper attachMapper;
	private final CommonMapper commonMapper;
	private final myS3Util myS3Util;
	
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
			
			boardMapper.updateHitCnt(board_num);
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
	
	@Override
	public List<BoardAttachVO> getAttachList(Long board_num) {
		//특정 게시물의 번호로 첨부파일을 찾는 작업 

		log.info("get Attach list by board_num" + board_num);

		return attachMapper.getAttachList(board_num);
	}

	@Override
	public boolean removeBoard(Long board_num, HttpServletRequest request) {

		List<BoardAttachVO> attachList = attachMapper.getAttachList(board_num); 
	 	
	 	if(attachList == null || attachList.size() == 0) {
			
	 			return boardMapper.deleteBoard(board_num) == 1;
			
	    }else{
	    	
		    	if(boardMapper.deleteBoard(board_num) == 1){
		    		
		    		deleteS3Files(attachList, request);//s3에 첨부된 실제 파일 모두 삭제
		    		
		    		return true;
		    		
		    	}else{
		    		
		    		return false;
		    	}
	    }
	}
	
	@Override
	public boolean removeBoards(String checkRow, HttpServletRequest request) {
		
		String[] arrIdx = checkRow.split(",");
		
		for (int i=0; i<arrIdx.length; i++) {
			
			Long board_num = Long.parseLong(arrIdx[i]); 
			
			List<BoardAttachVO> attachList = attachMapper.getAttachList(board_num); 
			
			if(attachList == null || attachList.size() == 0) {
				
	 			if(boardMapper.deleteBoard(board_num) != 1) {
	 				
	 				return false;
	 			}
	 			
		    }else{
		    	
		    	if(boardMapper.deleteBoard(board_num) == 1){
			    		
		    		deleteS3Files(attachList, request);//s3에 첨부된 실제 파일 모두 삭제
			    		
		    	}else{
			    		
		    		return false;
		    	}
		    }
		}
		return true;
	}
 	
	private void deleteS3Files(List<BoardAttachVO> attachList, HttpServletRequest request) {
	    
	    log.info("deleteS3Files........"+attachList);
	    
	    for (BoardAttachVO attach : attachList) {
	    	
	    	String path = attach.getUploadPath();
			String filename = attach.getUuid()+"_"+attach.getFileName();
						    	  
			if(myS3Util.deleteObject(path, filename)) {
				
				if (attach.isFileType()) {//만약 이미지파일이었다면
					
					myS3Util.deleteObject(path, "s_"+filename);//썸네일도 삭제
				}
			}
        }
	}
		
	@Transactional
	@Override
	public String likeBoard(commonVO vo) {
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		boolean CheckResult = boardMapper.checkBoardLikeButton(boardLikeVO) == 1;// 글 좋아요 버튼 누름 여부 체크
		
		boolean returnVal = false;
		
		alarmVO alarmVO = vo.getAlarmVO();
		
		if(CheckResult == false){ 
			
			commonMapper.insertAlarm(alarmVO);
			
			returnVal = boardMapper.pushBoardLikeButton(boardLikeVO) == 1 && boardMapper.plusBoardLikeCount(boardLikeVO.getBoard_num()) == 1;
						//글 좋아요 버튼 누르기 + 글 좋아요 카운트 +1 더하기
		}else{ 
			
			commonMapper.deleteAlarm(alarmVO);
			
			returnVal = boardMapper.pullBoardLikeButton(boardLikeVO) == 1 && boardMapper.minusBoardLikeCount(boardLikeVO.getBoard_num()) == 1; 
		}				//글 좋아요 버튼 당기기(취소) + 글 좋아요 카운트 빼기(-1) 
		
		if(returnVal == true){ 
			
			return boardMapper.getLikeCount(boardLikeVO.getBoard_num());// 좋아요 카운트 가져오기
			
		}else {
			
			return null;
		}
	}
	
	@Transactional
	@Override
	public String disLikeBoard(commonVO vo) {
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		boolean CheckResult = boardMapper.checkBoardDisLikeButton(boardDisLikeVO) == 1;// 글 싫어요 버튼 누름 여부 체크
		
		boolean returnVal = false;
		
		alarmVO alarmVO = vo.getAlarmVO();
		
		if(CheckResult == false){ 
			
			commonMapper.insertAlarm(alarmVO);
			
			returnVal = boardMapper.pushBoardDisLikeButton(boardDisLikeVO) == 1 && boardMapper.plusBoardDisLikeCount(boardDisLikeVO.getBoard_num()) == 1;
						//글 싫어요 버튼 누르기 + 글 싫어요 카운트 -1 더하기
		}else{ 
			
			commonMapper.deleteAlarm(alarmVO);
			
			returnVal = boardMapper.pullBoardDisLikeButton(boardDisLikeVO) == 1 && boardMapper.minusBoardDisLikeCount(boardDisLikeVO.getBoard_num()) == 1; 
		}				//글 싫어요 버튼 당기기(취소) + 글 싫어요 카운트 빼기(+1)
		
		if(returnVal == true){ 
			
			return boardMapper.getDisLikeCount(boardDisLikeVO.getBoard_num());// 좋아요 카운트 가져오기
			
		}else {
			
			return null;
		}
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
	public Long getRecentBoard_num(){//테스트 코드용
		
		return boardMapper.getRecentBoard_num();
	}
}
