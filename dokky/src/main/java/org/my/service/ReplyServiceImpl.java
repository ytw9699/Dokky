package org.my.service;

	import org.my.domain.Criteria;
import org.my.domain.ReplyLikeVO;
import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;
	import org.my.mapper.BoardMapper;
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
		
	@Transactional
	@Override
	public int register(ReplyVO vo) {

		log.info("register......" + vo);

		boardMapper.updateReplyCnt(vo.getNum(),1);
		
		return mapper.insert(vo);

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
		public String checkReplyLikeValue(ReplyLikeVO vo) { 
			
			log.info("checkReplyLikeValue");
			return mapper.checkReplyLikeValue(vo); 
		}
		
		@Transactional
		@Override
		public int registerReplyLike(ReplyLikeVO vo) {//댓글 좋아요 컬럼 등록 및 좋아요 push

			log.info("registerReplyLike...." + vo);
			
			mapper.registerReplyLike(vo);
			
			log.info("pushReplyLike...."+vo.getReply_num());
			
			return mapper.pushReplyLike(vo.getReply_num()); 
		}
		
		@Transactional
		@Override
		public int pushReplyLike(ReplyLikeVO vo) {//댓글 좋아요 누르기  
			
			log.info("pushLikeValue...."+vo);  
			
			mapper.pushReplyLikeValue(vo);
			
			log.info("pushReplyLike...."+vo.getReply_num());
			
			return mapper.pushReplyLike(vo.getReply_num()); 
		}
		
		@Transactional 
		@Override
		public int pullReplyLike(ReplyLikeVO vo) {//댓글  좋아요 취소 pull
			
			log.info("pullReplyLikeValue...."+vo);
			
			mapper.pullReplyLikeValue(vo);
			
			log.info("pullReplyLike...."+vo.getReply_num());
			
			return mapper.pullReplyLike(vo.getReply_num());
		}
		
		@Override
		public String getReplyLikeCount(Long reply_num) {
	  
			log.info("getReplyLikeCount");
			return mapper.getReplyLikeCount(reply_num);
		}
}

