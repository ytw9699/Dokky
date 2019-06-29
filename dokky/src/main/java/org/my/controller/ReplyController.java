package org.my.controller;
	import org.my.domain.BoardDisLikeVO;
import org.my.domain.Criteria;
import org.my.domain.ReplyDisLikeVO;
import org.my.domain.ReplyLikeVO;
	import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;
	import org.my.service.ReplyService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.web.bind.annotation.DeleteMapping;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.bind.annotation.RestController;
	import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service;//@AllArgsConstructor로 주입,스프링4.3이상
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {

		log.info("ReplyVO: " + vo);

		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT: " + insertCount);

		return insertCount == 1  
				?  new ResponseEntity<>("댓글이 입력되었습니다.", HttpStatus.OK) 
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@GetMapping(value = "/pages/{num}/{page}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("num") Long num) {

		Criteria cri = new Criteria(page, 10);//댓글을 10개씩 보여줌 
		
		log.info("get Reply List num: " + num);
  
		log.info("cri:" + cri);

		return new ResponseEntity<>(service.getListPage(cri, num), HttpStatus.OK);
	}
	
	/*@DeleteMapping(value = "/{reply_num}", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> remove(@PathVariable("reply_num") Long reply_num) {

		log.info("remove: " + reply_num);

		return service.remove(reply_num) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}*/
	@PreAuthorize("principal.username == #vo.userId")
	@DeleteMapping(value = "/{reply_num}", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("reply_num") Long reply_num) {
			
		log.info("remove: " + reply_num); 
		
		return service.remove(reply_num) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #vo.userId")
	@RequestMapping(method = { RequestMethod.PUT,
			RequestMethod.PATCH }, value = "/{reply_num}", consumes = "application/json", produces = {
					MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> modify(
			 @RequestBody ReplyVO vo, 
			 @PathVariable("reply_num") Long reply_num) {

		vo.setReply_num(reply_num);

		log.info("reply_num: " + reply_num);
		log.info("modify: " + vo);

		return service.modify(vo) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	@GetMapping(value = "/{reply_num}", 
			produces = { MediaType.APPLICATION_XML_VALUE, 
					     MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("reply_num") Long reply_num) {

		log.info("get: " + reply_num);

		return new ResponseEntity<>(service.get(reply_num), HttpStatus.OK);
	}
	
	/*@GetMapping(value = "/mytest/{reply_num}", //테스트..
			produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> test(@PathVariable("reply_num") Long reply_num) {

		return new ResponseEntity<>(service.get(reply_num), HttpStatus.OK);
	}*/


//	 @GetMapping(value = "/pages/{num}/{page}", 
//			 produces = {
//					 MediaType.APPLICATION_XML_VALUE,
//					 MediaType.APPLICATION_JSON_UTF8_VALUE })
//	 public ResponseEntity<List<ReplyVO>> getList(
//			 @PathVariable("page") int page,
//			 @PathVariable("num") Long num) {
//	
//		 
//		 log.info("getList.................");
//		 Criteria cri = new Criteria(page,10);
//		 log.info(cri);
//	
//	 return new ResponseEntity<>(service.getList(cri, num), HttpStatus.OK);
//	 }
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/likeCount", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateLike(@RequestBody ReplyLikeVO vo) {//댓글 좋아요 누르기 및 취소

			log.info("userId: " + vo.getUserId());
			log.info("reply_num: " + vo.getReply_num());
			
			String CheckResult = service.checkLikeValue(vo);
			
			log.info("CheckResult: " + CheckResult);
			
			int returnVal = 0;
			
			if(CheckResult == null){ 
				returnVal = service.registerLike(vo);
				log.info("registerLike..." );
				 
			}else if(CheckResult.equals("pull")){
				returnVal = service.pushLike(vo);//댓글 좋아요 누르기
				log.info("pushLike...");
				
			}else if(CheckResult.equals("push")){
				returnVal = service.pullLike(vo);//댓글 좋아요 취소
				log.info("pullLike...");
			}
			
			log.info("returnVal: " + returnVal);
			
			return returnVal == 1 ? new ResponseEntity<>(service.getLikeCount(vo.getReply_num()), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/dislikeCount", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateDisLike(@RequestBody ReplyDisLikeVO vo) {//싫어요 누르기 및 취소

			log.info("userId: " + vo.getUserId());
			log.info("num: " + vo.getReply_num());
			
			String CheckResult = service.checkDisLikeValue(vo);
			 
			log.info("CheckResult: " + CheckResult);
			
			int returnVal = 0;
			 
			if(CheckResult == null){ 
				returnVal = service.registerDisLike(vo);
				log.info("registerDisLike..." );
				
			}else if(CheckResult.equals("pull")){
				
				returnVal = service.pushDisLike(vo);//싫어요 누르기
				log.info("pushDisLike...");
				
			}else if(CheckResult.equals("push")){
				returnVal = service.pullDisLike(vo); //싫어요 취소
				log.info("pullDisLike...");
			}
			
			log.info("returnVal: " + returnVal);
			
			return returnVal == 1 ? new ResponseEntity<>(service.getDisLikeCount(vo.getReply_num()), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
}

