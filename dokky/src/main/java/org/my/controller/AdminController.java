package org.my.controller;
	import org.my.domain.BoardLikeVO;
import org.my.domain.Criteria;
import org.my.domain.PageDTO;
import org.my.domain.cashVO;
import org.my.service.AdminService;
	import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
	
}
	
