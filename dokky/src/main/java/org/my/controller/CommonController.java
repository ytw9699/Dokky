package org.my.controller;
	import org.my.domain.MemberVO;
	import org.my.service.MemberService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j 
public class CommonController {
	
	@Setter(onMethod_ = @Autowired)
	private MemberService service;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;

	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {

		log.info("access Denied : " + auth);

		model.addAttribute("msg", "Access Denied");
	}

	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {

		log.info("error: " + error);
		log.info("logout: " + logout);

		if (error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}

		if (logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
	}

	@GetMapping("/customLogout")
	public void logoutGET() {

		log.info("custom logout");
	}

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
	public String postMembers(MemberVO vo) {//회원가입
		log.info("==========================");
		log.info("post members: " + vo); 
		log.info("==========================");
		
		vo.setUserpw(pwencoder.encode(vo.getUserpw()));//패스워드 암호화
		
		service.registerMembers(vo);
		
		return "redirect:/customLogin";
	}
}
