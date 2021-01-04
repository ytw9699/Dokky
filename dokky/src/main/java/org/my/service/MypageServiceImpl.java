package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.ReplyVO;
	import org.my.domain.cashVO;
	import org.my.domain.scrapVO;
	import org.my.mapper.MypageMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j 
@Service
public class MypageServiceImpl implements MypageService {

	@Setter(onMethod_ = @Autowired)
	private MypageMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	@Override
	public MemberVO getMyInfo(String userId) {

		log.info("getMyInfo");

		return mapper.getMyInfo(userId);
	}
	
	@Transactional
	@Override
	public boolean updateMyInfo(MemberVO board) {

		log.info("updateMyInfo......" + board);
		
		String nickName = board.getNickName();
		
		String userId = board.getUserId();
		
		boolean nickNameResult = nickName.equals(mapper.getMyNickName(userId));//현재 나의 닉네임과 폼에서 입력한 닉네임이 같은지
		
		if(!nickNameResult) {//닉네임을 변경한다면 
			
			mapper.updateBoardNickName(userId, nickName);//게시글 닉네임 변경처리
			
			mapper.updateReplyNickName(userId, nickName);//댓글 닉네임 변경처리
			
			mapper.updateNoteFromNickName(userId, nickName);//쪽지 받는이 닉네임 변경처리
			
			mapper.updateNoteToNickName(userId, nickName);//쪽지 보낸이 닉네임 변경처리
			
			mapper.updateReportedNickName(userId, nickName);//신고 당한자 닉네임 변경처리 
			
			mapper.updateReportingNickName(userId, nickName);//신고 하는자 닉네임 변경처리
			
			mapper.updateAlarmNickName(userId, nickName);//알림 닉네임 변경처리
			
			mapper.updateCashlistNickName(userId, nickName);//캐시 내역 닉네임 변경처리
			
		}
		
		boolean updateResult = mapper.updateMyInfo(board) == 1; //회원테이블 변경처리
		
		return updateResult;
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
	public List<scrapVO> getMyScraplist(Criteria cri) {

		log.info("getMyScraplist with criteria: " + cri);

		return mapper.getMyScraplist(cri);
	}
	
	@Override
	public int getMyScrapCount(String userId) {
		
		log.info("getMyScrapCount");
		
		int getResult = mapper.getMyScrapCount(userId); 
		
		return getResult;
	}
	
	@Override
	public void removeScrap(Long scrap_num) {
		
		log.info("removeScrap");
		
		mapper.removeScrap(scrap_num);
	}
	
	@Override
	public boolean insertChargeData(cashVO vo) {
		
		log.info("insertChargeData");
		
		boolean insertResult = mapper.insertChargeData(vo) == 1; 
		
		return insertResult;
	}
	
	@Override
	public boolean insertReChargeData(cashVO vo) {
		
		log.info("insertReChargeData");
		
		boolean insertResult = mapper.insertReChargeData(vo) == 1; 
		
		return insertResult;
	}
	
	@Override
	public List<cashVO> getMyCashHistory(Criteria cri) {

		log.info("getMyCashHistory");

		return mapper.getMyCashHistory(cri);
	}
	
	@Override
	public int getMyCashHistoryCount(String userId) {
		
		log.info("getMyCashHistoryCount");
		
		int getResult = mapper.getMyCashHistoryCount(userId); 
		
		return getResult;
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

