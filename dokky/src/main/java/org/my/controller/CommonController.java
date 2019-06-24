package org.my.controller;
	import java.util.ArrayList;
import java.util.List;

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
		//log.info("auth.getPrincipal : " + auth.getPrincipal());
		//log.info("auth.isAuthenticated : " + auth.isAuthenticated());
		//log.info("auth.getAuthorities() : " + auth.getAuthorities());
		
		List<String> roleNames = new ArrayList<>();

		auth.getAuthorities().forEach(authority -> {

				roleNames.add(authority.getAuthority());//반복해서 추가해주고
			});
		
			log.warn("ROLE NAMES: " + roleNames);// 사용자에 부뎌된 권한 Authentication 객체를 이용해서 사용자가 가진 모든 권한을 문자열로 저장해둠

			if (roleNames.contains("ROLE_ADMIN")) {
				model.addAttribute("msg", "Access Denied 로그인 권한이 없습니다.");
				return;
			}else {
				model.addAttribute("msg", "Access Denied 관리자 권한이 없습니다.");
			}
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
