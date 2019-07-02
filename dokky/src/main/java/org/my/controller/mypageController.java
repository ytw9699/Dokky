package org.my.controller;
	import org.my.service.MypageService;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
	import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/mypage/*")
@AllArgsConstructor
@PreAuthorize("isAuthenticated()")
public class mypageController {
	
	private MypageService service;
	
	@GetMapping("/myInfo")
	public String mypage(@RequestParam("userId") String userId, Model model) { 
		
		model.addAttribute("myInfo", service.getMyInfo(userId));
		
		log.info("mypageMain");
		
		return "mypage/mypageMain";
	}
}