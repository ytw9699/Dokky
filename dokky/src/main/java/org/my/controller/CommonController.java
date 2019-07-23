package org.my.controller;
	import java.io.UnsupportedEncodingException;
	import java.util.Locale;

import org.my.domain.Criteria;
import org.my.domain.MemberVO;
import org.my.domain.PageDTO;
import org.my.domain.ReplyVO;
import org.my.domain.alarmVO;
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
	import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
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
		
		model.addAttribute("realtimeList", memberService.getRealtimeList());
		
		model.addAttribute("monthlyList", memberService.getMonthlyList());
		
		model.addAttribute("donationList", memberService.getDonationList());
		
		return "main";
	}
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		model.addAttribute("realtimeList", memberService.getRealtimeList());
		
		model.addAttribute("monthlyList", memberService.getMonthlyList());
		
		model.addAttribute("donationList", memberService.getDonationList());
		
		return "main";
	}
	
	@GetMapping("/adminError")
	public String adminError(Model model) {

		log.info("adminError");
		
		model.addAttribute("msg", "Access Denied 관리자 권한이 없습니다.");
		
		return "error/adminError";
	}

	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		//는 Authentication 타입의 파라미터를 받도록 설계해서 필요한 경우에 사용자의 정보를 확인할 수 있도록 합니
		log.info("access Denied : " + auth);

		model.addAttribute("msg", "Access Denied 로그인 권한이 없습니다.");
	}   

	@GetMapping("/customLogin")
	public void loginInput(String error, String logout,String check, Model model) throws UnsupportedEncodingException {

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
	}

	/*@GetMapping("/customLogout")
	public void logoutGET() {

		log.info("custom logout");
	}*/   

	@PostMapping("/customLogout")
	public void logoutPost() {

		log.info("post custom logout");
	}
	@GetMapping("/memberForm")
	public String memberForm() {

		log.info("get memberForm");
		return "members/memberForm";
	}
	
	@PostMapping("/members")
	public String postMembers(MemberVO vo,Model model) {//회원가입
		log.info("==========================");
		log.info("post members: " + vo); 
		log.info("==========================");
		
		vo.setUserPw(pwencoder.encode(vo.getUserPw()));//패스워드 암호화
		
		if(memberService.registerMembers(vo)){
			model.addAttribute("check", "가입완료 되었습니다 로그인해주세요.");
			
			return "/customLogin";
		}
		model.addAttribute("check", "가입실패 하였습니다 관리자에게 문의주세요.");
		return "/customLogin";
}
	
	@GetMapping(value = "/idCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getIdCheckedVal(String inputId) {
		 
		log.info("username...="+inputId);
		
		if(memberService.getIdCheckedVal(inputId)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	 
	@GetMapping(value = "/nickCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getNicknameCheckedVal(String inputNickname) {
		 
		log.info("inputNickname...="+inputNickname);
		
		if(memberService.getNicknameCheckedVal(inputNickname)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@GetMapping(value = "/emailCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getEmailCheckedVal(String inputEmail) {
		 
		log.info("inputEmail...="+inputEmail);
		
		if(memberService.getEmailCheckedVal(inputEmail)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userBoardList") 
	public String userBoardList(Criteria cri, Model model) { //유저 게시글 가져오기
		
		model.addAttribute("userBoard", mypageService.getMyBoardList(cri));
		
		log.info("userBoardList"); 
		
		int total = mypageService.getMyBoardCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("boardTotal",total);  
		model.addAttribute("replyTotal", mypageService.getMyReplyCount(cri));
		
		return "members/userBoardList";
	} 
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userReplylist")  
	public String userReplylist(Criteria cri, Model model) {
		
		log.info("userReplylist "+cri);
		
		model.addAttribute("userReply", mypageService.getMyReplylist(cri));
		
		log.info("getUserReplyCount");
		
		int total = mypageService.getMyReplyCount(cri);//total은 내 댓글의 총 게시물수
		
		log.info("pageMaker");
		
		model.addAttribute("boardTotal",mypageService.getMyBoardCount(cri));  
		model.addAttribute("replyTotal", total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "members/userReplylist";
	} 
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/alarmList")  
	 public String getAlarmList(Criteria cri, Model model) {//내 알림 리스트 가져오기
		
		log.info("getAlarmCount");
		int total = commonService.getAlarmCount(cri);//total은 내 댓글의 총 게시물수
		
		model.addAttribute("total", total);
		
		log.info("getAlarmList");
		
		model.addAttribute("alarmList", commonService.getAlarmList(cri));
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));

		return "common/alarmList";
	}
	
	@PreAuthorize("isAuthenticated()")
	@ResponseBody
	@PostMapping(value = "/alarm", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> insertAlarm(@RequestBody alarmVO vo) {

		log.info("alarmVO: " + vo);

		int insertCount = commonService.insertAlarm(vo);
		
		log.info("alarm INSERT COUNT: " + insertCount);

		return insertCount == 1  
				?  new ResponseEntity<>("알림이 입력되었습니다.", HttpStatus.OK) 
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
}
