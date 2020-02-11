package org.my.controller;
	import java.io.UnsupportedEncodingException;
	import java.util.Locale;
	import javax.servlet.http.HttpServletRequest;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.domain.cashVO;
	import org.my.domain.noteVO;
	import org.my.mapper.MemberMapper;
	import org.my.service.CommonService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.ModelAttribute;
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
	private PasswordEncoder pwencoder;
	
	@Setter(onMethod_ = { @Autowired })
	private MemberMapper memberMapper;

	@GetMapping("/customLogin")//커스톰 로그인 페이지는 반드시 get방식 이여야한다.시큐리티의 특성임
	public String loginInput(Model model, HttpServletRequest request, String error, String logout, String check)throws UnsupportedEncodingException {
		
		log.info("/customLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		//if(!request.isUserInRole("ROLE_SUPERADMIN")) {//관리자가 아니라면 커스텀 로그인 페이지로
		if(!request.isUserInRole("ROLE_ADMIN")) {//관리자가 아니라면 커스텀 로그인 페이지로
			
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

		return "redirect:/admin/userList";//관리자라면 관리자 페이지로
	}
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		return "common/main";
	}
	
	@GetMapping("/adminError")
	public String adminError(Model model) {//관리자 리스트 접근 제한 에러페이지

		log.info("/adminError");
		
		model.addAttribute("msg", "관리자만 접근 가능합니다.");
		
		return "error/accessError";  
	}

	@GetMapping("/accessError")//공통 접근제한 에러페이지
	public String accessDenied(Authentication auth, Model model) {//Authentication 타입의 파라미터를 받도록 설계해서 필요한 경우에 사용자의 정보를 확인할 수 있도록
		
		log.info("/accessError");
		
		log.info("access Denied : " + auth); 
 
		model.addAttribute("msg", "접근 권한이 없습니다. 관리자에게 문의해주세요.");
		
		return "error/accessError";
	}   


	@PostMapping("/superAdmin/customLogout")
	public void logoutPost() {
		
		log.info("/superAdmin/customLogout");
	}
	
	@GetMapping("/memberForm")
	public String memberForm() {

		log.info("/memberForm");
		
		return "common/memberForm";
	}
	
	@GetMapping(value = "/noteCount/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getNoteCount(@PathVariable("userId") String userId) {
		 
		log.info("/noteCount...="+userId);
		
		return  new ResponseEntity<>(commonService.getNoteCount(userId), HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/alarmList")  
	 public String getAlarmList(Criteria cri, Model model) {//내 알림 리스트 가져오기
		
		log.info("/alarmList");
		
		int Alltotal = commonService.getAlarmCount(cri);//전체알람
		int readedTotal = commonService.getAlarmReadCount(cri);//읽은 알람
		int notReadedTotal = Integer.parseInt(commonService.getAlarmRealCount(cri.getUserId()));//읽지않은 알람
		
		if(cri.getOrder() == 0) {
			
			model.addAttribute("alarmList", commonService.getAllAlarmList(cri));
			model.addAttribute("pageMaker", new PageDTO(cri, Alltotal));
			
		}else if(cri.getOrder() == 1){
			model.addAttribute("alarmList", commonService.getReadedAlarmList(cri));
			model.addAttribute("pageMaker", new PageDTO(cri, readedTotal));
			 
		}
		else if (cri.getOrder() == 2){
			model.addAttribute("alarmList", commonService.getNotReadedAlarmList(cri));
			model.addAttribute("pageMaker", new PageDTO(cri, notReadedTotal));
		}
		
		model.addAttribute("Alltotal", Alltotal);
		model.addAttribute("readedTotal", readedTotal);
		model.addAttribute("notReadedtotal", notReadedTotal);
		
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
			return "redirect:/alarmList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount()+"&order="+cri.getOrder();
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
	public String registerNote(Criteria cri, Model model) {//쪽지 폼 열기
		
		int fromNotetotal = commonService.getFromNoteCount(cri);
		int toNotetotal   = commonService.getToNoteCount(cri);
		int myNotetotal   = commonService.getMyNoteCount(cri);
		
		model.addAttribute("fromNotetotal", fromNotetotal);
		model.addAttribute("toNotetotal"  , toNotetotal);
		model.addAttribute("myNotetotal"  , myNotetotal);
		
		return "common/registerNote";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER')")
	@GetMapping("/minRegNote")
	public String minRegNote(@RequestParam("userId")String userId, @RequestParam("nickname")String nickname, Model model) {
			
		model.addAttribute("to_id", userId);
		model.addAttribute("to_nickname", nickname);
		
		return "common/minRegNote";
	}
	
	@PreAuthorize("principal.username == #vo.from_id")
	@ResponseBody
	@PostMapping(value = "/Note", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> insertNote(@RequestBody noteVO vo) {

		log.info("/Note...noteVO: " + vo);

		if(commonService.insertNote(vo) == 1) {
			return new ResponseEntity<>("쪽지를 보냈습니다.", HttpStatus.OK) ;
			
		}else {
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
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/toNoteList")  
	 public String getToNoteList(Criteria cri, Model model) {//보낸쪽지함
		
			log.info("/toNoteList");
			
			int fromNotetotal = commonService.getFromNoteCount(cri);
			int toNotetotal   = commonService.getToNoteCount(cri);
			int myNotetotal   = commonService.getMyNoteCount(cri);
			
			model.addAttribute("fromNotetotal", fromNotetotal);
			model.addAttribute("toNotetotal"  , toNotetotal);
			model.addAttribute("myNotetotal"  , myNotetotal);
			
			model.addAttribute("toNoteList", commonService.getToNoteList(cri));
			
			model.addAttribute("pageMaker", new PageDTO(cri, fromNotetotal));
	
			return "common/toNoteList";
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/myNoteList")
	public String getMyNoteList(Criteria cri, Model model) {//내게쓴 쪽지함
		
			log.info("/myNoteList");
			
			int fromNotetotal = commonService.getFromNoteCount(cri);
			int toNotetotal   = commonService.getToNoteCount(cri);
			int myNotetotal   = commonService.getMyNoteCount(cri);
			
			model.addAttribute("fromNotetotal", fromNotetotal);
			model.addAttribute("toNotetotal"  , toNotetotal);
			model.addAttribute("myNotetotal"  , myNotetotal);
			
			model.addAttribute("myNoteList", commonService.getMyNoteList(cri));
			
			model.addAttribute("pageMaker", new PageDTO(cri, fromNotetotal));
	
			return "common/myNoteList";
	}
	
	@PreAuthorize("isAuthenticated()")
	@ResponseBody
	@PutMapping(value = "/noteCheck/{note_num}",produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> updateNoteCheck(@PathVariable("note_num") String note_num) { 
		
		log.info("/updateNoteCheck:... " + note_num);
		
		if(commonService.updateNoteCheck(note_num) == 1) {//쪽지의 체크값을 바꿨다면
			return new ResponseEntity<>("success", HttpStatus.OK) ;
		} 
			return new ResponseEntity<>("fail", HttpStatus.OK) ;
	}
	
	@PreAuthorize("principal.username == #cri.userId")
	@GetMapping("/detailNotepage")
	public String get(@RequestParam("note_num") Long note_num, @RequestParam("note_kind") String note_kind, Model model, @ModelAttribute("cri") Criteria cri) {

		log.info("/detailNotepage");
		
		noteVO note = commonService.getDetailNotepage(note_num);
		
		int fromNotetotal = commonService.getFromNoteCount(cri);
		int toNotetotal   = commonService.getToNoteCount(cri);
		int myNotetotal   = commonService.getMyNoteCount(cri);
		
		model.addAttribute("note", note);
		model.addAttribute("note_kind", note_kind);
		model.addAttribute("fromNotetotal", fromNotetotal);
		model.addAttribute("toNotetotal"  , toNotetotal);
		model.addAttribute("myNotetotal"  , myNotetotal);
		
		return "common/detailNotepage";
	}
	 
	@PostMapping("/deleteNote")//쪽지 삭제
	public String deleteNote(@RequestParam("note_num") Long note_num, @RequestParam("note_kind") String note_kind, Criteria cri) {

		 	log.info("/deleteNote..." + note_num);
		 	
		 	if (note_kind.equals("fromNote")) {
		 		
		 		commonService.updateFromNote(note_num);
		 		
		 		return "redirect:/fromNoteList?userId="+cri.getUserId()+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
	 			
			}else if(note_kind.equals("toNote")) {
			 		
		 		commonService.updateToNote(note_num);
			
		 		return "redirect:/toNoteList?userId="+cri.getUserId()+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
		 		
			}else{//if(note_kind.equals("myNote")) 
				
		 		commonService.deleteMyNote(note_num);
		 		
		 		return "redirect:/myNoteList?userId="+cri.getUserId()+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
			}
	}
	
	@PreAuthorize("principal.username == #userId")   
	@PostMapping("/deleteAllNote")//다중 쪽지 삭제
		public String deleteAllNote(@RequestParam("checkRow") String checkRow , @RequestParam("note_kind") String note_kind,
				@RequestParam("userId")String userId, Criteria cri) {
		 
			log.info("/deleteAllNote");
		 	log.info("checkRow..." + checkRow);
		 	
		 	String[] arrIdx = checkRow.split(",");
		 	
		 	
		 	if (note_kind.equals("fromNote")) {
		 		
		 		for (int i=0; i<arrIdx.length; i++) {
			 		
			 		Long note_num = Long.parseLong(arrIdx[i]); 
			 		
			 		commonService.updateFromNote(note_num);
			 	}
		 		
		 		return "redirect:/fromNoteList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
	 			
			}else if(note_kind.equals("toNote")) {
				
				for (int i=0; i<arrIdx.length; i++) {
			 		
			 		Long note_num = Long.parseLong(arrIdx[i]); 
			 		
			 		commonService.updateToNote(note_num);
			 	}
				
				return "redirect:/toNoteList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
				
			}else {//if(note_kind.equals("myNote"))
				
				for (int i=0; i<arrIdx.length; i++) {
			 		
			 		Long note_num = Long.parseLong(arrIdx[i]); 
			 		
			 		commonService.deleteMyNote(note_num);
			 	}
				
				return "redirect:/myNoteList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
			}
	}
}
