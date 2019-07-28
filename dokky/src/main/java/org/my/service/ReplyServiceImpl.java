package org.my.service;

	import org.my.domain.BoardDisLikeVO;
import org.my.domain.BoardLikeVO;
import org.my.domain.Criteria;
import org.my.domain.ReplyDisLikeVO;
import org.my.domain.ReplyLikeVO;
import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;
import org.my.domain.commonVO;
import org.my.domain.donateVO;
import org.my.domain.replyDonateVO;
import org.my.mapper.BoardMapper;
import org.my.mapper.CommonMapper;
import org.my.mapper.ReplyMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	
	import lombok.Setter;
	//import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Service
@Log4j
//@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {
  
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_ = @Autowired)
	private CommonMapper commonMapper;
		
	@Transactional
	@Override
	public int register(commonVO vo) {
		
		log.info("register......" + vo);
		
		ReplyVO replyVO = vo.getReplyVO();

		log.info("updateReplyCnt......" + vo);
		boardMapper.updateReplyCnt(replyVO.getNum(),1);
		
		log.info("insertAlarm: ");
		commonMapper.insertAlarm(vo.getAlarmVO());
		
		log.info("insert......" + replyVO);
		return mapper.insert(replyVO);

	} 
	
	 @Override
	 public ReplyVO get(Long reply_num) {
	
	    log.info("get......" + reply_num);
	
	    return mapper.read(reply_num);
	
	 }

	  @Override
	  public int modify(ReplyVO vo) {
	
	    log.info("modify......" + vo);
	
	    return mapper.update(vo);
	
	  }

    @Transactional
	@Override 
	public int remove(Long reply_num) {

		log.info("remove...." + reply_num);

		ReplyVO vo = mapper.read(reply_num); 

		boardMapper.updateReplyCnt(vo.getNum(), -1);
		
		return mapper.delete(reply_num);
		
		}
	  
	  @Override
	  public ReplyPageDTO getListPage(Criteria cri, Long num) {
	       
	    return new ReplyPageDTO(
	        mapper.getCountBynum(num), 
	        mapper.getListWithPaging(cri, num));
	  }
	  
		@Override
		public String checkLikeValue(ReplyLikeVO vo) { 
			
			log.info("checkLikeValue");
			return mapper.checkLikeValue(vo); 
		}
		
		@Transactional
		@Override
		public int registerLike(commonVO vo) {//댓글 좋아요 컬럼 등록 및 좋아요 push

			ReplyLikeVO replyLikeVO = vo.getReplyLikeVO();
			
			log.info("registerLike...." + vo);
			mapper.registerLike(replyLikeVO); 
			
			log.info("insertAlarm: ");
			commonMapper.insertAlarm(vo.getAlarmVO());
			
			log.info("pushLike....");
			return mapper.pushLike(replyLikeVO.getReply_num()); 
		}
		
		@Transactional
		@Override
		public int pushLike(commonVO vo) {//댓글 좋아요 누르기  
			
			ReplyLikeVO replyLikeVO = vo.getReplyLikeVO();
			
			log.info("pushLikeValue...."+replyLikeVO);  
			mapper.pushLikeValue(replyLikeVO);
			
			log.info("insertAlarm: "+vo.getAlarmVO());
			commonMapper.insertAlarm(vo.getAlarmVO());
			
			log.info("pushLike....");
			return mapper.pushLike(replyLikeVO.getReply_num()); 
		}
		
		@Transactional 
		@Override
		public int pullLike(commonVO vo) {//댓글  좋아요 취소 pull
			
			ReplyLikeVO replyLikeVO = vo.getReplyLikeVO();
			
			log.info("pullLikeValue...."+vo);
			mapper.pullLikeValue(replyLikeVO);
			
			log.info("insertAlarm: ");
			commonMapper.deleteAlarm(vo.getAlarmVO());
			
			log.info("pullLike....");
			return mapper.pullLike(replyLikeVO.getReply_num());
		}
		
		@Override
		public String getLikeCount(Long reply_num) {
	  
			log.info("getLikeCount");
			return mapper.getLikeCount(reply_num);
		}
		
		@Transactional
		@Override
		public int registerDisLike(commonVO vo) {//싫어요 컬럼 등록 및 싫어요 push

			ReplyDisLikeVO replyDisLikeVO = vo.getReplyDisLikeVO();
			
			log.info("registerDisLike...." + vo);
			mapper.registerDisLike(replyDisLikeVO);
			
			log.info("insertAlarm: ");
			commonMapper.insertAlarm(vo.getAlarmVO());
			
			log.info("pushDisLike....");
			return mapper.pushDisLike(replyDisLikeVO.getReply_num()); 
		}
		
		@Transactional
		@Override
		public int pullDisLike(commonVO vo) {//싫어요 취소 pull
			
			ReplyDisLikeVO replyDisLikeVO = vo.getReplyDisLikeVO();
			
			log.info("pulldislikeCheck...."+vo);
			mapper.pulldislikeCheck(replyDisLikeVO); 
			
			log.info("insertAlarm: ");
			commonMapper.deleteAlarm(vo.getAlarmVO());
			
			log.info("pullDisLike....");
			return mapper.pullDisLike(replyDisLikeVO.getReply_num()); 
		}
		
		@Transactional
		@Override 
		public int pushDisLike(commonVO vo) {//싫어요 누르기
			
			ReplyDisLikeVO replyDisLikeVO = vo.getReplyDisLikeVO();
			
			log.info("pushDislikeValue...."+vo);
			mapper.pushDislikeValue(replyDisLikeVO); 
			
			log.info("insertAlarm: "); 
			commonMapper.insertAlarm(vo.getAlarmVO());
			
			log.info("pushDisLike....");
			return mapper.pushDisLike(replyDisLikeVO.getReply_num());
		}
		
		@Override
		public String checkDisLikeValue(ReplyDisLikeVO vo) {
			
			log.info("checkDisLikeValue"); 
			return mapper.checkDisLikeValue(vo); 
		}
		
		@Override
		public String getDisLikeCount(Long num) {
	 
			log.info("getDisLikeCount");
			return mapper.getDisLikeCount(num);
		}
		
		@Transactional
		@Override 
		public String replyDonateMoney(commonVO vo) {
			
			replyDonateVO replyDonateVO = vo.getReplyDonateVO();
			
			log.info("updateMycash");
			boardMapper.updateMycash(replyDonateVO.getMoney(),replyDonateVO.getUserId());
			
			log.info("insertMyCashHistory");
			mapper.insertMyCashHistory(replyDonateVO); 
			 
			log.info("updateReplyUserCash");
			log.info(vo);
			mapper.updateReplyUserCash(replyDonateVO);
			 
			log.info("insertReplyUserCashHistory");
			   mapper.insertReplyUserCashHistory(replyDonateVO);
			
			log.info("updateReplyMoney");
			mapper.updateReplyMoney(replyDonateVO);
			
			log.info("insertAlarm: ");
			commonMapper.insertAlarm(vo.getAlarmVO());
			
			log.info("getReplyMoney");
			return mapper.getReplyMoney(replyDonateVO);
		}
}

