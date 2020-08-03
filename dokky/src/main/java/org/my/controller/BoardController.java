package org.my.controller;
	import java.nio.file.Files;
	import java.nio.file.Path;
	import java.nio.file.Paths;
	import java.util.List;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardDisLikeVO;
	import org.my.domain.BoardLikeVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.domain.commonVO;
	import org.my.security.domain.CustomUser;
	import org.my.service.BoardService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.core.Authentication;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.DeleteMapping;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.ModelAttribute;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	private BoardService boardService;
	
	@GetMapping("/list")
	public String getList(Criteria cri, Model model) {
		
		log.info("/board/list: " + cri);
	
		if(cri.getOrder() == 0) {//최신순 이면
			
			model.addAttribute("list", boardService.getList(cri));
			
		}else { //조회순,댓글순,좋아요순,기부순 이면
			
			model.addAttribute("list", boardService.getListWithOrder(cri));
		}
		
		int total = boardService.getTotalCount(cri);//total은 특정 게시판의 총 게시물수
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));//페이징
	
		return "board/list";
	}
	
	@GetMapping("/allList")
	public String getAllList(Criteria cri, Model model) {
		
		log.info("/board/allList: " + cri);
		
		if(cri.getOrder() == 0) {
			
			model.addAttribute("list", boardService.getAllList(cri));
			
		}else {
			
			model.addAttribute("list", boardService.getAllListWithOrder(cri));
		}
		
		int total = boardService.getAllTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	
		return "board/list";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@GetMapping("/registerForm")
	public String getRegisterForm(@ModelAttribute("category") int category){

		log.info("/board/registerForm");
		
		return "board/register";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@PostMapping("/register")
	public String registerBoard(BoardVO board, RedirectAttributes rttr) {

		log.info("/board/register: " + board);
		
		/*if (board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}*/
		
		boardService.register(board);

		rttr.addAttribute("board_num", board.getBoard_num());//생성된 board_num값을 넘겨받음
		rttr.addAttribute("category", board.getCategory());

		return "redirect:/board/get";
	}
	
	@GetMapping("/get")
	public String getBoard(@RequestParam("board_num") Long board_num, 
						   @ModelAttribute("cri") Criteria cri, Model model, Authentication authentication) {
		
		log.info("/board/get");
		
		if(authentication != null) {
			
			CustomUser user = (CustomUser)authentication.getPrincipal();
			
			String userId = user.getUsername();
			
			model.addAttribute("scrapCount", boardService.getScrapCnt(board_num, userId));
		}
		
		BoardVO board = boardService.getBoard(board_num, true);//조회수증가 + 한줄 글 상세 데이터 가져오기
		
		if(board == null) {
			
			log.info("/getBoardError");
			
			model.addAttribute("msg", "글이 삭제되었습니다.");
			
			return "error/accessError";
		}   
		
		model.addAttribute("board", board); 
		model.addAttribute("previousCategory", cri.getCategory());//조회 하기전 카테고리 값 넘기기
		
		return "board/get";
	}
	
	@PreAuthorize("principal.username == #cri.userId")
	@GetMapping("/modifyForm")
	public String getModifyForm(@RequestParam("board_num") Long board_num, 
							  @ModelAttribute("cri") Criteria cri, Model model){

		log.info("/modifyForm");
		
		model.addAttribute("board", boardService.getBoard(board_num, false));
		
		return "board/modify";
	}
	
	@PreAuthorize("principal.username == #board.userId")
	@PostMapping("/modify")
	public String modifyBoard(BoardVO board, Criteria cri, RedirectAttributes rttr, Model model) {
		 
		 log.info("/modifyBoard BoardVO:" + board);
		 log.info("/modifyBoard Criteria:" + cri);
		
		 Boolean result = boardService.modifyBoard(board);
		 
		 if(!result) {
				
				log.info("/error/accessError");
				
				model.addAttribute("msg", "글을 수정 할 수 없습니다.");
				
				return "error/commonError";
		 }   
		 
		 rttr.addAttribute("pageNum", cri.getPageNum());
		 rttr.addAttribute("amount", cri.getAmount());
		 rttr.addAttribute("type", cri.getType());
		 rttr.addAttribute("keyword", cri.getKeyword());
		 rttr.addAttribute("category", cri.getCategory());
		 rttr.addAttribute("board_num", board.getBoard_num());
		 
		 return "redirect:/board/get";
	}

	@PreAuthorize("principal.username == #userId")   
	@PostMapping("/remove")//삭제시 글+댓글+첨부파일 모두 삭제
	public String removeBoard(@RequestParam("board_num") Long board_num,
						 	  @RequestParam("userId")String userId, boolean hasFile, Criteria cri, RedirectAttributes rttr) {

		 	log.info("/remove..." + board_num);
		 	
		 	log.info("/hasFile..." + hasFile);
		 	
			if(boardService.removeBoard(board_num, hasFile) && hasFile){//첨부파일 디비 삭제 + 글삭제
				
				//List<BoardAttachVO> attachList = boardService.getAttachList(board_num);
				
				//deleteFiles(attachList); //실제 첨부파일 모두 삭제
			}
			
			return "redirect:/board/list" + cri.getListLink();
	}
	 
	 @PreAuthorize("principal.username == #userId")   
	 @PostMapping("/removeAll")//다중삭제
		public String removeAll(@RequestParam("checkRow") String checkRow , @RequestParam("userId")String userId, Criteria cri) {
		 	
		 	log.info("/removeAll...");
		 
		 	log.info("checkRow..." + checkRow);
		 	
		 	String[] arrIdx = checkRow.split(",");
		 	
		 	for (int i=0; i<arrIdx.length; i++) {
		 		
		 		Long board_num = Long.parseLong(arrIdx[i]); 
		 		
		 		if (boardService.removeBoard(board_num, true)) {
		 			
		 			log.info("remove...board_num=" + board_num);
					
		 			List<BoardAttachVO> attachList = boardService.getAttachList(board_num);
		 			
		 			log.info("deleteFiles...attachList");
		 			
					deleteFiles(attachList);
				}
		 	}
			return "redirect:/mypage/myBoardList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
		}
	
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH },
		value = "/likeCount", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> updateLike(@RequestBody commonVO vo) {//게시글 좋아요 누르기 및 취소
		
		log.info("/likeCount");
		log.info("commonVO: " + vo);
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		String CheckResult = boardService.checkLikeValue(boardLikeVO);
		
		log.info("CheckResult: " + CheckResult);//좋아요가 눌러져 있는지 아닌지 체크
		
		int returnVal = 0;
		
		if(CheckResult == null){ 
			returnVal = boardService.registerLike(vo);//좋아요 첫 셋팅
			log.info("registerLike..." );
			
		}else if(CheckResult.equals("pull")){
			returnVal = boardService.pushLike(vo);//좋아요 누르기
			log.info("pushLike...");
			
		}else if(CheckResult.equals("push")){
			returnVal = boardService.pullLike(vo);//좋아요 취소
			log.info("pullLike...");
		}
		
		log.info("returnVal: " + returnVal);
		
		return returnVal == 1 ? new ResponseEntity<>(boardService.getLikeCount(boardLikeVO.getBoard_num()), HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/dislikeCount", consumes = "application/json", produces ="text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateDisLike(@RequestBody commonVO vo) {//게시글 싫어요 누르기 및 취소
		
			log.info("/dislikeCount");
			log.info("vo: " +vo);
			
			BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
			String CheckResult = boardService.checkDisLikeValue(boardDisLikeVO);
			
			log.info("CheckResult: " + CheckResult);
			
			int returnVal = 0;
			 
			if(CheckResult == null){ 
				returnVal = boardService.registerDisLike(vo);
				log.info("registerDisLike..." );
				
			}else if(CheckResult.equals("pull")){
				
				returnVal = boardService.pushDisLike(vo);//싫어요 누르기
				log.info("pushDisLike...");
				
			}else if(CheckResult.equals("push")){
				returnVal = boardService.pullDisLike(vo); //싫어요 취소
				log.info("pullDisLike...");
			}
			
			log.info("returnVal: " + returnVal);
			
			return returnVal == 1 ? new ResponseEntity<>(boardService.getDisLikeCount(boardDisLikeVO.getBoard_num()), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	@GetMapping(value = "/usercash/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> userCash(@PathVariable("userId") String userId) {
		 
		log.info("/usercash");
		log.info("userId...="+userId);
		
		String userCash = boardService.getuserCash(userId);
				
		log.info("userCash...="+userCash); 
		
		return new ResponseEntity<>(userCash, HttpStatus.OK);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/donateMoney", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> donateMoney(@RequestBody commonVO vo) {//기부하기
			
			log.info("/donateMoney");
			log.info("commonVO: " + vo);
			
			String BoardMoney = boardService.donateMoney(vo);
			
			return new ResponseEntity<>(BoardMoney, HttpStatus.OK);
		}
	
	@PostMapping(value = "/report", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> report(@RequestBody commonVO vo) {//신고
		
		log.info("/report");
		
		if(boardService.insertReportdata(vo)) {
			
			log.info("insertReportdata...success "+vo);
			return new ResponseEntity<>("success", HttpStatus.OK);
			
		}else{
			log.info("insertChargeData...fail "+vo);
			return new ResponseEntity<>("fail", HttpStatus.OK);
		}
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long board_num) {
	
		log.info("/getAttachList " + board_num);

		return new ResponseEntity<>(boardService.getAttachList(board_num), HttpStatus.OK);
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
	    
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files........");
	    log.info(attachList);
	    
	    attachList.forEach(attach -> {
	      try {        
	        Path file  = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());
	        
	        Files.deleteIfExists(file);
	        
	        if(Files.probeContentType(file).startsWith("image")) {
	        
	          Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
	          
	          Files.delete(thumbNail);
	        }
	
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }//end catch
	    });//end foreach
	  }
	
	@PreAuthorize("principal.username == #userId")  
	@PostMapping(value = "/scrapData/{board_num}/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> postScrapData(@PathVariable("board_num") int board_num, @PathVariable("userId") String userId ) {
		
		log.info("/scrapData");
		
		log.info("board_num="+board_num+", userId="+userId); 
		
		if(boardService.insertScrapData(board_num, userId)) {//스크랩 등록
			
				log.info("insertScrapData...board_num="+board_num+", userId="+userId);
				
				return new ResponseEntity<>("success",HttpStatus.OK);
			
		}else {
		
				return new ResponseEntity<>("fail",HttpStatus.OK);
		}
	}
	
	@PreAuthorize("principal.username == #userId")  
	@DeleteMapping(value = "/scrapData/{board_num}/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> deleteScrapData(@PathVariable("board_num") int board_num, @PathVariable("userId") String userId ) {
		
		log.info("/scrapData");
		
		log.info("board_num="+board_num+", userId="+userId); 
		
		if(boardService.deleteScrapData(board_num, userId) == 1) {
			
				log.info("insertScrapData...board_num="+board_num+", userId="+userId);
				
				return new ResponseEntity<>("success",HttpStatus.OK);
			
		}else {
		
				return new ResponseEntity<>("fail",HttpStatus.OK);
		}
	}
}
