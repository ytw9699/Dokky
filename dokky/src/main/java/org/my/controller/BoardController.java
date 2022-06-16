/*
- 마지막 업데이트 2022-06-16
*/
package org.my.controller;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import org.my.domain.BoardAttachVO;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.domain.CommonVO;
	import org.my.domain.ReportVO;
	import org.my.security.domain.CustomUser;
	import org.my.service.BoardService;
	import org.my.service.ReplyService;
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
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@RequiredArgsConstructor
public class BoardController {

	private final BoardService boardService;
	private final ReplyService replyService;
	
	@GetMapping("/list")
	public String getList(Criteria cri, Model model) {
		
		log.info("/board/list: " + cri);
	
		if(cri.getOrder() == 0) {//최신순 이면
			
			model.addAttribute("list", boardService.getList(cri));
			
		}else { //조회순,댓글순,좋아요순,기부순 이면
			
			model.addAttribute("list", boardService.getListWithOrder(cri));
		}
		
		int total = boardService.getTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	
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
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping("/registerForm")
	public String getRegisterForm(@ModelAttribute("category") int category){

		log.info("/board/registerForm");
		
		return "board/registerForm";
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping("/register")
	public String registerBoard(BoardVO board, RedirectAttributes rttr) {

		log.info("/board/register: " + board);
		
		boardService.register(board);

		rttr.addAttribute("board_num", board.getBoard_num());//생성된 board_num값을 넘겨받음
		rttr.addAttribute("category", board.getCategory());

		return "redirect:/board/get";
	}
	
	@GetMapping("/get")
	public String getBoard(@RequestParam("board_num") Long board_num, @RequestParam(value = "reply_num", required = false) Long reply_num,
						   @ModelAttribute("cri") Criteria cri, Model model, Authentication authentication) {
		
			log.info("/board/get");
			
			if(authentication != null) {
				
				CustomUser user = (CustomUser)authentication.getPrincipal();
				
				String userId = user.getUsername();
				
				model.addAttribute("scrapCount", boardService.getScrapCnt(board_num, userId));
			}
			
			BoardVO board = boardService.getBoard(board_num, true);
			
			if(board == null) {
				
				log.info("/getBoardError");
				
				model.addAttribute("message", "해당하는 글이 없습니다.");
				
				return "error/commonError"; 
			}   
			
			if(reply_num != null) {
				
				model.addAttribute("reply_num", reply_num); 
				
				model.addAttribute("reply_pageNum", replyService.getReplyPageNum(board_num, reply_num));
			}  
			
			model.addAttribute("board", board); 
			model.addAttribute("previousCategory", cri.getCategory());//조회 하기전 카테고리 값 넘기기
			
			return "board/get";
	}
	
	@PreAuthorize("hasRole('ROLE_USER') and principal.username == #cri.userId")
	@GetMapping("/modifyForm")
	public String getModifyForm(@RequestParam("board_num") Long board_num, 
							  @ModelAttribute("cri") Criteria cri, Model model){
		
		log.info("/board/modifyForm");
		
		model.addAttribute("board", boardService.getBoard(board_num, false));
		
		return "board/modifyForm";
	}
	
	@PreAuthorize("hasRole('ROLE_USER') and principal.username == #board.userId")
	@PostMapping("/modify")
	public String modifyBoard(BoardVO board, Criteria cri, RedirectAttributes rttr, Model model) {
		 
		 log.info("/board/modify BoardVO :" + board);
		 log.info("/board/modify Criteria :" + cri);
		
		 Boolean result = boardService.modifyBoard(board);
		 
		 if(!result) {
				
				log.info("/error/commonError");
				
				model.addAttribute("message", "글을 수정 할 수 없습니다.");
				
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
	@PostMapping("/remove")//해당하는 게시글의 번호의 글과+댓글+첨부파일 모두 삭제한다. (ON DELETE CASCADE 옵션)
	public String removeBoard(@RequestParam("board_num") Long board_num, @RequestParam("userId")String userId, 
								HttpServletRequest request, Model model, Criteria cri) {
		
			log.info("/board/remove");
		 	log.info("/getAttachList..." + board_num);
		 	
		 	boolean result = boardService.removeBoard(board_num, request);
		 	
		 	if(result == true) {
		 		
		 		return "redirect:/board/list" + cri.getListLink();
		 		
		 	}else{
		 		
		 		model.addAttribute("message", "서버에러로 삭제할 수 없습니다.");
				
				return "error/commonError";  
		 	}
	}
	
	@PreAuthorize("principal.username == #userId")   
	@PostMapping("/removeBoards")//게시글 연관 된 모든것 다중 삭제  (ON DELETE CASCADE 옵션)
	public String removeBoards(@RequestParam("checkRow") String checkRow , @RequestParam("userId")String userId, 
									HttpServletRequest request, Model model, Criteria cri){
		 	
			log.info("/board/removeBoards");
		 	
		 	boolean result = false;
		 			result = boardService.removeBoards(checkRow, request);//checkRow는 게시글 번호들의 묶음이다.
		 	
		 	if(result == true) {
		 		
		 		return "redirect:/mypage/myBoardList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
		 		
		 	}else {
		 		
		 		model.addAttribute("message", "서버에러로 삭제할 수 없습니다.");
				
				return "error/commonError";  
		 	}
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping(value = "/likeBoard", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> likeBoard(@RequestBody CommonVO vo) {//게시글 좋아요 누르기 및 취소
		
		log.info("/board/likeBoard");
		log.info("vo: " +vo);
		
		String likeCount = boardService.likeBoard(vo);
		
		return likeCount != null ? new ResponseEntity<>(likeCount, HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@PostMapping(value = "/disLikeBoard", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> disLikeBoard(@RequestBody CommonVO vo) {//게시글 싫어요 누르기 및 취소
		
		log.info("/board/disLikeBoard");
		log.info("vo: " +vo);
		
		String disLikeCount = boardService.disLikeBoard(vo);
		
		return disLikeCount != null ? new ResponseEntity<>(disLikeCount, HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #userId")  
	@GetMapping(value = "/myCash/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getMyCash(@PathVariable("userId") String userId) {
		 
		log.info("/board/myCash");
		
		String userCash = boardService.getMyCash(userId);
				
		return userCash != null
			? new ResponseEntity<>(userCash, HttpStatus.OK)
			: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	} 
	
	@PreAuthorize("principal.username == #vo.DonateVO.userId")
	@PostMapping(value = "/giveBoardWriterMoney", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> giveBoardWriterMoney(@RequestBody CommonVO vo){
		
		log.info("/board/giveBoardWriterMoney");
		log.info("CommonVO: " + vo);
		
		String BoardMoney = boardService.giveBoardWriterMoney(vo);
		
		if(BoardMoney != null) {
			
			return new ResponseEntity<>(BoardMoney, HttpStatus.OK); 
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PreAuthorize("principal.username == #vo.reportingId")
	@PostMapping(value = "/report", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> report(@RequestBody ReportVO vo) {//게시글 or 댓글 신고
		
		log.info("/board/report");
		
		log.info("createReportdata..."+vo);
		
		if(boardService.createReportdata(vo)){
			
			return new ResponseEntity<>(HttpStatus.OK);
			
		}else{
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@GetMapping(value = "/attachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long board_num) {
	
		log.info("/board/attachList :" + board_num);
									
		return new ResponseEntity<>(boardService.getAttachList(board_num), HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #userId")  
	@PostMapping(value = "/scrapData/{board_num}/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> postScrapData(@PathVariable("board_num") int board_num, @PathVariable("userId") String userId ) {
		
		log.info("/board/scrapData");
		
		if(boardService.postScrapData(board_num, userId) == 1) {
				
				return new ResponseEntity<>(HttpStatus.OK);
			
		}else {
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PreAuthorize("principal.username == #userId")  
	@DeleteMapping(value = "/scrapData/{board_num}/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> deleteScrapData(@PathVariable("board_num") int board_num, @PathVariable("userId") String userId ) {
		
		log.info("/board/scrapData");
		
		if(boardService.deleteScrapData(board_num, userId) == 1) {
			
				return new ResponseEntity<>("success",HttpStatus.OK);
			
		}else {
				return new ResponseEntity<>("fail",HttpStatus.OK);
		}
	}
}
