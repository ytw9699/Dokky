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
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
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
	
	@Setter(onMethod_ = @Autowired)
	private CommonMapper commonMapper;
	
	@Override
	public List<BoardVO> getList(Criteria cri) {

		log.info("get List with criteria: " + cri);

		return mapper.getList(cri);
	}
	
	@Override
	public List<BoardVO> getListWithOrder(Criteria cri) {

		log.info("getListWithOrder: " + cri);

		return mapper.getListWithOrder(cri);
	}
	
	@Override
	public List<BoardVO> getAllListWithOrder(Criteria cri) {

		log.info("getAllListWithOrder: " + cri);

		return mapper.getAllListWithOrder(cri);
	}
	
	@Override
	public List<BoardVO> getAllList(Criteria cri) {

		log.info("get getAllList with criteria: " + cri);

		return mapper.getAllList(cri);
	}
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		log.info("register......" + board);

		mapper.insertSelectKey(board); 

		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {//첨부파일 여부확인
			return;
		}
		
		log.info("register......getAttachList");

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

		attachMapper.deleteAll(board.getNum());//일단 디비에서 첨부파일 정보 모두다 삭제,실제파일은 삭제안됨

		boolean modifyResult = mapper.update(board) == 1; 
		
		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {

			board.getAttachList().forEach(attach -> {

				attach.setNum(board.getNum());
				attachMapper.insert(attach);//다시 모든파일 정보를 다 디비에 넣어준다
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
	public int getAllTotalCount(Criteria cri) {

		log.info("get AllTotal count");
		return mapper.getAllTotalCount(cri);
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
	public int registerLike(commonVO vo) {//좋아요 컬럼 등록 및 좋아요 push
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("registerLike...." + vo);
		
		mapper.registerLike(boardLikeVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushLike....");
		
		return mapper.pushLike(boardLikeVO.getNum()); 
	}
	
	@Transactional
	@Override 
	public int registerDisLike(commonVO vo) {//싫어요 컬럼 등록 및 싫어요 push

		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("registerDisLike...." + vo);
		mapper.registerDisLike(boardDisLikeVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushDisLike....");
		return mapper.pushDisLike(boardDisLikeVO.getNum()); 
	}
	
	@Transactional
	@Override
	public int pushLike(commonVO vo) {//좋아요 누르기  
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("pushLikeValue...."+vo);  
		
		mapper.pushLikeValue(boardLikeVO);
		
		log.info("insertAlarm: "+vo.getAlarmVO());
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushLike....");
		
		return mapper.pushLike(boardLikeVO.getNum()); 
	}
	
	@Transactional
	@Override
	public int pullDisLike(commonVO vo) {//싫어요 취소 pull
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("pulldislikeCheck...."+vo);
		
		mapper.pulldislikeCheck(boardDisLikeVO); 
		
		log.info("insertAlarm: ");
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		log.info("pullDisLike....");
		
		return mapper.pullDisLike(boardDisLikeVO.getNum()); 
	}
	
	@Transactional
	@Override
	public int pullLike(commonVO vo) {//좋아요 취소 pull
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		log.info("pullLikeValue...."+vo);
		
		mapper.pullLikeValue(boardLikeVO);
		
		log.info("insertAlarm: ");
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		log.info("pullLike....");
		
		return mapper.pullLike(boardLikeVO.getNum());
	}
	
	@Transactional
	@Override 
	public int pushDisLike(commonVO vo) {//싫어요 누르기
		
		BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
		log.info("pushDislikeValue...."+vo);
		mapper.pushDislikeValue(boardDisLikeVO); 
		
		log.info("insertAlarm: "); 
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("pushDisLike....");
		return mapper.pushDisLike(boardDisLikeVO.getNum());
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
	public String donateMoney(commonVO vo) {
		
		donateVO donateVO = vo.getDonateVO();
		
		log.info("updateMycash");
		mapper.updateMycash(donateVO.getMoney(),donateVO.getUserId());
		
		log.info("insertMyCashHistory");
		mapper.insertMyCashHistory(donateVO);
		
		log.info("updateBoardUserCash");
		mapper.updateBoardUserCash(donateVO);
		
		log.info("insertBoardUserCashHistory");
		mapper.insertBoardUserCashHistory(donateVO);
		
		log.info("updateBoardMoney");
		mapper.updateBoardMoney(donateVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("getBoardMoney");
		return mapper.getBoardMoney(donateVO);
	}
	
	@Override
	public boolean insertReportdata(reportVO vo) {

		log.info("insertReportdata");
		
		return mapper.insertReportdata(vo) == 1;
	}
	
	
	
}
