/*
- 마지막 업데이트 2022-06-12
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.common.AlarmVO;
	import org.my.domain.common.CommonVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.reply.ReplyDisLikeVO;
	import org.my.domain.reply.ReplyDonateVO;
	import org.my.domain.reply.ReplyLikeVO;
	import org.my.domain.reply.ReplyPageDTO;
	import org.my.domain.reply.ReplyVO;
	import org.my.mapper.BoardMapper;
	import org.my.mapper.CommonMapper;
	import org.my.mapper.ReplyMapper;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {
  
	private final ReplyMapper replyMapper;
	private final BoardMapper boardMapper;
	private final CommonMapper commonMapper;
		
	@Transactional
	@Override
	public int create(CommonVO vo) {
		
		int returnVal;
		
		log.info("create......reply " + vo);
		ReplyVO replyVO = vo.getReplyVO();
		AlarmVO alarmVO = vo.getAlarmVO();

		log.info("updateReplyCnt......" + vo);
		boardMapper.updateReplyCnt(replyVO.getBoard_num(), 1);
		
		if(replyVO.getGroup_num() == 0 ) {//시퀀스값은 디폴트 1부터 시작하니까 0으로 기준을 잡자
			
			log.info("insertParentReply......" + replyVO); 
			
			returnVal = replyMapper.insertParentReply(replyVO);//부모 댓글 입력
			
		}else{//부모의 자식 댓글 입력 
			
			List<ReplyVO> replylist = replyMapper.selectReplylistToDecideStep(replyVO);//댓글들의 순서값을 어떻게 할지 결정하는 중요한 리스트
			//부모댓글의 출력 순서(Order_step)값보다 크면서(밑에 있으면서), 부모댓글의(레벨)깊이 값보다 작거나 같은 댓글들의 리스틀 가져온다.
			//즉 자식댓글을 입력함으로써, Order_step의 값을 +1씩 바꿔줄 댓글들의 리스트가 있다면 가져오는것
			
			if(replylist.isEmpty()){//값을 바꿔줄 댓글의 리스트가 없다면
				
				int lastReplyStep = replyMapper.lastReplyStep(replyVO.getGroup_num());
				//같은 댓글의 그룹내에 맨 마지막 댓글의 순서번호(Order_step)를 가져오고
				
				replyVO.setOrder_step(lastReplyStep+1);//그 순서번호에 +1을 해준다 
				replyVO.setDepth(replyVO.getDepth()+1);//깊이는 부모보다 +1해서 입력 해줌
				
			}else{//값을 바꿔줄 댓글의 리스트가 있다면 
				
				//한개의 (부모)그룹번호 기준으로 생각할때 부모 댓글의 자식댓글의 출력 순서는 자식댓글을 달고자 하는 대상인 부모댓글(루트가 아닌 경우도 포함)의
				//출력 순서값보다 크면서(밑에 있으면서), 부모댓글의 (레벨)깊이값보다 작거나 같은 최초의 댓글에 해당하는 순서(Order_step)로 새롭게 적용 된다
				//즉 순서값을 교체해주는것
				
				ReplyVO firstVO = replylist.get(0);
				
				replyMapper.plusOrder_step(firstVO);//최초댓글을 포함해서 나머지 아래 댓글의 순서값 모두 1씩 올려줌
				
				replyVO.setOrder_step(firstVO.getOrder_step());//최초의 댓글에 해당하는 순서값으로 변경후 입력
				replyVO.setDepth(replyVO.getDepth()+1);//깊이는 부모보다 +1해서 입력 해줌
			}
				
			log.info("insertChildReply......" + replyVO); 
			
			returnVal =  replyMapper.insertChildReply(replyVO);
		}
		
		if(alarmVO != null) {
			
			log.info("insertAlarm"); 
			
			alarmVO.setCommonVar3(replyVO.getReply_num());
			commonMapper.insertAlarm(alarmVO);
		}
		
		return returnVal;
	} 
	
	@Override
	public int getReplyPageNum(Long board_num, Long reply_num){
		
		int[] replyNums = replyMapper.getReplyNums(board_num);
		
		for(int i=0; i<replyNums.length; i++){
			
			if(replyNums[i] == reply_num) {
				return i+1;
			}
		}
		
		return 1;
	}
	
	@Override
	public ReplyVO read(Long reply_num) {
	
	    log.info("read......" + reply_num);
	
	    return replyMapper.read(reply_num);
	}
	
	@Override
	public ReplyPageDTO readReplyList(Criteria cri, Long board_num) {
		
		  return new ReplyPageDTO(replyMapper.getReplyCnt(board_num), 
	    						  replyMapper.readReplyListWithPaging(cri, board_num));
	}

	@Override
	public int update(ReplyVO vo) {
	
	    log.info("update......" + vo);
	
	    return replyMapper.update(vo);
	}

    @Transactional
	@Override 
	public int delete(Long reply_num) {

    	log.info("delete...." + reply_num);

		Long board_num = replyMapper.getBoardNum(reply_num); 

		boardMapper.updateReplyCnt(board_num, -1);
		
		return replyMapper.delete(reply_num);
		
	}
	  
	@Transactional
	@Override 
	public String giveReplyWriterMoney(CommonVO vo) {
		
		ReplyDonateVO replyDonateVO = vo.getReplyDonateVO();
		
		log.info("minusMycash");
		boardMapper.minusMycash(replyDonateVO.getMoney(), replyDonateVO.getUserId());
		
		log.info("createMyCashHistory");
		replyMapper.createMyCashHistory(replyDonateVO); 
		 
		log.info("plusReplyUserCash");
		replyMapper.plusReplyUserCash(replyDonateVO);
		 
		log.info("createReplyUserCashHistory");
		replyMapper.createReplyUserCashHistory(replyDonateVO);
		
		log.info("plusReplyMoney");
		replyMapper.plusReplyMoney(replyDonateVO);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("getReplyMoney");
		return replyMapper.getReplyMoney(replyDonateVO);
	}
	  
	@Override
	public boolean checkReplyLikeButton(ReplyLikeVO vo) { 
		
		log.info("checkReplyLikeButton");
		
		return replyMapper.checkReplyLikeButton(vo) == 1; 
	}
	
	@Override
	public boolean checkReplyDislikeButton(ReplyDisLikeVO vo) {
		
		log.info("checkReplyDislikeButton"); 
		
		return replyMapper.checkReplyDislikeButton(vo) == 1; 
	}
		
	@Transactional
	@Override
	public boolean pushReplyLikeButton(CommonVO vo) {//댓글 좋아요 버튼 누르기
		
		log.info("pushReplyLikeButton...." + vo);
		
		ReplyLikeVO replyLikeVO = vo.getReplyLikeVO();
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		return replyMapper.pushReplyLikeButton(replyLikeVO) == 1 && replyMapper.plusReplyLikeCount(replyLikeVO.getReply_num()) == 1; 
	}
	
	@Transactional
	@Override
	public boolean pushReplyDislikeButton(CommonVO vo) {//댓글 싫어요 버튼 누르기
		
		log.info("pushReplyDislikeButton...." + vo);
		
		ReplyDisLikeVO replyDislikeVO = vo.getReplyDisLikeVO();
		
		log.info("insertAlarm");
		
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		return replyMapper.pushReplyDislikeButton(replyDislikeVO) == 1 && replyMapper.plusReplyDislikeCount(replyDislikeVO.getReply_num()) == 1; 
	}
		
	@Transactional
	@Override
	public boolean pullReplyLikeButton(CommonVO vo) {//댓글 좋아요 당기기(취소)
		
		log.info("pullReplyLikeButton...." + vo);
		
		ReplyLikeVO replyLikeVO = vo.getReplyLikeVO();
		
		log.info("deleteAlarm");
		
		commonMapper.deleteAlarm(vo.getAlarmVO());
		
		return replyMapper.pullReplyLikeButton(replyLikeVO) == 1 && replyMapper.minusReplyLikeCount(replyLikeVO.getReply_num()) == 1; 
	}
	
	@Transactional
	@Override
	public boolean pullReplyDislikeButton(CommonVO vo) {//댓글 싫어요 당기기(취소)
		
		log.info("pullReplyDislikeButton...." + vo);
		
		ReplyDisLikeVO replyDislikeVO = vo.getReplyDisLikeVO();
		
		log.info("deleteAlarm");
		
		commonMapper.deleteAlarm(vo.getAlarmVO());
																					
		return replyMapper.pullReplyDislikeButton(replyDislikeVO) == 1 && replyMapper.minusReplyDislikeCount(replyDislikeVO.getReply_num()) == 1; 
	}
		
	@Override
	public String getLikeCount(Long reply_num) {
  
		log.info("getLikeCount");
		
		return replyMapper.getLikeCount(reply_num);
	}
	
	@Override
	public String getDislikeCount(Long reply_num) {
 
		log.info("getDislikeCount");
		
		return replyMapper.getDislikeCount(reply_num);
	}
		
}

