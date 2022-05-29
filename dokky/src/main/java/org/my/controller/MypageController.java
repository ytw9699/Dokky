package org.my.controller;
	import java.io.File;
	import java.io.IOException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.PageDTO;
	import org.my.domain.cashVO;
	import org.my.domain.checkPwVO;
	import org.my.service.AdminService;
	import org.my.service.BoardService;
	import org.my.service.CommonService;
	import org.my.service.MemberService;
	import org.my.service.MypageService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.multipart.MultipartFile;
	import org.springframework.web.multipart.MultipartHttpServletRequest;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;
	
@Controller
@Log4j
@RequestMapping("/mypage/*")
@RequiredArgsConstructor
public class MypageController {
	
	private final MypageService mypageService;
	private final AdminService adminService;
	private final CommonService commonService;
	private final MemberService memberService;
	private final BoardService boardService;
	private final BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@PreAuthorize("principal.username == #userId") 
 	@GetMapping("/myInfoForm")  //내 개인정보 변경폼
	public String myInfoForm(@RequestParam("userId") String userId, Model model) { 

		log.info("/mypage/myInfoForm");
		
		model.addAttribute("myInfo", adminService.getUserForm(userId));
		
		return "mypage/myInfoForm";
	} 
	
	@PreAuthorize("principal.username == #memberVO.userId")
	@PostMapping("/myInfo")
	public String updateMyInfo(MemberVO memberVO, RedirectAttributes rttr) {//내 개인정보 변경하기
		
		log.info("/mypage/myInfo");
		
		String userId = memberVO.getUserId();
		
		if(mypageService.updateMyInfo(memberVO)) {
			
			rttr.addFlashAttribute("myInfo", mypageService.getMyInfo(userId));//내정보 한줄 가져오기
			
			MemberVO authMemberVO = memberService.readMembers(userId);
			
			if(commonService.setAuthentication(authMemberVO) == false){//다시 인증 처리
				rttr.addFlashAttribute("errormsg", "다시 로그인 해주세요."); 
				return "redirect:/commonLogin";
			}
			
			rttr.addFlashAttribute("update", "complete");
			
		}else {
			
			rttr.addFlashAttribute("update", "notComplete");
		}
		    
			return "redirect:/mypage/myInfoForm?userId="+userId;
	}
	
	@PreAuthorize("principal.username == #userId") 
	@PostMapping(value = "/profileFile")//프로필 이미지 올리기
	public String registerProfileFile(MultipartHttpServletRequest request, @RequestParam("userId") String userId, 
												@RequestParam("serverName") String serverName ) throws IOException { 
		
		log.info("/mypage/profileFile"); 
		
		String uploadPath;
		
		if(serverName.equals("localhost")){//로컬의 경우
			
			uploadPath =request.getSession().getServletContext().getRealPath("/")+File.separator+"resources/img/profile_img";
			
		}else{//EC2 우분투의 경우
			
			uploadPath ="/var/lib/tomcat9/webapps/upload";
			//String uploadPath ="/home/ubuntu/upload"; 
		}	
		
		log.info("uploadPath"+uploadPath);
		
		MultipartFile profileFile = request.getFile("profileFile");
		 
		File uploadFile = new File(uploadPath , userId+".png");  
		
		//uploadFile.setExecutable(true, true);
		
		try {
			profileFile.transferTo(uploadFile);
		} catch (Exception e) {
			e.getStackTrace();
		}
		
		if(!serverName.equals("localhost")){//EC2 우분투의 경우
			
			Runtime.getRuntime().exec("chmod -R 777 " + "/var/lib/tomcat9/webapps/upload");//파일 접근 위해
			//Runtime.getRuntime().exec("chmod -R 777 " + "/home/ubuntu/upload/");
		}
        
		return "redirect:/mypage/myInfoForm?userId="+userId;
	}
	
