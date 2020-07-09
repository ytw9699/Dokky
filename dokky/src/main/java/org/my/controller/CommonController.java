package org.my.controller;
	import java.io.UnsupportedEncodingException;
	import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
	import java.util.Locale;
import java.util.Random;

	import javax.servlet.http.Cookie;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import javax.servlet.http.HttpSession;
	import org.my.auth.SNSLogin;
	import org.my.auth.SnsValue;
	import org.my.domain.AuthVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.PageDTO;
	import org.my.domain.cashVO;
	import org.my.domain.noteVO;
	import org.my.security.domain.CustomUser;
	import org.my.service.AdminService;
	import org.my.service.CommonService;
	import org.my.service.MemberService;
	import org.my.service.MypageService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.core.GrantedAuthority;
	import org.springframework.security.core.authority.SimpleGrantedAuthority;
	import org.springframework.security.core.context.SecurityContextHolder;
	import org.springframework.security.core.userdetails.User;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.security.web.savedrequest.SavedRequest;
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
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
	
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
		
	
	
	/*@GetMapping("/adminLogin")
	public String adminLogin(Model model, HttpServletRequest request, String error, String logout, String check){
		
		log.info("/adminLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		if(!request.isUserInRole("ROLE_ADMIN")) {//관리자가 아니라면 관리자 로그인 페이지로
			
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
			
			return "common/adminLogin";  
		}

		return "redirect:/admin/userList";//관리자라면 관리자 페이지로
	}*/
	
	@PostMapping("/members") 
	public String postMembers(MemberVO vo, Model model, RedirectAttributes rttr) {//회원가입
		
		log.info("/members: vo" + vo); 
		
		vo.setUserPw(pwencoder.encode(""+Math.random()*10));//패스워드 랜덤 하게 만들어 암호화,이 암호가 없으면 시큐리티인증객체를 못만듬
		
		if(memberService.registerMembers(vo)){
			
			MemberVO memberVO = memberService.readMembers(vo.getUserId());//소셜에서 가져온 프로필에 해당하는 개인정보를 db에서 불러온다
			
			commonService.setAuthentication(memberVO, false);//인증하면서 권한은 미체크 false
			
			rttr.addFlashAttribute("check", "가입완료 되었습니다.");
				
			return "redirect:/main";
			
		}else {
		
			rttr.addFlashAttribute("check", "가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "redirect:/socialLogin";
		}
	}
	
	@PostMapping("/remembers") 
	public String postReMembers(MemberVO vo, Model model, RedirectAttributes rttr) {//재 회원가입
		
		log.info("/remembers: vo" + vo); 
		
		if(memberService.reRegisterMembers(vo)){
			
			MemberVO memberVO = memberService.readMembers(vo.getUserId());//소셜에서 가져온 프로필에 해당하는 개인정보를 db에서 불러온다
			
			commonService.setAuthentication(memberVO, false);//인증하면서 권한은 미체크 false
			
			rttr.addFlashAttribute("check", "재가입완료 되었습니다.");
			
			return "redirect:/main";
			
		}else {
		
			rttr.addFlashAttribute("check", "가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "redirect:/socialLogin";
		}
	}
	
	@RequestMapping(value = "/auth/{snsService}/callback", method = { RequestMethod.GET, RequestMethod.POST})
	public String snsLoginCallback(@PathVariable String snsService, Model model, 
			@RequestParam(value="code", required=false) String code,HttpServletRequest request,
			 RedirectAttributes rttr, @RequestParam(value = "error", defaultValue = "noterror") String error) throws Exception {
		//https://dokky.ga/auth/naver/callback?error=access_denied&error_description=Canceled+By+User&state=
		
		log.info("snsLoginCallback");
		
		if(error.equals("access_denied")) {//정보동의 수락안하고 취소눌를시
			return "redirect:/socialLogin";
		}
		
		SnsValue sns = null; 
		
		if ("naver".equals(snsService))
			sns = naverSns;
		else
			sns = googleSns;
		
		SNSLogin snsLogin = new SNSLogin(sns);
		
		MemberVO profile = snsLogin.getUserProfile(code);//사용자 profile 정보 가져오기
		
		String profileId = profile.getUserId();
		
		if(!memberService.getIdCheckedVal(profileId)){//회원가입되어있지 않다면 , DB 해당 유저가 존재하는 체크
			
			model.addAttribute("id", profileId);
			model.addAttribute("nickName", profile.getNickName());
			
			return "common/memberForm";
		}
		
		MemberVO memberVO = memberService.readMembers(profileId);//소셜에서 가져온 프로필에 해당하는 개인정보를 db에서 불러온다
		
		if(!memberVO.isEnabled()){//탈퇴한 회원 이라면
			
			model.addAttribute("id", profileId);
			model.addAttribute("nickName", profile.getNickName());
			model.addAttribute("bankName", memberVO.getBankName());
			model.addAttribute("account", memberVO.getAccount());
			
			return "common/reMemberForm";//재가입 폼 이동
		}
		
		Boolean result = commonService.setAuthentication(memberVO, true);//인증하면서 권한도 체크 true
		
		if(!result){
			
			rttr.addFlashAttribute("check", "접속 제한된 아이디입니다."); 
			return "redirect:/socialLogin";
		}
		
		memberService.updateLoginDate(profileId); //로긴날짜찍기
		
		HttpSession session = request.getSession();
		
		if (session != null) {

            String redirectUrl = (String)session.getAttribute("preUrl");
            
            if (redirectUrl != null) {
          	   
            	 log.info("redirectUrl="+redirectUrl);
              	 
                 session.removeAttribute("preUrl");
                  
                 return "redirect:"+redirectUrl;
            }
            
        }
		return "redirect:/main";
	}
	
	@GetMapping("/adminMemberForm")
	public String adminMemberForm() {

		log.info("admin/adminMemberForm");
		
		return "common/adminMemberForm";
	}
	
	@PostMapping("/adminMembers") 
	public String postAdminMembers(MemberVO vo, Model model) {//회원가입
		
		log.info("/members: vo" + vo); 
		
		vo.setUserPw(pwencoder.encode(vo.getUserPw()));//패스워드 암호화
		
		if(memberService.registerMembers(vo)){
			
			model.addAttribute("check", "가입완료 되었습니다 로그인해주세요.");
			
			return "common/superAdminLogin";
		}
		
			model.addAttribute("check", "가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "common/superAdminLogin"; 
	}
	
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
	public String adminError(Model model) {//관리자 리스트 접근 제한 에러페이지

		log.info("/adminError");
		
		model.addAttribute("message", "관리자만 접근 가능합니다.");
		
		return "error/commonError";  
	}
	
	@GetMapping("/superAdminError")
	public String superAdminError(Model model) {//관리자 리스트 접근 제한 에러페이지

		log.info("/superAdminError");
		
		model.addAttribute("message", "Super-관리자만 접근 가능합니다.");
		
		return "error/commonError";  
	}

	@GetMapping("/accessError")//공통 접근제한 에러페이지
	public String accessDenied(Authentication auth, Model model) {//Authentication 타입의 파라미터를 받도록 설계해서 필요한 경우에 사용자의 정보를 확인할 수 있도록
		
		log.info("/accessError");
		
		log.info("access Denied : " + auth); 
 
		model.addAttribute("message", "접근 권한이 없습니다. 관리자에게 문의해주세요.");
		
		return "error/commonError";
	}   
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_SUPER')") 
	@GetMapping("/admin/authorizationList")//일반 관리자 권한부여 리스트
	public String authorizationList(Criteria cri, Model model, Authentication authentication, HttpSession session) {
		
		log.info("/admin/authorizationList");
		log.info("cri"+cri);
		
		/*if(authentication == null) {//인증이 안됬다면
			//request.getRequestURL();
			//SavedRequest aa = new SavedRequest();
			
			//SavedRequest saveRequest = new SavedRequest();
			//(Object)"DefaultSavedRequest[http://localhost:8080/admin/authorizationList]";
			//session.setAttribute("SPRING_SECURITY_SAVED_REQUEST", saveRequest);
			
			return "redirect:/superAdminLogin";
		}*/
		
		CustomUser user = (CustomUser)authentication.getPrincipal();
		
		MemberVO vo = user.getMember();
		
		List<AuthVO> AuthList = vo.getAuthList();//사용자의 권한 정보만 list로 가져온다
		
		Iterator<AuthVO> it = AuthList.iterator();
		
		while (it.hasNext()) {
			
			AuthVO authVO = it.next(); 
			
			String auth = authVO.getAuth();
			
			if(!auth.equals("ROLE_SUPER")) {
				
				return "redirect:/superAdminError";//일반관리자는 접근 못하고 슈퍼관리자만 접근할 수 있음
				//return "redirect:/superAdminLogin";
			}
			
        }
		
		model.addAttribute("authorizationList", adminService.getUserList(cri));
		
		int total = adminService.getMemberTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/authorizationList"; 
	}
	
	/*@GetMapping("/superAdminLogin")
    public String superAdminLogin(Model model, HttpServletRequest request, String error, String logout, String check,Authentication authentication) throws UnsupportedEncodingException {
    	
		log.info("/superAdminLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		
		if(authentication != null) {
			log.info("authentication"+SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		}
		
		  Enumeration<String> e = request.getSession().getAttributeNames();
		    
		    while(e.hasMoreElements()){
		    	log.info("Enumeration7="+e.nextElement());
		    }
		    
		    Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
		    
		    log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		    
		
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
		
		return "common/superAdminLogin";  
	}*/
    
	@GetMapping("/superAdminLogin")
	public String superAdminLogin(Model model, HttpServletRequest request, String error, String logout, String check) throws UnsupportedEncodingException {
	
		log.info("/superAdminLogin");
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
				model.addAttribute("check", "아이디가 없습니다");
			}else if(check.equals("notPassword") ) {
				model.addAttribute("check", "비밀번호가 틀립니다");
			}
			else if(check.equals("limit") ) {
				model.addAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요");
			}
		}
		
		return "common/superAdminLogin";   
	}
	
    
	@GetMapping("/socialLogin")//커스톰 로그인 페이지는 반드시 get방식 이여야한다.시큐리티의 특성임
	public String loginInput(String error, String logout, String check, Model model) throws UnsupportedEncodingException {
		
		log.info("/socialLogin");
		 
		//소셜로그인
		SNSLogin naverLogin = new SNSLogin(naverSns);
		
		model.addAttribute("naver_url", naverLogin.getAuthURL());//네이버 로그인 url가져오기
		
		SNSLogin googleLogin = new SNSLogin(googleSns);
		
		model.addAttribute("google_url", googleLogin.getAuthURL());//구글 로그인 url가져오기
		
		return "common/socialLogin";  
	}
	
	/*@GetMapping("/socialLogin")//커스톰 로그인 페이지는 반드시 get방식 이여야한다.시큐리티의 특성임
	public String loginInput(String error, String logout, String check, Model model,HttpServletRequest request, Authentication authentication) throws UnsupportedEncodingException {
		
		log.info("/socialLogin");
		 
		if(authentication != null) {
			log.info("authentication"+SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		}
		
        Enumeration<String> e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration7="+e.nextElement());
        }
        
        Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
        
		//소셜로그인
		SNSLogin naverLogin = new SNSLogin(naverSns);
		
		model.addAttribute("naver_url", naverLogin.getAuthURL());//네이버 로그인 url가져오기
		
		SNSLogin googleLogin = new SNSLogin(googleSns);
		
		model.addAttribute("google_url", googleLogin.getAuthURL());//구글 로그인 url가져오기
		
		return "common/socialLogin";  
	}*/
	
	@PostMapping("/logout")//사용자 직접구현 로그아웃
	public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		
		log.info("/logout");
		
		commonService.logout(request, response, authentication);
			
		return "redirect:/socialLogin";
	}
	
	/*@PostMapping("/logout")//사용자 직접구현 로그아웃
	public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication, HttpSession session) {
		
		log.info("/logout1");
		log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		
		Enumeration<String> e = session.getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration1="+e.nextElement());
        }
        
        e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration2="+e.nextElement());
        }
        
        Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		
		//request.getSession().invalidate();
        //log.info("getId1"+request.getSession().getId());
        
        //session.setMaxInactiveInterval(0);

		//session.invalidate();
		
		e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration3="+e.nextElement());
        }
        
		log.info("/logout2");

		Cookie JSESSIONID = new Cookie("JSESSIONID", null);

		JSESSIONID.setMaxAge(0);

		response.addCookie(JSESSIONID);
		
		// 쿠키 삭제
		
		if(authentication != null) { 
			SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
			
		}
		
		log.info("/logout3");
		
		if(authentication != null) {
			log.info("/logout4");
			//SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
			log.info("/logout5");
			if(SecurityContextHolder.getContext().getAuthentication() != null) {
				log.info("/logout6");
				log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
			}else {
			log.info("/logout7");
			log.info(SecurityContextHolder.getContext().getAuthentication());
			}
		}
		SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		log.info("/logout8");
		
		e = session.getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration3="+e.nextElement());
        }
        
        e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration4="+e.nextElement());
        }
         
         SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
         
         log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
         log.info("/logout9");
         
         //log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
         
		return "redirect:/socialLogin";
	}*/
	
	@GetMapping("/memberForm")
	public String memberForm() {

		log.info("/memberForm");
		
		return "common/memberForm";
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
	public ResponseEntity<String> getNicknameCheckedVal(String inputNickname, String userId) {
		 
		log.info("/nickCheckedVal"); 
		
		if(commonService.checkNickname(inputNickname, userId)) {//닉네임이 중복된다면
		
			return new ResponseEntity<>("success", HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
		}
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
		model.addAttribute("boardTotal", total);  
		model.addAttribute("replyTotal", mypageService.getMyReplyCount(cri));
		model.addAttribute("enabled", commonService.getEnabled(cri.getUserId()));
		
		if(pageLocation == null) {
			return "common/userBoardList"; 
		}else if(pageLocation.equals("admin")) {
			return "admin/userBoardList";
		}else { 
			return "common/userBoardList";
		}
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
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
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
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@GetMapping("/minRegNote")
	public String minRegNote(@RequestParam("userId")String userId, @RequestParam("nickname")String nickname, Model model) {
		
		model.addAttribute("to_id", userId);
		model.addAttribute("to_nickname", nickname);
		model.addAttribute("enabled", commonService.getEnabled(userId));
		
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
		
		 	