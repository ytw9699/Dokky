/*
- 마지막 업데이트 2022-06-26
*/
package org.my.controller;
	import org.my.domain.common.CommonVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.reply.ReplyDisLikeVO;
	import org.my.domain.reply.ReplyLikeVO;
	import org.my.domain.reply.ReplyPageDTO;
	import org.my.domain.reply.ReplyVO;
	import org.my.service.ReplyService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.DeleteMapping;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;
			
@RequestMapping("/replies/")
@Controller
@Log4j
@RequiredArgsConstructor
public class ReplyController {
	
	private final ReplyService replyService;
	
	@PreAuthorize("hasRole('ROLE_USER') and principal.username == #vo.replyVO.userId")
	@ResponseBody
	@PostMapping(value = "/reply", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> createReply(@RequestBody CommonVO vo) {

		log.info("/replies/reply");
		log.info("vo : " + vo);
		
		int insertCount = replyService.create(vo);//댓글입력+알람입력
		
		ReplyVO replyVO = vo.getReplyVO();
		
		int result = replyService.getReplyPageNum(replyVO.getBoard_num(), replyVO.getReply_num());
		
		String replyPageNum = Integer.toString(result);//대댓글 등록시 replyPageNum 사용
		
		return insertCount == 1  
				? new ResponseEntity<>(replyPageNum, HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value = "/reply/{reply_num}", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody
	public ResponseEntity<ReplyVO> readReply(@PathVariable("reply_num") Long reply_num) {
	
		log.info("/replies/reply/"+reply_num);
		
		return new ResponseEntity<>(replyService.read(reply_num), HttpStatus.OK);
	}
	
	@GetMapping(value = "/list/{board_num}/{page}", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	@ResponseBody						//댓글 리스트
	public ResponseEntity<ReplyPageDTO> readReplyList(@PathVariable("board_num") Long board_num, 
													  @PathVariable("page") int page) {
		
		log.info("/replies/list/"+board_num+"/"+page);
		
		Criteria cri = new Criteria(page, 10);//댓글을 10개씩 보여줌 
		
		log.info("cri:" + cri);

		return new ResponseEntity<>(replyService.readReplyList(cri, board_num), HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #vo.userId")
	@DeleteMapping(value = "/reply/{reply_num}", produces = { MediaType.TEXT_PLAIN_VALUE })
	@ResponseBody
	public ResponseEntity<String> deleteReply(@RequestBody ReplyVO vo, 
											  @PathVariable("reply_num") Long reply_num) {
		
		log.info("/replies/reply/"+reply_num);
		
		return replyService.delete(reply_num) == true
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	} 
	
	@PreAuthorize("principal.username == #userId")  
	@PostMapping("/deleteReplies")//댓글 다중삭제
		public String deleteReplies(@RequestParam("checkRow") String checkRow ,
				      				@RequestParam("userId")String userId, Criteria cri, Model model) {

		log.info("/replies/deleteReplies");
		
		boolean result = false;
				result = replyService.deleteReplies(checkRow);

		if(result == true) {
			
			return "redirect:/mypage/myReplylist?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
			
		}else {
			
			model.addAttribute("message", "서버에러로 삭제할 수 없습니다.");
		
			return "error/commonError";  
		
		}
	}

	@PreAuthorize("hasRole('ROLE_USER') and principal.username == #vo.userId")
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, 
					value = "/reply", consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE }) 
	@ResponseBody
	public ResponseEntity<String> updateReply(@RequestBody ReplyVO vo) {

		log.info("/replies/reply");
		log.info("ReplyVO: " + vo);

		return replyService.update(vo) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #vo.ReplyDonateVO.userId")
	@PostMapping(value = "/giveReplyWriterMoney", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> giveReplyWriterMoney(@RequestBody CommonVO vo) {//댓글 작성자에게 기부
		
			log.info("/replies/giveReplyWriterMoney");
			log.info("ReplyDonateVO: " + vo);
			
			String replyMoney = replyService.giveReplyWriterMoney(vo);
			
			if(replyMoney != null) {
				
				return new ResponseEntity<>(replyMoney, HttpStatus.OK); 
				
			}else {
				
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
	}
	
	@PreAuthorize("principal.username == #vo.replyLikeVO.userId")
	@PostMapping(value = "/likeReply", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> likeReply(@RequestBody CommonVO vo) {//댓글 좋아요 누르기 및 취소
		
			log.info("/replies/likeReply");
			log.info("replyLikeVO = : " + vo);
			
			ReplyLikeVO replyLikeVO = vo.getReplyLikeVO();
			
			boolean CheckResult = replyService.checkReplyLikeButton(replyLikeVO);//버튼 누름 여부 확인
			
			boolean returnVal = false;
			
			if(CheckResult == false){ 
				
				log.info("pushReplyLikeButton..." );
				returnVal = replyService.pushReplyLikeButton(vo);//댓글 좋아요 누르기
				 
			}else if(CheckResult == true){ 
				
				returnVal = replyService.pullReplyLikeButton(vo);//댓글 좋아요 당기기(취소)
				log.info("pullReplyLikeButton...");
			}
			
			log.info("returnVal: " + returnVal);
			
			return returnVal == true ? new ResponseEntity<>(replyService.getLikeCount(replyLikeVO.getReply_num()), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #vo.replyDisLikeVO.userId")
	@PostMapping(value = "/disLikeReply", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> disLikeReply(@RequestBody CommonVO vo) {//댓글 싫어요 누르기 및 취소
			
			log.info("/replies/disLikeReply");
			log.info("replyDisLikeVO = : " + vo);
			
			ReplyDisLikeVO replyDislikeVO = vo.getReplyDisLikeVO();
			
			boolean CheckResult = replyService.checkReplyDislikeButton(replyDislikeVO);//버튼 누름 여부 확인
			
			boolean returnVal = false;
			
			if(CheckResult == false){ 
				
				log.info("pushReplyDislikeButton..." );
				returnVal = replyService.pushReplyDislikeButton(vo);//댓글 싫어요 누르기
				 
			}else if(CheckResult == true){ 
				
				returnVal = replyService.pullReplyDislikeButton(vo);//댓글 싫어요 당기기(취소)
				log.info("pullReplyDislikeButton...");
			}
			
			log.info("returnVal: " + returnVal);
			
			return returnVal == true ? new ResponseEntity<>(replyService.getDislikeCount(replyDislikeVO.getReply_num()), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
		
}

