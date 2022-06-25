/*
- 마지막 업데이트 2022-06-20
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.board.BoardVO;
	import org.my.domain.common.CashVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.ScrapVO;
	import org.my.domain.reply.ReplyVO;
	import org.my.mapper.MypageMapper;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Log4j 
@Service
public class MypageServiceImpl implements MypageService {
	
	private final MypageMapper mapper;
	
	@Transactional
	@Override
	public boolean updateMyInfo(MemberVO board) {

		log.info("updateMyInfo......" + board);
		
		String nickName = board.getNickName();
		
		String userId = board.getUserId();
		
		boolean nickNameResult = nickName.equals(mapper.getMyNickName(userId));
		
		if(!nickNameResult) { 
			
			mapper.updateBoardNickName(userId, nickName);
			
			mapper.updateReplyNickName(userId, nickName);
			
			mapper.updateNoteFromNickName(userId, nickName);
			
			mapper.updateNoteToNickName(userId, nickName);
			
			mapper.updateReportedNickName(userId, nickName); 
			
			mapper.updateReportingNickName(userId, nickName);
			
			mapper.updateAlarmNickName(userId, nickName);
			
			mapper.updateCashlistNickName(userId, nickName);
			
			mapper.updateChatRoomNickName(userId, nickName);
			
			mapper.updateChatMemberNickName(userId, nickName);
			
			mapper.updateChatContentNickName(userId, nickName);
			
			mapper.updateChatReadNickName(userId, nickName);
			
		}
		
		return mapper.updateMyInfo(board) == 1;
	}
	
	@Override
	public List<BoardVO> getMyBoardList(Criteria cri) {

		log.info("getMyBoardList with criteria: " + cri);

		return mapper.getMyBoardList(cri);
	}
	
	@Override
	public int getMyBoardCount(Criteria cri) {

		log.info("getMyBoardCount");
		
		return mapper.getMyBoardCount(cri);
	}
	
	@Override
	 public List<ReplyVO> getMyReplylist(Criteria cri) {
	       
		log.info("getMyReplylist with criteria: " + cri);
		
	    return mapper.getMyReplylist(cri); 
	}
	
	@Override
	public int getMyReplyCount(Criteria cri) {

		log.info("getMyReplyCount");
		
		return mapper.getMyReplyCount(cri);
	}
	
	@Override
	public List<ScrapVO> getMyScraplist(Criteria cri) {

		log.info("getMyScraplist with criteria: " + cri);

		return mapper.getMyScraplist(cri);
	}
	
	@Override
	public int getMyScrapCount(String userId) {
		
		log.info("getMyScrapCount");
		
		int getResult = mapper.getMyScrapCount(userId); 
		
		return getResult;
	}
	
	@Transactional
	@Override 
	public boolean removeScraps(String checkRow) {
		
		String[] arrIdx = checkRow.split(",");
	 	
	 	for (int i=0; i<arrIdx.length; i++) {
	 		
	 		Long scrap_num = Long.parseLong(arrIdx[i]); 
	 		
	 		if(mapper.removeScrap(scrap_num) != 1) {
	 			return false;
	 		}
	 		
	 		log.info("removeScrap...." + scrap_num);
	 	}
	 	
	 	return true;
	}
	
	@Override
	public boolean insertChargeData(CashVO vo) {
		
		log.info("insertChargeData");
		
		return mapper.insertChargeData(vo) == 1;
	}
	
	@Override
	public boolean insertReChargeData(CashVO vo) {
		
		log.info("insertReChargeData");
		
		return mapper.insertReChargeData(vo) == 1;
	}
	
	@Override
	public List<CashVO> getMyCashHistory(Criteria cri) {

		log.info("getMyCashHistory");

		return mapper.getMyCashHistory(cri);
	}
	
	@Override
	public int getMyCashHistoryCount(String userId) {
		
		log.info("getMyCashHistoryCount");
		
		return mapper.getMyCashHistoryCount(userId);
	}
	
	@Override 
	public boolean myWithdrawal(String userId){

		log.info("myWithdrawal...");
		
		return mapper.updateEnabled(userId) == 1;
	}
	
	@Override
	public String getMemberPW(String userId) {

		log.info("getMemberPW");

		return mapper.getMemberPW(userId);
	}
	
	@Override
	public boolean changeMyPassword(String userId, String userPw) {
		
		log.info("changeMyPassword");
		
		return mapper.changeMyPassword(userId, userPw) == 1;
	}
}