	@PreAuthorize("principal.username == #userId")
	@PostMapping(value = "/deleteProfile") 
	public String deleteProfileFile(MultipartHttpServletRequest request, @RequestParam("userId") String userId, 
			@RequestParam("serverName") String serverName){//기본 이미지 파일로 변경은 기존 파일 삭제로 구현
		
		log.info("/mypage/deleteProfile"); 
		
		String uploadPath;
		
		if(serverName.equals("localhost")){//로컬의 경우
			
			uploadPath =request.getSession().getServletContext().getRealPath("/")+File.separator+"resources/img/profile_img";
			
		}else{//EC2 우분투의 경우
			
			uploadPath ="/var/lib/tomcat9/webapps/upload";
			//String uploadPath ="/home/ubuntu/upload";
		}
		
		try {
			  File file = new File(uploadPath, userId+".png");
			  
			   if( file.exists() ){
				   file.delete();
			   }
			   
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/mypage/myInfoForm?userId="+userId;
	}
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myBoardList") 
	public String myBoardList(Criteria cri, Model model) { //내 게시글 가져오기
		
		model.addAttribute("MyBoard", mypageService.getMyBoardList(cri));
		
		log.info("/mypage/myBoardList");
		
		int total = mypageService.getMyBoardCount(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
		return "mypage/myBoardList";
	} 
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myReplylist")  
	public String myReplylist(Criteria cri, Model model) {//내 댓글 가져오기
		
		log.info("/mypage/myReplylist...cri "+cri);
		
		model.addAttribute("myReply", mypageService.getMyReplylist(cri));
		
		int total = mypageService.getMyReplyCount(cri);
		
		log.info("pageMaker");
		
		model.addAttribute("pageMaker", new PageDTO(cri, total)); 
		model.addAttribute("total", total);
		
		return "mypage/myReplylist";
	} 
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myScraplist")  
	public String myScraplist(Criteria cri, Model model) { //내 스크랩 글 가져오기
		
		log.info("/mypage/myScraplist");
		log.info("myScraplist "+cri);
		
		int total = mypageService.getMyScrapCount(cri.getUserId());
		
		model.addAttribute("myScraplist", mypageService.getMyScraplist(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
		return "mypage/myScraplist";
	} 
	
	@PreAuthorize("principal.username == #userId")  
	@PostMapping("/removeAllScrap")//스크랩 다중삭제
	public String removeAllScrap(@RequestParam("checkRow") String checkRow , @RequestParam("userId") String userId, Criteria cri) {
		 
		log.info("/mypage/removeAllScrap");
		log.info("checkRow..." + checkRow);
	 	
	 	String[] arrIdx = checkRow.split(",");
	 	
	    for (int i=0; i<arrIdx.length; i++) {
	 		
	 		Long scrap_num = Long.parseLong(arrIdx[i]);  
	 		
	 		log.info("remove...reply_num=" + scrap_num);
	 		
	 		mypageService.removeScrap(scrap_num);
	 	}
	 	
	 	return "redirect:/mypage/myScraplist?userId="+userId+"&pageNum="+cri.getPageNum()+"&amount="+cri.getAmount();
	}
	
	@PreAuthorize("principal.username == #userId")  
 	@GetMapping("/myCashInfo")  
	public String myCashInfo(@RequestParam("userId") String userId, Model model) { //내 캐시정보
		
		log.info("/mypage/myCashInfo");
		
		String myCash = boardService.getMyCash(userId);//나의 잔여캐시 가져오기
		
		if(myCash == null) {

			return "redirect:/serverError";

		}else{
			
			model.addAttribute("myCash", myCash);
			
			return "mypage/myCashInfo";
		}
	}
	
	@PreAuthorize("principal.username == #vo.userId")  
	@PostMapping(value = "/chargeData", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> chargeData(@RequestBody cashVO vo) {//캐시 충전 요청 하기
		
		log.info("/mypage/chargeData");
		
		if(mypageService.insertChargeData(vo)) {
			
			log.info("insertChargeData...success..vo = "+vo);
			
			return new ResponseEntity<>("success", HttpStatus.OK);
		
		}else{

			log.info("insertChargeData...fail..vo = "+vo);
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
		}
	}
	
	@PreAuthorize("principal.username == #vo.userId")  
	@PostMapping(value = "/reChargeData", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> reChargeData(@RequestBody cashVO vo) {//캐시 환전 요청 하기
		
		log.info("/mypage/reChargeData");
		
		if(mypageService.insertReChargeData(vo)) {
			
			log.info("insertReChargeData...success..vo = "+vo);
			
			return new ResponseEntity<>("success", HttpStatus.OK);
			
		}else{
			
			log.info("insertReChargeData...fail..vo ="+vo);
			
			return new ResponseEntity<>("fail", HttpStatus.OK);
		}
	}
	
	@PreAuthorize("principal.username == #cri.userId")
 	@GetMapping("/myCashHistory")  
	public String myCashHistory(Criteria cri, Model model) { //내 캐시 내역 리스트
		
		log.info("/mypage/myCashHistory");
		
		int total = mypageService.getMyCashHistoryCount(cri.getUserId());
		
		model.addAttribute("myCashHistory", mypageService.getMyCashHistory(cri));
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		return "mypage/myCashHistory"; 
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
			
			if(mypageService.myWithdrawal(userId)) {//db에서 회원탈퇴 처리가 되었다면 로그아웃 처리 하기
				
					commonService.logout(request, response, authentication);
					
					log.info("/logout");
					
					return "redirect:/commonLogin";
				
			}else {
				
					model.addAttribute("message", "탈퇴 불가 합니다 관리자에게 문의해주세요");
					
					return "error/commonError";
			}
	}
	
	@PreAuthorize("principal.username == #userId and hasRole('ROLE_SUPER')")
 	@GetMapping("/rePasswordForm")//슈퍼관리자의 경우만 패스워드 변경폼을 가져올 수 있다.
	public String rePasswordForm(@RequestParam("userId") String userId) {
		
		log.info("/mypage/rePasswordForm");
		
		return "mypage/myRepasswordForm";
	}
	
	@PreAuthorize("principal.username == #vo.userId and hasRole('ROLE_SUPER')")
	@PostMapping(value = "/checkPassword", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> checkPassword(@RequestBody checkPwVO vo) {
		
		log.info("/mypage/checkPassword");
		log.info("checkPwVO = "+vo);
		
		String myPassword = mypageService.getMemberPW(vo.getUserId());
		
		if(myPassword == null) {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			
		}else {
			
			if(!bcryptPasswordEncoder.matches(vo.getUserPw(), myPassword)) {
				
				return new ResponseEntity<>("fail", HttpStatus.OK);
				
		    }else{
				
		    	return new ResponseEntity<>("success", HttpStatus.OK);
		    }
		}
	}
	
	@PreAuthorize("principal.username == #vo.userId and hasRole('ROLE_SUPER')")
	@PostMapping(value = "/changeMyPassword", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> changeMyPassword(@RequestBody checkPwVO vo) {
		
		log.info("/mypage/changeMyPassword");

		String encodedPw = bcryptPasswordEncoder.encode(vo.getUserPw());
		
		if(encodedPw == null) {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			
		}else {
			
			if(mypageService.changeMyPassword(vo.getUserId(), encodedPw)){
				
				return new ResponseEntity<>(HttpStatus.OK);
				
			}else {
				
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
	}
}
