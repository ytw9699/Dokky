package org.my.controller;
	import java.io.UnsupportedEncodingException;
	import java.util.Locale;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.PageDTO;
	import org.my.domain.cashVO;
	import org.my.domain.noteVO;
	import org.my.service.CommonService;
	import org.my.service.MemberService;
	import org.my.service.MypageService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.PutMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j 
public class CommonController {
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
	
	@Setter(onMethod_ = @Autowired)
	private MemberService memberService;
	
	@Setter(onMethod_ = @Autowired)
	private MypageService mypageService;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String main(Model model) {
		
		log.info("/main");
		
		model.addAttribute("realtimeList", memberService.getRealtimeList());//실시간 게시글
		
		model.addAttribute("monthlyList", memberService.getMonthlyList());//한달 인길글
		
		model.addAttribute("donationList", memberService.getDonationList());//한달 최다 기부글
		
		return "common/main";
	}
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		model.addAttribute("realtimeList", memberService.getRealtimeList());
		
		model.addAttribute("monthlyList", memberService.getMonthlyList());
		
		model.addAttribute("donationList", memberService.getDonationList());
		
		return "common/main";
	}
	
	@GetMapping("/adminError")
	public String adminError(Model model) {

		log.info("/adminError");
		
		model.addAttribute("msg", "관리자만 접근 가능합니다.");
		
		return "error/accessError";  
	}

	@GetMapping("/accessError")
	public String accessDenied(Authentication auth, Model model) {//Authentication 타입의 파라미터를 받도록 설계해서 필요한 경우에 사용자의 정보를 확인할 수 있도록
		
		log.info("/accessError");
		
		log.info("access Denied : " + auth); 
 
		model.addAttribute("msg", "접근 권한이 없습니다.관리자에게 문의해주세요.");
		
		return "error/accessError";
	}   

	@GetMapping("/customLogin")
	public String loginInput(String error, String logout,String check, Model model) throws UnsupportedEncodingException {
		
		log.info("/customLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		if (error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}

		if (logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
		
		if (check != null) {
			if(check.equals("notId") ) {
				model.addAttribute("check", "아이디가 없습니다.");
			}else if(check.equals("notPassword") ) {
				model.addAttribute("check", "비밀번호가 틀립니다.");
			}
			else if(check.equals("limit") ) {
				model.addAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요.");
			}
		}
		return "common/customLogin";  
	}

	@PostMapping("/customLogout")
	public void logoutPost() {
		
		log.info("/customLogout");
	}
	
	@GetMapping("/memberForm")
	public String memberForm() {

		log.info("/memberForm");
		
		return "common/memberForm";
	}
	
	@PostMapping("/members") 
	public String postMembers(MemberVO vo, Model model) {//회원가입
		
		log.info("/members: vo" + vo); 
		
		vo.setUserPw(pwencoder.encode(vo.getUserPw()));//패스워드 암호화
		
		if(memberService.registerMembers(vo)){
			
			model.addAttribute("check", "가입완료 되었습니다 로그인해주세요.");
			
			return "common/customLogin";
		}
		
			model.addAttribute("check", "가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "common/customLogin"; 
	}
	
	@GetMapping(value = "/idCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getIdCheckedVal(String inputId) {
		
		log.info("/idCheckedVal"); 
		
		if(memberService.getIdCheckedVal(inputId)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	 
	@GetMapping(value = "/nickCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getNicknameCheckedVal(String inputNickname) {
		 
		log.info("/nickCheckedVal"); 
		
		if(memberService.getNicknameCheckedVal(inputNickname)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@GetMapping(value = "/emailCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getEmailCheckedVal(String inputEmail) {
		 
		log.info("/emailCheckedVal"); 
		
		if(memberService.getEmailCheckedVal(inputEmail)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userBoardList") 
	public String userBoardList(Criteria cri, Model model, String pageLocation) { //유저 게시글 가져오기
		
		log.info("/userBoardList"); 
		
		model.addAttribute("userBoard", mypageService.getMyBoardList(cri));
		
		int total = mypageService.getMyBoardCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("boardTotal",total);  
		model.addAttribute("replyTotal", mypageService.getMyReplyCount(cri));
		
		if(pageLocation == null) {
			return "common/userBoardList"; 
		}else if(pageLocation.equals("admin")) {
			return "admin/userBoardList";
		}  
			return "common/userBoardList";    
	} 
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userReplylist")  
	public String userReplylist(Criteria cri, Model model, String pageLocation) { 
		
		log.info("userReplylist cri"+cri);
		
		model.addAttribute("userReply", mypageService.getMyReplylist(cri));
		
		int total = mypageService.getMyReplyCount(cri);
		
		model.addAttribute("boardTotal",mypageService.getMyBoardCount(cri));  
		model.addAttribute("replyTotal", total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	 
		if(pageLocation == null) { 
			return "common/userReplylist"; 
		}else if(pageLocation.equals("admin")) {
			return "admin/userReplylist";
		}  
			return "common/userReplylist";    
	} 

	
	@GetMapping(value = "/alarmRealCount/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getAlarmRealCount(@PathVariable("userId") String userId) {
		 
		log.info("/alarmRealCount...="+userId);
		
		return  new ResponseEntity<>(commonService.getAlarmRealCount(userId), HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/alarmList")  
	 public String getAlarmList(Criteria cri, Model model) {//내 알림 리스트 가져오기
		
		log.info("/alarmList");
		
		int total = commonService.getAlarmCount(cri);
		
		model.addAttribute("total", total);
		
		model.addAttribute("alarmList", commonService.getAlarmList(cri));
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));

		return "common/alarmList";
	}
	
	@PreAuthorize("principal.username == #userId")   
	 @PostMapping("/removeAllAlarm")//다중알람삭제
		public String removeAllAlarm(@RequestParam("checkRow") String checkRow , @RequestParam("userId")String userId, Criteria cri) {
		 
			log.info("/removeAllAlarm");
		 	log.info("checkRow..." + checkRow);
		 	
		 	String[] arrIdx = checkRow.split(",");
		 	
		 	for (int i=0; i<arrIdx.length; i++) {
		 		
		 		Long alarmNum = Long.parseLong(arrIdx[i]); 
		 		
		 		if (commonService.deleteAllAlarm(alarmNum)) {
		 			log.info("delete...deleteAllAlarm=" + alarmNum);
				}
		 	}
			return "redirect:/alarmList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
		}
	
	
	@PreAuthorize("isAuthenticated()")
	@ResponseBody
	@PostMapping(value = "/alarm", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> insertAlarm(@RequestBody cashVO vo) {

		log.info("/alarm...cashVO: " + vo);

		//int insertCount = commonService.insertAlarm(vo);
		
		//log.info("alarm INSERT COUNT: " + insertCount);

		return new ResponseEntity<>("알림이 입력되었습니다.", HttpStatus.OK) ;
	}
	
	@PreAuthorize("isAuthenticated()")  
	@ResponseBody
	@PutMapping(value = "/updateAlarmCheck/{alarmNum}",produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> updateAlarmCheck(@PathVariable("alarmNum") String alarmNum) {
		
		log.info("/updateAlarmCheck:... " + alarmNum);
		
		if(commonService.updateAlarmCheck(alarmNum) == 1) {//알림 체크값을 바꿨다면
			return new ResponseEntity<>("success", HttpStatus.OK) ;
		} 
			return new ResponseEntity<>("fail", HttpStatus.OK) ;
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER')")
	@GetMapping("/registerNote")
	public String registerNote() {//쪽지 폼 열기
		
		return "common/registerNote";
	}
	
	/*@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER')")
	@GetMapping("/registerNote")
	public String registerNote(@RequestParam("userId")String userId, Model model) {//쪽지 폼 열기
			
		model.addAttribute("to_id", userId);
		
		return "common/registerNote";
	}
	*/
	
	@PreAuthorize("principal.username == #vo.from_id")
	@ResponseBody
	@PostMapping(value = "/Note", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> insertNote(@RequestBody noteVO vo) {

		log.info("/Note...noteVO: " + vo);

		if(commonService.insertNote(vo) == 1) {
			log.info("/Note...not11111: ");
			return new ResponseEntity<>("쪽지를 보냈습니다.", HttpStatus.OK) ;
			
		}else {
			log.info("/Note...not1122221: "); 
			return new ResponseEntity<>("쪽지보내기에 실패했습니다 관리자에게 문의주세요.", HttpStatus.OK) ;
		}
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/fromNoteList")  
	 public String getFromNoteList(Criteria cri, Model model) {//받은쪽지함
		
		log.info("/fromNoteList");
		
		int fromNotetotal = commonService.getFromNoteCount(cri);
		int toNotetotal   = commonService.getToNoteCount(cri);
		int myNotetotal   = commonService.getMyNoteCount(cri);
		
		model.addAttribute("fromNotetotal", fromNotetotal);
		model.addAttribute("toNotetotal"  , toNotetotal);
		model.addAttribute("myNotetotal"  , myNotetotal);
		
		model.addAttribute("fromNoteList", commonService.getFromNoteList(cri));
		
		model.addAttribute("pageMaker", new PageDTO(cri, fromNotetotal));

		return "common/fromNoteList";
	}
	
	
}
