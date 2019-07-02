package org.my.controller;
	import org.my.domain.BoardLikeVO;
import org.my.domain.MemberVO;
import org.my.domain.ReplyVO;
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
import org.springframework.web.bind.annotation.RequestMethod;
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
	private PasswordEncoder pwencoder;

 	@GetMapping("/myInfoForm")  
	public String myInfoForm(@RequestParam("userId") String userId, Model model) { 
		
		model.addAttribute("myInfo", service.getMyInfo(userId));
		
		log.info("myInfoForm");
		
		return "mypage/myInfoForm";
	}
	
	@PreAuthorize("isAuthenticated()") 
	@PostMapping(value = "/checkPassword", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> checkPassword(@RequestBody checkVO vo) {
		
		log.info("userId...="+vo.getUserId());
		log.info("getUserPw...="+vo.getUserPw());
		
		String getPw = service.getMemberPW(vo.getUserId());
		
		if(!pwencoder.matches(vo.getUserPw(), getPw)) {//비밀번호 일치하지 않는다면
	        	
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);//404
	    }
			return new ResponseEntity<>("success",HttpStatus.OK);//200
	}
		 
	@PreAuthorize("principal.username == #vo.userId")
	@PostMapping("/myInfo")
	public String updateMyInfo(MemberVO vo, Model model) {
		
		service.updateMyInfo(vo);
		
		log.info("updateMyInfo");
		
		model.addAttribute("myInfo", service.getMyInfo(vo.getUserId()));
		
		return "mypage/myInfoForm";
	}
}