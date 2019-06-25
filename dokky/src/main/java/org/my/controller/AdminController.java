package org.my.controller;
	//import org.springframework.security.access.annotation.Secured;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
	import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/admin/*")
@AllArgsConstructor
public class AdminController {

	//private AdminService service;
	//@Secured({"ROLE_ADMIN"})//아래와 같은거
	@PreAuthorize("hasRole('ROLE_ADMIN')") //관리자권한이있어야함
	@GetMapping("main")
	public String admin() {
		
		log.info("admin/main");
		
		return "main";
	}
}
