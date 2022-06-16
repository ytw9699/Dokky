/*
- 마지막 업데이트 2022-06-13
*/
package org.my.controller;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.domain.AlarmVO;
	import org.my.domain.CommonVO;
	import org.my.service.AdminService;
	import org.my.service.MypageService;
	import org.springframework.http.HttpStatus;
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
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequiredArgsConstructor
public class AdminController {
	
	private final AdminService adminService;
	private final MypageService mypageService;
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/admin/userList")
	public String userList(Criteria cri, Model model) {
	    
		log.info("/admin/userList");
		log.info("cri"+cri);
		
		model.addAttribute("userList", adminService.getUserList(cri));
		
		int total = adminService.getMemberTotalCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userList"; 
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/admin/cashRequestList")
	public String cashRequestList(Criteria cri, Model model) {
		
		log.info("admin/cashRequestList");
		log.info(cri);
		
		model.addAttribute("cashRequestList", adminService.getCashRequestList(cri));
		
		int total = adminService.getCashListTotalCount();
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/cashRequestList"; 
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/admin/userReportList")
	public String userReportList(Criteria cri, Model model) {
		
		log.info("admin/userReportList");
		log.info(cri);
		
		model.addAttribute("userReportList", adminService.getUserReportList(cri));
		
		int total = adminService.getUserReportCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userReportList"; 
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/admin/userForm")
	public String userForm(@RequestParam("userId") String userId, Model model) {
		
		log.info("admin/userForm");
		
		model.addAttribute("user", adminService.getUserForm(userId));
		
		return "admin/userForm";
	} 
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping(value = "/admin/limitLogin/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> limitLogin(@PathVariable("userId") String userId, @RequestBody AlarmVO vo) {
	
		log.info("admin/limitLogin");
		log.info("userId...="+userId);
		log.info("vo"+vo);
		
		return adminService.limitLogin(userId, vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping(value = "/admin/permitLogin/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> permitLogin(@PathVariable("userId") String userId , @RequestBody AlarmVO vo) {
	
		log.info("admin/permitLogin");
		log.info("userId...="+userId);
		log.info("vo"+vo);
	
		return adminService.permitLogin(userId, vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
			: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping(value = "/admin/createRoleUser/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> createRoleUser(@PathVariable("userId") String userId, @RequestBody AlarmVO vo) {
		
		return adminService.insertRole(userId, "ROLE_USER", vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@PostMapping(value = "/admin/deleteRoleUser/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> deleteRoleUser(@PathVariable("userId") String userId, @RequestBody AlarmVO vo) {
		
		return adminService.deleteRole(userId, "ROLE_USER", vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_SUPER')")
	@PostMapping(value = "superAdmin/createRoleAdmin/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> createRoleAdmin(@PathVariable("userId") String userId, @RequestBody AlarmVO vo) {
		
		return adminService.insertRole(userId, "ROLE_ADMIN", vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_SUPER')")
	@PostMapping(value = "superAdmin/deleteRoleAdmin/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> deleteRoleAdmin(@PathVariable("userId") String userId, @RequestBody AlarmVO vo) {
		
		return adminService.deleteRole(userId, "ROLE_ADMIN", vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
 	@GetMapping("/admin/userCashHistory") 
	public String userCashHistory(Criteria cri, Model model) {
		
		log.info("/userCashHistory");
		
		model.addAttribute("userCashHistory", mypageService.getMyCashHistory(cri));
		
		int total = mypageService.getMyCashHistoryCount(cri.getUserId());
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "admin/userCashHistory"; 
	}
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, 
					value = "/admin/approveCash", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> approveCash(@RequestBody CommonVO vo){
		
		log.info("/approveCash");
		log.info("CommonVO...="+vo);
		
		return adminService.approveCash(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
	
