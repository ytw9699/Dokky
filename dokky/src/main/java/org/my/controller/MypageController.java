package org.my.controller;
	import java.io.BufferedWriter;
	import java.io.File;
	import java.io.FileWriter;
	import java.io.IOException;
	import java.util.ArrayList;
	import java.util.Iterator;
	import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.my.domain.AuthVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.PageDTO;
	import org.my.domain.cashVO;
	import org.my.domain.checkVO;
	import org.my.security.domain.CustomUser;
	import org.my.service.BoardService;
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
	import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.multipart.MultipartFile;
	import org.springframework.web.multipart.MultipartHttpServletRequest;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	import lombok.AllArgsConstructor;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	
@Controller
@Log4j
@RequestMapping("/mypage/*")
@AllArgsConstructor
public class MypageController {
	
	@Setter(onMethod_ = @Autowired)
	private MypageService service;
	
	@Setter(onMethod_ = @Autowired)
	private BoardService boardService;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	@Setter(onMethod_ = @Autowired)
	private MemberService memberService;
	
	@PreAuthorize("principal.username == #userId") 
 	@GetMapping("/myInfoForm")  
	public String myInfoForm(@RequestParam("userId") String userId, Model model) { //내 개인정보 변경폼

		log.info("/mypage/myInfoForm");
		
		model.addAttribute("myInfo", service.getMyInfo(userId));
		
		return "mypage/myInfoForm";
	} 
	
	/*@PreAuthorize("principal.username == #vo.userId")
	@PostMapping("/myInfo")
	public String updateMyInfo(MemberVO vo, Model model) {//개인정보 변경하기
		
		log.info("/mypage/myInfo");
		
		if(service.updateMyInfo(vo)) {
			
			model.addAttribute("myInfo", service.getMyInfo(vo.getUserId()));
			model.addAttribute("update", "complete");
			
		}else {
			model.addAttribute("update", "notComplete");
		}
			return "mypage/myInfoForm";
	}*/
	
	@PreAuthorize("principal.username == #memberVO.userId")
	@PostMapping("/myInfo")
	public String updateMyInfo(MemberVO memberVO, Model model, RedirectAttributes rttr) {//개인정보 변경하기
		
		log.info("/mypage/myInfo");
		
		String userId = memberVO.getUserId();
		
		if(service.checkNickname(memberVO.getNickName(),userId)) {//닉네임이 중복된다면
			 
			rttr.addFlashAttribute("update", "overlapped");
			
			return "redirect:/mypage/myInfoForm?userId="+userId;
		}
		
		if(service.updateMyInfo(memberVO)) {
			
			rttr.addFlashAttribute("myInfo", service.getMyInfo(userId));
			
			MemberVO vo = memberService.readMembers(userId);//소셜에서 가져온 프로필에 해당하는 개인정보를 db에서 불러온다
			
			List<AuthVO> AuthList = vo.getAuthList();//사용자의 권한 정보만 list로 가져온다
			
			List<GrantedAuthority> roles = new ArrayList<>(1);// 인증해줄 권한 리스트를 만든다
			
			Iterator<AuthVO> it = AuthList.iterator();
			
			while (it.hasNext()) {
				
				AuthVO authVO = it.next(); 
				
				String auth = authVO.getAuth();
				
				if(auth.equals("ROLE_LIMIT")) {
					rttr.addFlashAttribute("check", "차단된 아이디입니다. 관리자에게 문의해주세요.");
					return "redirect:/socialLogin";
				}
				
				roles.add(new SimpleGrantedAuthority(auth));// 가져온 사용자의 권한을 리스트에 담아준다
	        }
			
			Authentication auth = new UsernamePasswordAuthenticationToken(new CustomUser(vo), null, roles);//사용자의 인증객체를 만든다
			
			SecurityContextHolder.getContext().setAuthentication(auth);//Authentication 인증객체를 SecurityContext에 보관
			
			rttr.addFlashAttribute("update", "complete");
			
		}else {
			rttr.addFlashAttribute("update", "notComplete");
		}
		    
			return "redirect:/mypage/myInfoForm?userId="+userId;
	}
	
	/*@PreAuthorize("isAuthenticated()") 
	@PostMapping(value = "/checkPassword", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> checkPassword(@RequestBody checkVO vo) {//나의 패스워드 체크
		
		log.info("/mypage/checkPassword");
		log.info("checkVO.."+vo);
		
		String getPw = service.getMemberPW(vo.getUserId());
		
		if(!pwencoder.matches(vo.getUserPw(), getPw)) {//비밀번호 일치하지 않는다면
			
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);//404
			
	    }else {
			
	    	return new ResponseEntity<>("success",HttpStatus.OK);//200
	    }
	}*/
	
