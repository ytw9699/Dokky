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
	import org.my.domain.reportVO;
	import org.my.service.BoardService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
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

	private BoardService service;
	
	@GetMapping("/list")
	public String list(Criteria cri, Model model) {
		
		log.info("/list: " + cri);
	
		if(cri.getOrder() == 0) {//최신순 이면
			model.addAttribute("list", service.getList(cri));
		}else {
			model.addAttribute("list", service.getListWithOrder(cri));//조회순,댓글순,좋아요순,기부순
		}
		
		int total = service.getTotalCount(cri);//total은 특정 게시판의 총 게시물수
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));//페이징
	
		return "board/list";
	}
	
	@GetMapping("/allList")
	public String allList(Criteria cri, Model model) {
		
		log.info("/allList: " + cri);
		
		if(cri.getOrder() == 0) {
			model.addAttribute("list", service.getAllList(cri));
		}else {
			model.addAttribute("list", service.getAllListWithOrder(cri));
		}
		
		int total = service.getAllTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	
		return "board/list";
	}
	
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER')")//관리자이거나, 일반 회원일경우 권한 가짐
	@GetMapping("/register")
	public String register(@ModelAttribute("category") int category) {//게시글 등록 폼
		
		return "board/register";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER')")
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {//게시글 등록

		log.info("/register: " + board);
		
		/*if (board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}*/
		
		service.register(board);

	   //rttr.addFlashAttribute("result", board.getNum());
		 rttr.addAttribute("num", board.getNum());
		 rttr.addAttribute("category", board.getCategory());

		return "redirect:/board/get";
	}
	
	@GetMapping("/get")
	public void get(@RequestParam("num") Long num, @ModelAttribute("cri") Criteria cri, Model model) {

		log.info("/get");
		model.addAttribute("board", service.get(num)); //조회수증가 + 한줄 글 상세 데이터 가져오기
	}
	
	@GetMapping("/modify")
	public void getModifyForm(@RequestParam("num") Long num, @ModelAttribute("cri") Criteria cri, Model model) {

		log.info("/modify");
		model.addAttribute("board", service.getModifyForm(num));//수정폼+데이터 가져오기
	}
	
	 @PreAuthorize("principal.username == #board.userId")
	 @PostMapping("/modify")
	 public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
		 
		 log.info("/modify BoardVO:" + board);
		 log.info("/modify Criteria:" + cri);
		
		 /*if (service.modify(board)) { 
		 rttr.addFlashAttribute("result", "success");
		 }*/
		 service.modify(board);
		 
		 rttr.addAttribute("pageNum", cri.getPageNum());
		 rttr.addAttribute("amount", cri.getAmount());
		 rttr.addAttribute("type", cri.getType());
		 rttr.addAttribute("keyword", cri.getKeyword());
		 rttr.addAttribute("category", cri.getCategory());
		 rttr.addAttribute("num", board.getNum());
		 
	 return "redirect:/board/get";
	 }

	 @PreAuthorize("principal.username == #userId")   
	 @PostMapping("/remove")//삭제시 글+댓글+첨부파일 모두 삭제
		public String remove(@RequestParam("num") Long num, @RequestParam("userId")String userId, Criteria cri, RedirectAttributes rttr) {

		 	log.info("/remove..." + num);

			List<BoardAttachVO> attachList = service.getAttachList(num);

			if (service.remove(num)) { 
				deleteFiles(attachList); //첨부파일 모두 삭제
				rttr.addFlashAttribute("result", "success");
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
		 		
		 		Long num = Long.parseLong(arrIdx[i]); 
		 		
		 		if (service.remove(num)) {
		 			
		 			log.info("remove...num=" + num);
					
		 			List<BoardAttachVO> attachList = service.getAttachList(num);
		 			
		 			log.info("deleteFiles...attachList");
		 			
					deleteFiles(attachList);
				}
		 	}
			return "redirect:/mypage/myBoardList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
		}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
		value = "/likeCount", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> updateLike(@RequestBody commonVO vo) {//좋아요 누르기 및 취소
		
		log.info("/likeCount");
		log.info("commonVO: " + vo);
		
		BoardLikeVO boardLikeVO = vo.getBoardLikeVO();
		
		String CheckResult = service.checkLikeValue(boardLikeVO);
		
		log.info("CheckResult: " + CheckResult);//좋아요가 눌러져있는지 아닌지 체
		
		int returnVal = 0;
		
		if(CheckResult == null){ 
			returnVal = service.registerLike(vo);
			log.info("registerLike..." );
			
		}else if(CheckResult.equals("pull")){
			returnVal = service.pushLike(vo);//좋아요 누르기
			log.info("pushLike...");
			
		}else if(CheckResult.equals("push")){
			returnVal = service.pullLike(vo);//좋아요 취소
			log.info("pullLike...");
		}
		
		log.info("returnVal: " + returnVal);
		
		return returnVal == 1 ? new ResponseEntity<>(service.getLikeCount(boardLikeVO.getNum()), HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/dislikeCount", consumes = "application/json", produces ="text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateDisLike(@RequestBody commonVO vo) {//싫어요 누르기 및 취소
		
			log.info("/dislikeCount");
			log.info("vo: " +vo);
			
			BoardDisLikeVO boardDisLikeVO = vo.getBoardDisLikeVO();
		
			String CheckResult = service.checkDisLikeValue(boardDisLikeVO);
			
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
			
			return returnVal == 1 ? new ResponseEntity<>(service.getDisLikeCount(boardDisLikeVO.getNum()), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	@GetMapping(value = "/usercash/{username}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> usermoney(@PathVariable("username") String username) {
		 
		log.info("/usercash");
		log.info("username...="+username);
		
		String userCash = service.getuserCash(username);
				
		log.info("userCash...="+userCash); 
		
		return new ResponseEntity<>(userCash, HttpStatus.OK);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/donateMoney", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> donateMoney(@RequestBody commonVO vo) {//기부하기
			
			log.info("/donateMoney");
			log.info("commonVO: " + vo);
			
			String BoardMoney = service.donateMoney(vo);
			
			return new ResponseEntity<>(BoardMoney, HttpStatus.OK);
		}
	
	@PostMapping(value = "/report", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> report(@RequestBody reportVO vo) {
		
		log.info("/report");
		
		if(service.insertReportdata(vo)) {
			
			log.info("insertReportdata...success "+vo);
			return new ResponseEntity<>("success", HttpStatus.OK);
			
		}else{
			log.info("insertChargeData...fail "+vo);
			return new ResponseEntity<>("fail", HttpStatus.OK);
		}
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long num) {
	
		log.info("/getAttachList " + num);

		return new ResponseEntity<>(service.getAttachList(num), HttpStatus.OK);
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
	
}
