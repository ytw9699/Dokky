
/*import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Random;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.my.auth.SNSLogin;
import org.my.auth.SnsValue;
import org.my.domain.common.AuthVO;
import org.my.domain.common.Criteria;
import org.my.domain.common.MemberVO;
import org.my.domain.common.PageDTO;
import org.my.domain.common.CashVO;
import org.my.domain.common.NoteVO;
import org.my.domain.common.CustomUser;
import org.my.service.AdminService;
import org.my.service.CommonService;
import org.my.service.MemberService;
import org.my.service.MypageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
*/
	
	/*@GetMapping("/adminLogin")
	public String adminLogin(Model model, HttpServletRequest request, String error, String logout, String check){
		
		log.info("/adminLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		if(!request.isUserInRole("ROLE_ADMIN")) {//관리자가 아니라면 관리자 로그인 페이지로
			
			if (error != null) {
				model.addAttribute("error", "Login Error Check Your Account");
			}
			if (logout != null) {
				model.addAttribute("logout", "Logout!!");
			}
			if (check != null) {
				if(check.equals("notId") ) {
					model.addAttribute("check", "아이디가 없습니다.");
				}else if(check.equals("notPassword") ) {
					model.addAttribute("check", "비밀번호가 틀립니다.");
				}
				else if(check.equals("limit") ) {
					model.addAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요.");
				}
			}
			
			return "common/adminLogin";  
		}

		return "redirect:/admin/userList";//관리자라면 관리자 페이지로
	}*/
	
	
	/*@GetMapping("/superAdminLogin")
    public String superAdminLogin(Model model, HttpServletRequest request, String error, String logout, String check,Authentication authentication) throws UnsupportedEncodingException {
    	
		log.info("/superAdminLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		
		if(authentication != null) {
			log.info("authentication"+SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		}
		
		  Enumeration<String> e = request.getSession().getAttributeNames();
		    
		    while(e.hasMoreElements()){
		    	log.info("Enumeration7="+e.nextElement());
		    }
		    
		    Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
		    
		    log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		    
		
		if (error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		if (logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
		if (check != null) {
			if(check.equals("notId") ) {
				model.addAttribute("check", "아이디가 없습니다.");
			}else if(check.equals("notPassword") ) {
				model.addAttribute("check", "비밀번호가 틀립니다.");
			}
			else if(check.equals("limit") ) {
				model.addAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요.");
			}
		}
		
		return "common/superAdminLogin";  
	}*/
    
	
	
	/*@GetMapping("/socialLogin")//커스톰 로그인 페이지는 반드시 get방식 이여야한다.시큐리티의 특성임
	public String loginInput(String error, String logout, String check, Model model,HttpServletRequest request, Authentication authentication) throws UnsupportedEncodingException {
		
		log.info("/socialLogin");
		 
		if(authentication != null) {
			log.info("authentication"+SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		}
		
        Enumeration<String> e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration7="+e.nextElement());
        }
        
        Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
        
		//소셜로그인
		SNSLogin naverLogin = new SNSLogin(naverSns);
		
		model.addAttribute("naver_url", naverLogin.getAuthURL());//네이버 로그인 url가져오기
		
		SNSLogin googleLogin = new SNSLogin(googleSns);
		
		model.addAttribute("google_url", googleLogin.getAuthURL());//구글 로그인 url가져오기
		
		return "common/socialLogin";  
	}*/
	
	
	
	/*@PostMapping("/logout")//사용자 직접구현 로그아웃
	public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication, HttpSession session) {
		
		log.info("/logout1");
		log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		
		Enumeration<String> e = session.getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration1="+e.nextElement());
        }
        
        e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration2="+e.nextElement());
        }
        
        Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		
		//request.getSession().invalidate();
        //log.info("getId1"+request.getSession().getId());
        
        //session.setMaxInactiveInterval(0);

		//session.invalidate();
		
		e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration3="+e.nextElement());
        }
        
		log.info("/logout2");

		Cookie JSESSIONID = new Cookie("JSESSIONID", null);

		JSESSIONID.setMaxAge(0);

		response.addCookie(JSESSIONID);
		
		// 쿠키 삭제
		
		if(authentication != null) { 
			SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
			
		}
		
		log.info("/logout3");
		
		if(authentication != null) {
			log.info("/logout4");
			//SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
			log.info("/logout5");
			if(SecurityContextHolder.getContext().getAuthentication() != null) {
				log.info("/logout6");
				log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
			}else {
			log.info("/logout7");
			log.info(SecurityContextHolder.getContext().getAuthentication());
			}
		}
		SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		log.info("/logout8");
		
		e = session.getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration3="+e.nextElement());
        }
        
        e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration4="+e.nextElement());
        }
         
         SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
         
         log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
         log.info("/logout9");
         
         //log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
         
		return "redirect:/socialLogin";
	}*/

