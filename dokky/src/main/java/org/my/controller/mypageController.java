package org.my.controller;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.PageDTO;
	import org.my.domain.cashVO;
	import org.my.domain.checkVO;
	import org.my.service.BoardService;
	import org.my.service.MypageService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import lombok.AllArgsConstructor;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	
@Controller
@Log4j
@RequestMapping("/mypage/*")
@AllArgsConstructor
public class mypageController {
	
	@Setter(onMethod_ = @Autowired)
	private MypageService service;
	
	@Setter(onMethod_ = @Autowired)
	private BoardService boardService;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/myInfoForm")  
	public String myInfoForm(@RequestParam("userId") String userId, Model model) { //내 개인정보 변경폼
		
		model.addAttribute("myInfo", service.getMyInfo(userId));
		
		log.info("myInfoForm");
		
		return "mypage/myInfoForm";
	} 
	
	@PreAuthorize("principal.username == #vo.userId")
	@PostMapping("/myInfo")
	public String updateMyInfo(MemberVO vo, Model model) {//개인정보 변경하기
		
		if(service.updateMyInfo(vo)) {
			log.info("updateMyInfo-complete");
			
			model.addAttribute("myInfo", service.getMyInfo(vo.getUserId()));
			model.addAttribute("update", "complete");
			
		}else {
			log.info("updateMyInfo-notComplete");
			model.addAttribute("update", "notComplete");
		}
			return "mypage/myInfoForm";
	}
	
	@PreAuthorize("isAuthenticated()") 
	@PostMapping(value = "/checkPassword", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> checkPassword(@RequestBody checkVO vo) {//나의 패스워드 체크
		
		log.info("userId...="+vo.getUserId());
		log.info("getUserPw...="+vo.getUserPw());
		
		String getPw = service.getMemberPW(vo.getUserId());
		
		if(!pwencoder.matches(vo.getUserPw(), getPw)) {//비밀번호 일치하지 않는다면
	        	
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);//404
	    }
			return new ResponseEntity<>("success",HttpStatus.OK);//200
	}
	
	@PreAuthorize("isAuthenticated()") 
 	@GetMapping("/rePasswordForm")  
	public String rePasswordForm(@RequestParam("userId") String userId, Model model) { //내 패스워드 변경폼
		
		log.info("rePasswordForm");
		
		return "mypage/rePasswordForm";
	}
	
	@PreAuthorize("isAuthenticated()") 
	@PostMapping("/MyPassword")
	public String updateMyPassword(@RequestParam("userId") String userId, @RequestParam("newPw") String newPw , Model model) {//패스워드 변경
		
		log.info("updateMyPassword");

		String userPw = pwencoder.encode(newPw);//패스워드 암호화
		
		if(service.updateMyPassword(userId,userPw)) {
			log.info("updateMyPassword-complete");
			model.addAttribute("update", "complete");
			
		}else {
			log.info("updateMyPassword-notComplete");
			model.addAttribute("update", "notComplete");
		}
			return "mypage/rePasswordForm";
	}
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/myBoardList") 
	public String myBoardList(Criteria cri, Model model) { //내 게시글 가져오기
		
		model.addAttribute("MyBoard", service.getMyBoardList(cri));
		
		log.info("myBoardList");
		
		int total = service.getMyBoardCount(cri);//total은 내 게시판의 총 게시물수
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
		return "mypage/myBoardList";
	} 
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/myReplylist")  
	public String myReplylist(Criteria cri, Model model) {
		
		log.info("myReplylist "+cri);
		
		model.addAttribute("myReply", service.getMyReplylist(cri));
		
		log.info("getMyReplyCount");
		
		int total = service.getMyReplyCount(cri);//total은 내 댓글의 총 게시물수
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total)); 
		model.addAttribute("total", total);
		
		return "mypage/myReplylist";
	} 
	
	@PostMapping(value = "/scrapData/{num}/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> insertScrapData(@PathVariable("num") int num, @PathVariable("userId") String userId ) {
		
		log.info("getScrapCnt...num="+num+", userId="+userId);
		
		if(service.getScrapCnt(num,userId) == 1 && service.deleteScrap(num,userId) == 1) {//스크랩을 이미 했다면, 스크랩 삭제
		
			return new ResponseEntity<>("cancel",HttpStatus.OK);
		}
		
		log.info("insertScrapData...num="+num+", userId="+userId);
		
		if(service.insertScrapData(num,userId)) {
			
			return new ResponseEntity<>("success",HttpStatus.OK);
		}
		return new ResponseEntity<>("fail",HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/myScraplist")  
	public String myScraplist(Criteria cri, Model model) { //내 스크랩 글 가져오기
		
		log.info("getMyScrapCount");
		
		int total = service.getMyScrapCount(cri.getUserId());//total은 내 스크랩 총 게시물수
		
		log.info("myScraplist "+cri);
		
		model.addAttribute("myScraplist", service.getMyScraplist(cri));
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
		return "mypage/myScraplist";
	} 
	
	 @PreAuthorize("principal.username == #userId")  
	 @PostMapping("/removeAllScrap")//다중삭제
		public String removeAllScrap(@RequestParam("checkRow") String checkRow , @RequestParam("userId")String userId, Criteria cri) {

		log.info("checkRow..." + checkRow);
	 	
	 	String[] arrIdx = checkRow.split(",");
	 	
	 	for (int i=0; i<arrIdx.length; i++) {
	 		
	 		Long scrap_num = Long.parseLong(arrIdx[i]);  
	 		
	 		log.info("remove...reply_num=" + scrap_num);
	 		
	 		service.removeAllScrap(scrap_num);
	 	}
	 return "redirect:/mypage/myScraplist?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
	}
	
	@PreAuthorize("isAuthenticated()") 
 	@GetMapping("/myCashInfo")  
	public String myCashInfo(@RequestParam("userId") String userId, Model model) { //내 캐시정보
		
		log.info("myCashInfo");
		
		String userCash = boardService.getuserCash(userId);
		
		log.info("getuserCash...="+userCash);
		
		model.addAttribute("userCash", userCash);
		
		return "mypage/myCashInfo";
	}
	
	@PostMapping(value = "/chargeData", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> chargeData(@RequestBody cashVO vo) {//캐시 충전하기
		
		if(service.insertChargeData(vo)) {
			
			log.info("insertChargeData...success "+vo);
			
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			log.info("insertChargeData...fail "+vo);
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@PostMapping(value = "/reChargeData", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> reChargeData(@RequestBody cashVO vo) {//캐시 환전하기
		
		if(service.insertReChargeData(vo)) {
			
			log.info("insertReChargeData...success "+vo);
			
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			log.info("insertReChargeData...fail "+vo);
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()") 
 	@GetMapping("/myCashHistory")  
	public String myCashHistory(Criteria cri, Model model) { //내 캐시 내역
		
		log.info("getMyCashHistoryCount");
		
		int total = service.getMyCashHistoryCount(cri.getUserId());//total은 내 스크랩 총 게시물수
		
		log.info("myCashHistory");
		
		model.addAttribute("myCashHistory", service.getMyCashHistory(cri));
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "mypage/myCashHistory"; 
	}
	
}