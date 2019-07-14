package org.my.controller;
	import org.my.domain.Criteria;
import org.my.domain.PageDTO;
import org.my.domain.ReplyVO;
import org.my.domain.cashVO;
import org.my.domain.reportVO;
import org.my.service.AdminService;
import org.my.service.MypageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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

import lombok.Setter;
import lombok.extern.log4j.Log4j;
	
	//import org.springframework.security.access.annotation.Secured;

@Controller
@Log4j
@RequestMapping("/admin/*")
//@Secured({"ROLE_ADMIN"}) 아래와 같은거
@PreAuthorize("hasRole('ROLE_ADMIN')") //관리자권한이있어야함
public class AdminController {
	
	@Setter(onMethod_ = @Autowired)
	private AdminService service;
	
	@Setter(onMethod_ = @Autowired)
	private MypageService MypageService;
	
	@GetMapping("memberList")
	public String admin(Criteria cri, Model model) {
		
		log.info("admin/memberList");
		log.info(cri);
		
		model.addAttribute("memberList", service.getMemberList(cri));
		
		int total = service.getMemberTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/memberList"; 
	}
	
	@GetMapping("cashRequest")
	public String cashRequest(Criteria cri,Model model) {
		
		log.info("admin/cashRequest");
		
		model.addAttribute("cashRequest", service.getCashRequest(cri));
		
		int total = service.getTotalCount();
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/cashRequest"; 
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/approve", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> approve(@RequestBody cashVO vo) {
		
		log.info("vo...="+vo);
		
		return service.updateApprove(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	@PreAuthorize("isAuthenticated()")
 	@GetMapping("/userForm")  
	public String userForm(@RequestParam("userId") String userId, Model model) {
		
		model.addAttribute("user", service.getUserForm(userId));
		
		log.info("userForm");
		
		return "admin/userForm";
	} 
	
	@PreAuthorize("isAuthenticated()") 
 	@GetMapping("/userCashHistory")  
	public String userCashHistory(Criteria cri, Model model) {
		
		log.info("getUserCashHistoryCount");
		
		int total = MypageService.getMyCashHistoryCount(cri.getUserId());
		
		log.info("userCashHistory");
		
		model.addAttribute("userCashHistory", MypageService.getMyCashHistory(cri));
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userCashHistory"; 
	}
	
	@GetMapping("userReportList")
	public String userReportList(Criteria cri, Model model) {//게시글 댓글 신고
		
		log.info("admin/userReportList");
		log.info(cri);
		
		model.addAttribute("reportList", service.getUserReportList(cri));
		
		int total = service.getUserReportCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/reportList"; 
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleStop/{userId}", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateRoleStop(@PathVariable("userId") String userId) {
		
		log.info("userId...="+userId);
		
		return service.updateRoleStop(userId) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleLimit/{userId}", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateRoleLimit(@PathVariable("userId") String userId) {
		
		log.info("userId...="+userId);
		
		return service.updateRoleLimit(userId) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleUser/{userId}", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> updateRoleUser(@PathVariable("userId") String userId) {
		
		log.info("userId...="+userId);
		
		return service.updateRoleUser(userId) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
}
	