	@PreAuthorize("isAuthenticated()") 
 	@GetMapping("/rePasswordForm")  
	public String rePasswordForm(@RequestParam("userId") String userId, Model model) { //내 패스워드 변경폼
		
		log.info("/mypage/rePasswordForm");
		
		return "mypage/myRepasswordForm";
	}
	
	@PreAuthorize("isAuthenticated()") 
	@PostMapping("/MyPassword")
	public String updateMyPassword(@RequestParam("userId") String userId, @RequestParam("newPw") String newPw , Model model) {//패스워드 변경
		
		log.info("/mypage/MyPassword");

		String userPw = pwencoder.encode(newPw);//패스워드 암호화
		
		if(service.updateMyPassword(userId,userPw)) {
			model.addAttribute("update", "complete");
			
		}else {
			model.addAttribute("update", "notComplete");
		}
			return "mypage/myRepasswordForm";
	}
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myBoardList") 
	public String myBoardList(Criteria cri, Model model) { //내 게시글 가져오기
		
		model.addAttribute("MyBoard", service.getMyBoardList(cri));
		
		log.info("/mypage/myBoardList");
		
		int total = service.getMyBoardCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
		return "mypage/myBoardList";
	} 
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myReplylist")  
	public String myReplylist(Criteria cri, Model model) {
		
		log.info("/mypage/myReplylist...cri "+cri);
		
		model.addAttribute("myReply", service.getMyReplylist(cri));
		
		int total = service.getMyReplyCount(cri);
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total)); 
		model.addAttribute("total", total);
		
		return "mypage/myReplylist";
	} 
	
	@PostMapping(value = "/scrapData/{board_num}/{userId}", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> insertScrapData(@PathVariable("board_num") int board_num, @PathVariable("userId") String userId ) {
		
		log.info("/mypage/scrapData");
		log.info("board_num="+board_num+", userId="+userId);
		
		if(service.getScrapCnt(board_num, userId) == 1 && service.deleteScrap(board_num, userId) == 1) {//스크랩 카운트가 1이라면 스크랩한거고,스크랩 삭제
		
			return new ResponseEntity<>("cancel",HttpStatus.OK);
		}
		
		log.info("insertScrapData...board_num="+board_num+", userId="+userId);
		
		if(service.insertScrapData(board_num, userId)) {
			
			return new ResponseEntity<>("success",HttpStatus.OK);
		}
		
		return new ResponseEntity<>("fail",HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myScraplist")  
	public String myScraplist(Criteria cri, Model model) { //내 스크랩 글 가져오기
		
		log.info("/mypage/myScraplist");
		log.info("myScraplist "+cri);
		
		int total = service.getMyScrapCount(cri.getUserId());//total은 내 스크랩 총 게시물수
		
		model.addAttribute("myScraplist", service.getMyScraplist(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
		return "mypage/myScraplist";
	} 
	
	 @PreAuthorize("principal.username == #userId")  
	 @PostMapping("/removeAllScrap")//다중삭제
		public String removeAllScrap(@RequestParam("checkRow") String checkRow , @RequestParam("userId")String userId, Criteria cri) {
		 
		log.info("/mypage/removeAllScrap");
		log.info("checkRow..." + checkRow);
	 	
	 	String[] arrIdx = checkRow.split(",");
	 	
	 	for (int i=0; i<arrIdx.length; i++) {
	 		
	 		Long scrap_num = Long.parseLong(arrIdx[i]);  
	 		
	 		log.info("remove...reply_num=" + scrap_num);
	 		
	 		service.removeAllScrap(scrap_num);
	 	}
	 return "redirect:/mypage/myScraplist?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
	}
	
	@PreAuthorize("principal.username == #userId")  
 	@GetMapping("/myCashInfo")  
	public String myCashInfo(@RequestParam("userId") String userId, Model model) { //내 캐시정보
		
		log.info("/mypage/myCashInfo");
		
		String userCash = boardService.getuserCash(userId);
		
		log.info("getuserCash...="+userCash);
		
		model.addAttribute("userCash", userCash);
		
		return "mypage/myCashInfo";
	}
	
	@PreAuthorize("principal.username == #userId")  
 	@GetMapping("/myWithdrawalForm")  
	public String myWithdrawalForm(@RequestParam("userId") String userId) { //탈퇴 하기 폼 가져오기
		
		log.info("/mypage/myWithdrawalForm");
		
		return "mypage/myWithdrawalForm";
	}
	
	@PreAuthorize("principal.username == #userId")  
	@PostMapping("/myWithdrawal")  
	public String myWithdrawal(@RequestParam("userId") String userId, Model model,
		HttpServletRequest request, HttpServletResponse response, Authentication authentication) {//탈퇴 하기 메소드
		
		log.info("/mypage/myWithdrawal");
		
		if(service.myWithdrawal(userId)) {//db에서 회원탈퇴 처리가 되었다면 로그아웃 처리 하기
			
			log.info("/logout");
			
			if(authentication != null) {
				SecurityContextHolder.getContext().setAuthentication(null);
			}
			
			request.getSession().invalidate();

			Cookie JSESSIONID = new Cookie("JSESSIONID", null);

			JSESSIONID.setMaxAge(0);

			response.addCookie(JSESSIONID);
			
			return "redirect:/socialLogin";
			
		}else {
			
			model.addAttribute("message", "탈퇴 불가 합니다 관리자에게 문의해주세요");
			
			return "error/commonError";
		}
	}
	
	@PostMapping(value = "/chargeData", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> chargeData(@RequestBody cashVO vo) {//캐시 충전하기
		
		log.info("/mypage/chargeData");
		
		if(service.insertChargeData(vo)) {
			
			log.info("insertChargeData...success "+vo);
			
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			log.info("insertChargeData...fail "+vo);
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@PostMapping(value = "/reChargeData", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> reChargeData(@RequestBody cashVO vo) {//캐시 환전하기
		
		log.info("/mypage/reChargeData");
		
		if(service.insertReChargeData(vo)) {
			
			log.info("insertReChargeData...success "+vo);
			
			return new ResponseEntity<>("success", HttpStatus.OK);
		}
			log.info("insertReChargeData...fail "+vo);
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myCashHistory")  
	public String myCashHistory(Criteria cri, Model model) { //내 캐시 내역
		
		log.info("/mypage/myCashHistory");
		
		int total = service.getMyCashHistoryCount(cri.getUserId());
		
		model.addAttribute("myCashHistory", service.getMyCashHistory(cri));
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "mypage/myCashHistory"; 
	}
	
	@PostMapping(value = "/profileFile")//
	public String registerProfileFile(MultipartHttpServletRequest request) throws IOException { //프로필 이미지 올리기
		
		log.info("/mypage/profileFile"); 
		
		//String uploadPath =request.getSession().getServletContext().getRealPath("/")+File.separator+"resources/img/profile_img";
		String uploadPath ="/var/lib/tomcat9/webapps/upload"; 
		//String uploadPath ="/home/ubuntu/upload"; 
		
		log.info("uploadPath"+uploadPath);
		
		String userId = request.getParameter("userId");
		
		MultipartFile profileFile = request.getFile("profileFile");
		 
		File uploadFile = new File(uploadPath , userId+".png");  
		
		//uploadFile.setExecutable(true, true);
		//uploadFile.setExecutable(true, true);
		
		try {
			profileFile.transferTo(uploadFile);
		} catch (Exception e) {
			e.getStackTrace();
		}
		
		//Runtime.getRuntime().exec("chmod -R 755 " + "/var/lib/tomcat9/webapps/ROOT/resources/img/profile_img");
		Runtime.getRuntime().exec("chmod -R 777 " + "/var/lib/tomcat9/webapps/upload");
		//Runtime.getRuntime().exec("chmod -R 777 " + "/home/ubuntu/upload/");
        
		return "redirect:/mypage/myInfoForm?userId="+userId;
	}
	
	@PostMapping(value = "/deleteProfile") 
	public String deleteProfile(MultipartHttpServletRequest request){//기본 이미지 파일로 변경은 기존 파일 삭제로 구현
		
		log.info("/mypage/deleteProfile"); 
		
		//String uploadPath =request.getSession().getServletContext().getRealPath("/")+File.separator+"resources/img/profile_img/";
		String uploadPath ="/var/lib/tomcat9/webapps/upload/";
		//String uploadPath ="/home/ubuntu/upload/";
		String userId = request.getParameter("userId");
		
		try {
			  File file = new File(uploadPath+userId+".png");
			  
			   if( file.exists() ){
				   file.delete();
			   }
			   
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/mypage/myInfoForm?userId="+userId;
	}
}
