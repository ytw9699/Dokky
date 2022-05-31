/*
- 마지막 업데이트 2022-05-29
*/
package org.my.controller;
	import java.io.UnsupportedEncodingException;
	import java.util.List;
	import java.util.Locale;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.auth.SNSLogin;
	import org.my.auth.SnsValue;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.PageDTO;
	import org.my.domain.noteVO;
	import org.my.service.AdminService;
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
	import org.springframework.web.bind.annotation.DeleteMapping;
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
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
	
	@Setter(onMethod_ = @Autowired)
	private SnsValue naverSns;
	
	@Setter(onMethod_ = @Autowired)
	private SnsValue googleSns;
	
	@Setter(onMethod_ = @Autowired)
	private AdminService adminService;
	
	@ResponseBody
 	@DeleteMapping(value = "/SavedRequest")
	public ResponseEntity<String> deleteSavedRequestSession(HttpServletRequest request){
		
		log.info("/deleteSavedRequestSession:... ");
		
		request.getSession().removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
		
		return new ResponseEntity<>("success", HttpStatus.OK);
	}
	
	@RequestMapping(value="/commonLogin", method = {RequestMethod.GET, RequestMethod.POST})
	public String getCommonLogin(HttpServletRequest request, HttpServletResponse response, Model model) throws UnsupportedEncodingException {
		
		log.info("/commonLogin");
		 
		String preUrl  = request.getHeader("referer");
		
		if(preUrl != null){
			if(!(preUrl.contains("ogin")) && !(preUrl.contains("accessError"))){//login또는 error 페이지 제외
				request.getSession().setAttribute("preUrl", preUrl);
			}
		}
		
		SNSLogin naverLogin = new SNSLogin(naverSns);
		
		model.addAttribute("naver_url", naverLogin.getAuthURL());
		
		SNSLogin googleLogin = new SNSLogin(googleSns);
		
		model.addAttribute("google_url", googleLogin.getAuthURL());
		
		return "common/commonLogin";  
	}
	
	@GetMapping("/auth/{snsService}/callback")
	public String socialLoginCallback(@PathVariable String snsService, Model model, HttpServletRequest request,
								      @RequestParam(value = "code", required = false) String code, RedirectAttributes rttr, 
								      @RequestParam(value = "error", defaultValue = "noterror") String error) throws Exception {
		
		log.info("/auth/"+snsService+"/callback");
		
		if(error.equals("access_denied")) {//정보동의 수락안하고 취소눌를시
			return "redirect:/commonLogin";
		}
		
		SnsValue sns = null; 
		
		if ("naver".equals(snsService))
			sns = naverSns;
		else
			sns = googleSns;
		
		SNSLogin snsLogin = new SNSLogin(sns);
		
		MemberVO profile = snsLogin.getUserProfile(code);//소셜로부터 사용자 profile 받기
		
		String profileId = profile.getUserId();
		
		if(!commonService.getIdCheckedVal(profileId)){//회원가입되어있지 않다면
			
			model.addAttribute("id", profileId);
			model.addAttribute("nickName", profile.getNickName());
			
			return "common/memberForm";
		}
		
		MemberVO memberVO = memberService.readMembers(profileId);//소셜에서 가져온 프로필에 해당하는 개인정보를 db에서 불러온다
		
		if(!memberVO.isAccountNonLocked()){
			rttr.addFlashAttribute("errormsg", "접속 제한된 아이디입니다."); 
			return "redirect:/commonLogin";
		}
		
		if(!memberVO.isEnabled()){//탈퇴한 회원 이라면
			
			model.addAttribute("id", profileId);
			model.addAttribute("nickName", profile.getNickName());
			model.addAttribute("bankName", memberVO.getBankName());
			model.addAttribute("account", memberVO.getAccount());
			
			return "common/reMemberForm";//재가입 폼 이동
		}
		
		if(commonService.setAuthentication(memberVO) == false){//인증처리
			rttr.addFlashAttribute("errormsg", "로그인 할 수 없습니다."); 
			return "redirect:/commonLogin";
		}
		
		String redirectURL = commonService.CustomAuthLoginSuccessHandler(profileId, request);
		
		return "redirect:"+redirectURL;
	}
	
	@GetMapping("/memberForm")
	public String memberForm() {

		log.info("/memberForm");
		
		return "common/memberForm";
	}
	
	@GetMapping(value = "/nickCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getNicknameCheckedVal(String inputNickname, String userId) {
		 
		log.info("/nickCheckedVal"); 
		
		if(commonService.getNicknameCheckedVal(inputNickname, userId)) {//닉네임이 중복된다면
			
			log.info("/duplicated"); 
			
			return new ResponseEntity<>("duplicated", HttpStatus.OK);
			
		}else {
			
			log.info("/notDuplicated"); 
			
			return new ResponseEntity<>("notDuplicated", HttpStatus.OK);
		}
	}
	
	
	@PostMapping("/members") 
	public String postMembers(MemberVO vo, Model model, RedirectAttributes rttr) {//회원가입
		
		log.info("/members: vo" + vo); 
		
		vo.setUserPw(pwencoder.encode(""+Math.random()*10));
		//패스워드 랜덤 하게 만들어 암호화,이 암호가 없으면 시큐리티인증객체토큰 중(UsernamePasswordAuthenticationToken을)못 만드는것 같다.
		
		if(memberService.registerMembers(vo)){
			
			MemberVO memberVO = memberService.readMembers(vo.getUserId());//소셜에서 가져온 프로필에 해당하는 개인정보를 db에서 불러온다
			
			if(commonService.setAuthentication(memberVO) == false){//인증처리
				rttr.addFlashAttribute("errormsg", "다시 로그인 해주세요."); 
				return "redirect:/commonLogin";
			}
			
			rttr.addFlashAttribute("check", "가입완료 되었습니다.");
				
			return "redirect:/main";
			
		}else {
		
			rttr.addFlashAttribute("errormsg", "가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "redirect:/commonLogin";
		}
	}
	
	@PostMapping("/remembers") 
	public String reRegisterMembers(MemberVO vo, Model model, RedirectAttributes rttr){//재 회원가입
		
		log.info("/remembers: vo" + vo); 
		
		if(memberService.reRegisterMembers(vo)){
			
			MemberVO memberVO = memberService.readMembers(vo.getUserId());
			
			if(commonService.setAuthentication(memberVO) == false){//인증처리
				rttr.addFlashAttribute("errormsg", "다시 로그인 해주세요."); 
				return "redirect:/commonLogin";
			}
			
			rttr.addFlashAttribute("check", "재가입완료 되었습니다.");
			
			return "redirect:/main";
			
		}else {
		
			rttr.addFlashAttribute("errormsg", "재가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "redirect:/commonLogin";
		}
	}
	
	@PostMapping("/customLogout")//사용자 직접구현 로그아웃
	public String customLogout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		
		log.info("/customLogout");
		
		commonService.customLogout(request, response, authentication);
			
		return "redirect:/commonLogin";
	}
		
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String main(Model model) {
		
		log.info("/main");
		
		List<BoardVO> realtimeBoardList = commonService.getRealtimeBoardList();
		List<BoardVO> monthlyBoardList = commonService.getMonthlyBoardList();
		List<BoardVO> donationBoardList = commonService.getDonationBoardList();
		
		model.addAttribute("realtimeBoardList", realtimeBoardList);//실시간 게시글
		
		model.addAttribute("monthlyBoardList", monthlyBoardList);//한달 인기글
		
		model.addAttribute("donationBoardList", donationBoardList);//한달 최다 기부글
		
		return "common/main";
	}
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		List<BoardVO> realtimeBoardList = commonService.getRealtimeBoardList();
		List<BoardVO> monthlyBoardList = commonService.getMonthlyBoardList();
		List<BoardVO> donationBoardList = commonService.getDonationBoardList();
		
		model.addAttribute("realtimeBoardList", realtimeBoardList);//실시간 게시글
		
		model.addAttribute("monthlyBoardList", monthlyBoardList);//한달 인기글
		
		model.addAttribute("donationBoardList", donationBoardList);//한달 최다 기부글
		
		return "common/main";
	}
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userBoardList")
	public String getUserBoardList(Criteria cri, Model model, 
							@RequestParam(value = "pageLocation", defaultValue = "user", required = false) String pageLocation ){
		
		log.info("/userBoardList"); 
		
		model.addAttribute("userBoardList", mypageService.getMyBoardList(cri));
		
		int total = mypageService.getMyBoardCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("boardTotal", total);  
		model.addAttribute("replyTotal", mypageService.getMyReplyCount(cri));
		model.addAttribute("enabled", commonService.getEnabled(cri.getUserId()));
		
		if(pageLocation.equals("admin")) {
			
			return "admin/userBoardList";
			
		}else{
			
			return "common/userBoardList";
		}
	} 
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userReplylist")  
	public String getUserReplylist(Criteria cri, Model model, 
						 @RequestParam(value = "pageLocation", defaultValue = "user", required = false) String pageLocation ){ 
		
		log.info("/userReplylist");
		
		model.addAttribute("userReplylist", mypageService.getMyReplylist(cri));
		
		int total = mypageService.getMyReplyCount(cri);
		
		model.addAttribute("boardTotal", mypageService.getMyBoardCount(cri));  
		model.addAttribute("replyTotal", total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("enabled", commonService.getEnabled(cri.getUserId()));
		
		if(pageLocation.equals("admin")) {
			
			return "admin/userReplylist";
			
		}else { 
			
			return "common/userReplylist";
		}
	} 
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@GetMapping("/noteForm")
	public String getNoteForm(@RequestParam("userId")String userId, @RequestParam("nickname")String nickname, Model model) {
		
		model.addAttribute("to_id", userId);
		model.addAttribute("to_nickname", nickname);
		model.addAttribute("enabled", commonService.getEnabled(userId));
		
		return "common/noteForm";
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@GetMapping("/myNoteForm")
	public String getMyNoteForm(Criteria cri, Model model) {
		
		int fromNotetotal = commonService.getFromNoteCount(cri);
		int toNotetotal   = commonService.getToNoteCount(cri);
		int myNotetotal   = commonService.getMyNoteCount(cri);
		
		model.addAttribute("fromNotetotal", fromNotetotal);
		model.addAttribute("toNotetotal"  , toNotetotal);
		model.addAttribute("myNotetotal"  , myNotetotal);
		
		return "common/myNoteForm";
	}
	
	@PreAuthorize("principal.username == #vo.from_id")
	@ResponseBody
	@PostMapping(value = "/note", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> postNote(@RequestBody noteVO vo){

		log.info("/note...noteVO: " + vo);

		if(commonService.insertNote(vo) == 1){
			
			return new ResponseEntity<>(HttpStatus.OK);
			
		}else{
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
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
	
	@PreAuthorize("principal.username == #cri.userId")
	@GetMapping("/detailNotepage")
	public String getDetailNotepage(@RequestParam("note_num") Long note_num, @RequestParam("note_kind") String note_kind, 
																Model model, @ModelAttribute("cri") Criteria cri) {
		log.info("/detailNotepage");
		
		noteVO note = commonService.getDetailNotepage(note_num);
		
		if(note == null){
		
			log.info("/serverError");
			
			model.addAttribute("message", "ServerError입니다 관리자에게 문의해주세요.");
			
			return "error/commonError";  
		}
		
		model.addAttribute("note", note);
		model.addAttribute("note_kind", note_kind);
		
		return "common/detailNotepage";
	}
	 
	@PostMapping("/deleteNote")//쪽지 삭제
	public String deleteNote(@RequestParam("note_num") Long note_num, 
							 @RequestParam("note_kind") String note_kind, Criteria cri){

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
	public String deleteAllNote(@RequestParam("checkRow")String checkRow , @RequestParam("note_kind")String note_kind,
								@RequestParam("userId")String userId, Criteria cri) {
		 
			log.info("/deleteAllNote");
		 	log.info("checkRow..." + checkRow);
		 	
		 	String[] arrIdx = checkRow.split(",");
		 	
		 	if(note_kind.equals("fromNote")){
		 		
		 		for(int i=0; i<arrIdx.length; i++) {
			 		
			 		Long note_num = Long.parseLong(arrIdx[i]); 
			 		
			 		commonService.updateFromNote(note_num);
			 	}
		 		
		 		return "redirect:/fromNoteList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
	 			
			}else if(note_kind.equals("toNote")){
				
				for(int i=0; i<arrIdx.length; i++) {
			 		
			 		Long note_num = Long.parseLong(arrIdx[i]); 
			 		
			 		commonService.updateToNote(note_num);
			 	}
				
				return "redirect:/toNoteList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
				
			}else{//if(note_kind.equals("myNote"))
				
				for(int i=0; i<arrIdx.length; i++) {
			 		
			 		Long note_num = Long.parseLong(arrIdx[i]); 
			 		
			 		commonService.deleteMyNote(note_num);
			 	}
				
				return "redirect:/myNoteList?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
			}
	}
	
	@PreAuthorize("isAuthenticated()")
	@ResponseBody
	@PutMapping(value = "/noteCheck/{note_num}", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> updateNoteCheck(@PathVariable("note_num") String note_num) { 
		
			log.info("/updateNoteCheck:... " + note_num);
			
			if(commonService.updateNoteCheck(note_num) == 1) {//쪽지의 체크값을 바꿨다면
				
				return new ResponseEntity<>(HttpStatus.OK) ;
				
			}else { 

				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
	}
	
	@PreAuthorize("principal.username == #cri.userId")
	@GetMapping("/alarmList")  
	public String getAlarmList(Criteria cri, Model model) {//내 알림 리스트 가져오기
		
			log.info("/alarmList");
			
			int allAlarmCount = commonService.getAllAlarmCount(cri);//전체알람
			int alarmCountRead = commonService.getAlarmCountRead(cri);//읽은 알람
			int alarmCountNotReaded = commonService.getAlarmCountNotRead(cri.getUserId());//읽지않은 알람
			
			if(cri.getOrder() == 0) {
				
				model.addAttribute("alarmList", commonService.getAllAlarmList(cri));
				model.addAttribute("pageMaker", new PageDTO(cri, allAlarmCount));
				
			}else if(cri.getOrder() == 1){
				
				model.addAttribute("alarmList", commonService.getAlarmListRead(cri));
				model.addAttribute("pageMaker", new PageDTO(cri, alarmCountRead));
			}
			else if (cri.getOrder() == 2){
				
				model.addAttribute("alarmList", commonService.getAlarmListNotRead(cri));
				model.addAttribute("pageMaker", new PageDTO(cri, alarmCountNotReaded));
			}
			
			model.addAttribute("allAlarmCount", allAlarmCount);
			model.addAttribute("alarmCountRead", alarmCountRead);
			model.addAttribute("alarmCountNotReaded", alarmCountNotReaded);
			
			return "common/alarmList";
	}
	
	@PreAuthorize("principal.username == #userId")   
	@PostMapping("/deleteAllAlarm")//다중알람삭제
	public String deleteAllAlarm(@RequestParam("checkRow")String checkRow, 
								 @RequestParam("userId")String userId, Criteria cri){
		 
		log.info("/deleteAllAlarm");
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
	@PutMapping(value = "/updateAlarmCheck/{alarmNum}", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> updateAlarmCheck(@PathVariable("alarmNum") String alarmNum) {
		
		log.info("/updateAlarmCheck:... " + alarmNum);
		
		if(commonService.updateAlarmCheck(alarmNum) == 1) {//알림 체크값을 바꿨다면
			
			return new ResponseEntity<>("success", HttpStatus.OK) ;
			
		}else{
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@GetMapping(value = "/getAlarmCountNotRead/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getAlarmCountNotRead(@PathVariable("userId") String userId) {
		 
		log.info("/getAlarmCountNotRead...="+userId);
		
		return new ResponseEntity<>(Integer.toString(commonService.getAlarmCountNotRead(userId)), HttpStatus.OK);
	}
	
	@GetMapping(value = "/noteCount/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getNoteCount(@PathVariable("userId") String userId) {
		 
		log.info("/noteCount...="+userId);
		
		return new ResponseEntity<>(commonService.getNoteCount(userId), HttpStatus.OK);
	}
	
	@GetMapping(value = "/chatCount/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getChatCount(@PathVariable("userId") String userId) {
		 
		log.info("/chatCount...="+userId);
		
		return new ResponseEntity<>(commonService.getChatCount(userId), HttpStatus.OK);
	}
	
	@GetMapping("/accessError")//접근 권한 에러
	public String accessDenied(HttpServletResponse response, HttpServletRequest request, Model model, @RequestParam(value = "authorization",
	required=false, defaultValue = "common" ) String authorization){
		
		log.info("/accessError");
		
		if( "true".equals(request.getHeader("AJAX"))) {
			response.setHeader("Location", "/accessError?authorization="+authorization);
		}
		
		if(authorization.equals("superAdmin")){
			
			model.addAttribute("message", "슈퍼관리자만 접근 가능합니다.");
			
		}else if(authorization.equals("admin")){
			
			model.addAttribute("message", "일반 관리자만 접근 가능합니다.");
			
		}else {
			
			model.addAttribute("message", "접근 권한이 없습니다.");
		}
		
		return "error/commonError";
	}  
	
	@GetMapping("/serverError")
	public String serverError(Model model) {//serverError페이지

		log.info("/serverError");
		
		model.addAttribute("message", "ServerError입니다 관리자에게 문의해주세요.");
		
		return "error/commonError";  
	}
	
}
		 	