package org.my.controller;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.domain.alarmVO;
	import org.my.domain.commonVO;
	import org.my.service.AdminService;
	import org.my.service.MypageService;
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
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
  //import org.springframework.security.access.annotation.Secured;

@Controller
@Log4j
@RequestMapping("/admin/*")
@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_SUPER')") //관리자권한이있어야함 @Secured({"ROLE_ADMIN"}) 같은거
public class AdminController {
	
	@Setter(onMethod_ = @Autowired)
	private AdminService adminService;
	
	@Setter(onMethod_ = @Autowired)
	private MypageService mypageService;
	
	@GetMapping("userList")//계정관리 회원리스트 가져오기
	public String admin(Criteria cri, Model model) {
	    
		log.info("/admin/userList");
		log.info("cri"+cri);
		
		model.addAttribute("userList", adminService.getMemberList(cri));
		
		int total = adminService.getMemberTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userList"; 
	}
	
	@GetMapping("cashRequest")//결제관리 충전,환전 요청내역 리스트가져오기
	public String cashRequest(Criteria cri,Model model) {
		
		log.info("admin/cashRequest");
		
		model.addAttribute("cashRequest", adminService.getCashRequest(cri));
		
		int total = adminService.getTotalCount();
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/cashRequest"; 
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/approve", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> approve(@RequestBody commonVO vo) {
		
		log.info("/approve");
		log.info("commonVO...="+vo);
		
		return adminService.updateApprove(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
		}
	
	/*@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "/approve", consumes = "application/json", produces = "text/plain; charset=UTF-8")
		@ResponseBody
		public ResponseEntity<String> approve(@RequestBody Map<String, VoInterface> params) {
		
		log.info("params...="+params);
		
		//Map alarmData1 = (Map) params.get("alarmData1");
		
		VoInterface alarmVO = (alarmVO)params.get("alarmData1");
		
		//alarmVO.setTarget((String)alarmData1.get("target"));
		
		log.info("alarmVO...="+alarmVO);
		
		return new ResponseEntity<>("알림이 입력되었습니다.", HttpStatus.OK) ;
		}*/
	
 	@GetMapping("/userForm")  
	public String userForm(@RequestParam("userId") String userId, Model model) {//관리자가 회원정보가져오기
		
		log.info("admin/userForm");
		
		model.addAttribute("user", adminService.getUserForm(userId));
		
		return "admin/userForm";
	} 
	
	@PreAuthorize("isAuthenticated()") 
 	@GetMapping("/userCashHistory")  
	public String userCashHistory(Criteria cri, Model model) {
		
		log.info("getUserCashHistoryCount");
		
		int total = mypageService.getMyCashHistoryCount(cri.getUserId());
		
		log.info("/userCashHistory");
		
		model.addAttribute("userCashHistory", mypageService.getMyCashHistory(cri));
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userCashHistory"; 
	}
	
	@GetMapping("userReportList")
	public String userReportList(Criteria cri, Model model) {//게시글 댓글 신고
		
		log.info("admin/userReportList");
		log.info(cri);
		
		model.addAttribute("userReportList", adminService.getUserReportList(cri));
		
		int total = adminService.getUserReportCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userReportList"; 
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleStop/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> updateRoleStop(@PathVariable("userId") String userId, @RequestBody alarmVO vo) {
		
		log.info("admin/roleStop");
		log.info("vo"+vo);
		log.info("userId...="+userId);
		
		return adminService.updateRoleStop(userId, vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleLimit/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> updateRoleLimit(@PathVariable("userId") String userId, @RequestBody alarmVO vo) {
	
		log.info("admin/roleLimit");
		log.info("vo"+vo);
		log.info("userId...="+userId);
		
		return adminService.updateRoleLimit(userId, vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleUser/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> updateRoleUser(@PathVariable("userId") String userId , @RequestBody alarmVO vo) {
		
		log.info("admin/roleUser");
		log.info("vo"+vo);
		log.info("userId...="+userId);
		
		return adminService.updateRoleUser(userId, vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH },
			value = "roleAdmin/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> updateRoleAdmin(@PathVariable("userId") String userId, @RequestBody alarmVO vo) {
	
		log.info("admin/roleAdmin");
		log.info("vo"+vo);
		log.info("userId...="+userId);
	
		return adminService.updateRoleAdmin(userId, vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
}
	
