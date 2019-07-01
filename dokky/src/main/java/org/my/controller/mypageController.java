package org.my.controller;
	import org.my.service.MypageService;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
	import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/mypage/*")
@AllArgsConstructor
public class mypageController {
	
	private MypageService service;
	
	@GetMapping("/mypage")
	public String mypage(Model model) {
		
		return "mypage/mypage";
	}
}