/*@GetMapping(value = "/idCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getIdCheckedVal(String inputId) {
		
		log.info("/idCheckedVal"); 
		
		if(commonService.getIdCheckedVal(inputId)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}*/
	
	/*@GetMapping("/adminMemberForm")
	public String adminMemberForm() {

		log.info("admin/adminMemberForm");
		
		return "common/adminMemberForm";
	}
	
	@PostMapping("/adminMembers") 
	public String postAdminMembers(MemberVO vo, Model model) {//회원가입
		
		log.info("/members: vo" + vo); 
		
		vo.setUserPw(pwencoder.encode(vo.getUserPw()));//패스워드 암호화
		
		if(memberService.registerMembers(vo)){
			
			model.addAttribute("check", "가입완료 되었습니다 로그인해주세요.");
			
			return "common/superAdminLogin";
		}
		
			model.addAttribute("check", "가입실패 하였습니다 관리자에게 문의주세요.");
			
			return "common/superAdminLogin"; 
	}
	
	@GetMapping(value = "/emailCheckedVal", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> getEmailCheckedVal(String inputEmail) {
		 
		log.info("/emailCheckedVal"); 
		
		if(memberService.getEmailCheckedVal(inputEmail)){
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	*/
	
	/*@GetMapping("/adminLogin")
	public String adminLogin(Model model, HttpServletRequest request, String error, String logout, String check){
		
		log.info("/adminLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		if(!request.isUserInRole("ROLE_ADMIN")) {//관리자가 아니라면 관리자 로그인 페이지로
			
			if (error != null) {
				model.addAttribute("error", "Login Error Check Your Account");
			}
			if (logout != null) {
				model.addAttribute("logout", "Logout!!");
			}
			if (check != null) {
				if(check.equals("notId") ) {
					model.addAttribute("check", "아이디가 없습니다.");
				}else if(check.equals("notPassword") ) {
					model.addAttribute("check", "비밀번호가 틀립니다.");
				}
				else if(check.equals("limit") ) {
					model.addAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요.");
				}
			}
			
			return "common/adminLogin";  
		}

		return "redirect:/admin/userList";//관리자라면 관리자 페이지로
	}*/
	
	/*@GetMapping("/superAdminLogin")
    public String superAdminLogin(Model model, HttpServletRequest request, String error, String logout, String check,Authentication authentication) throws UnsupportedEncodingException {
    	
		log.info("/superAdminLogin");
		log.info("error: " + error);
		log.info("logout: " + logout);
		log.info("check: " + check);
		
		
		if(authentication != null) {
			log.info("authentication"+SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		}
		
		  Enumeration<String> e = request.getSession().getAttributeNames();
		    
		    while(e.hasMoreElements()){
		    	log.info("Enumeration7="+e.nextElement());
		    }
		    
		    Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
		    
		    log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		    
		
		if (error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		if (logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
		if (check != null) {
			if(check.equals("notId") ) {
				model.addAttribute("check", "아이디가 없습니다.");
			}else if(check.equals("notPassword") ) {
				model.addAttribute("check", "비밀번호가 틀립니다.");
			}
			else if(check.equals("limit") ) {
				model.addAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요.");
			}
		}
		
		return "common/superAdminLogin";  
	}*/
    
	/*@GetMapping("/socialLogin")//커스톰 로그인 페이지는 반드시 get방식 이여야한다.시큐리티의 특성임
	public String loginInput(String error, String logout, String check, Model model,HttpServletRequest request, Authentication authentication) throws UnsupportedEncodingException {
		
		log.info("/socialLogin");
		 
		if(authentication != null) {
			log.info("authentication"+SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		}
		
        Enumeration<String> e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration7="+e.nextElement());
        }
        
        Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
        
		//소셜로그인
		SNSLogin naverLogin = new SNSLogin(naverSns);
		
		model.addAttribute("naver_url", naverLogin.getAuthURL());//네이버 로그인 url가져오기
		
		SNSLogin googleLogin = new SNSLogin(googleSns);
		
		model.addAttribute("google_url", googleLogin.getAuthURL());//구글 로그인 url가져오기
		
		return "common/socialLogin";  
	}*/
	
	/*@PostMapping("/logout")//사용자 직접구현 로그아웃
	public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication, HttpSession session) {
		
		log.info("/logout1");
		log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
		
		Enumeration<String> e = session.getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration1="+e.nextElement());
        }
        
        e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration2="+e.nextElement());
        }
        
        Object SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		
		//request.getSession().invalidate();
        //log.info("getId1"+request.getSession().getId());
        
        //session.setMaxInactiveInterval(0);

		//session.invalidate();
		
		e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration3="+e.nextElement());
        }
        
		log.info("/logout2");

		Cookie JSESSIONID = new Cookie("JSESSIONID", null);

		JSESSIONID.setMaxAge(0);

		response.addCookie(JSESSIONID);
		
		// 쿠키 삭제
		
		if(authentication != null) { 
			SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
			
		}
		
		log.info("/logout3");
		
		if(authentication != null) {
			log.info("/logout4");
			//SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
			log.info("/logout5");
			if(SecurityContextHolder.getContext().getAuthentication() != null) {
				log.info("/logout6");
				log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
			}else {
			log.info("/logout7");
			log.info(SecurityContextHolder.getContext().getAuthentication());
			}
		}
		SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
        
        log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
		log.info("/logout8");
		
		e = session.getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration3="+e.nextElement());
        }
        
        e = request.getSession().getAttributeNames();
        
        while(e.hasMoreElements()){
        	log.info("Enumeration4="+e.nextElement());
        }
         
         SPRING_SECURITY_CONTEXT = request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
         
         log.info("SPRING_SECURITY_CONTEXT" +SPRING_SECURITY_CONTEXT);
         log.info("/logout9");
         
         //log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
         
		return "redirect:/socialLogin";
	}*/

		
		 	