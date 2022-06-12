package org.my.controller;
	import java.io.IOException;
	import java.util.Date;
	import java.util.List;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMemberVO;
	import org.my.domain.ChatMessage;
	import org.my.domain.ChatMessageType;
	import org.my.domain.ChatReadVO;
	import org.my.domain.ChatRoom;
	import org.my.domain.ChatRoomVO;
	import org.my.domain.MemberVO;
	import org.my.domain.chatRoomDTO;
	import org.my.domain.commonVO;
	import org.my.security.domain.CustomUser;
	import org.my.service.ChatService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.security.core.Authentication;
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

@Log4j
@RequiredArgsConstructor
@Controller
public class ChatController {
	
	private final ChatService chatService;
	
	@PreAuthorize("principal.username == #vo.chatRoomVO.roomOwnerId")
	@ResponseBody
	@PostMapping(value = "/createSingleChat", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> createSingleChat(@RequestBody commonVO vo) throws IOException{

		 log.info("/createSingleChat");
		 log.info("vo : " + vo);
		 
		 String myId = vo.getChatRoomVO().getRoomOwnerId();
		 
		 String chatRoomNum = chatService.hasRoom(myId, vo.getChatMemberVO().getChat_memberId());
		 					  
		 if(chatRoomNum != null){
	        
			 if(chatService.getMyRoomStatus(Long.parseLong(chatRoomNum), myId)){//내가 방에서 나가있었다면
				 
				  chatService.updateRoomStatus(Long.parseLong(chatRoomNum), myId, 1 , 0);
				  //headcount와 현재 위치를 방에 들어감으로 변경
				  
				  ChatRoom chatRoom = chatService.findChatRoom(chatRoomNum);
				  
				  ChatMessage chatMessage = new ChatMessage();
		          
		          String message = vo.getChatRoomVO().getRoomOwnerNick()+"님이 들어왔습니다";
		          
	              chatMessage.setMessage(message);
	              chatMessage.setRegDate(new Date());
	              chatMessage.setType(ChatMessageType.IN);
	              
	              chatRoom.reEnterChatRoom(chatMessage);
	            	
	              ChatContentVO chatContentVO = new ChatContentVO();
	            	
	              chatContentVO.setChatRoomNum(Long.parseLong(chatRoomNum));
	              chatContentVO.setChat_content(message);
	              chatContentVO.setRegDate(chatMessage.getRegDate());
	            	
	              chatService.createNoticeContent(chatContentVO);
			 }
			 
			 return new ResponseEntity<>(chatRoomNum, HttpStatus.OK);
		
		 }else{
		
			 boolean makeResult = chatService.createSingleChat(vo.getChatRoomVO(), vo.getChatMemberVO());
			
			 return makeResult == true  
					? new ResponseEntity<>(vo.getChatRoomVO().getChatRoomNum().toString(), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		 }
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@PostMapping(value = "/createMultiChat", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> createMultiChat(@RequestBody commonVO vo) throws IOException{
		
		log.info("/createMultiChat");
		log.info(vo);
		
		boolean makeResult = chatService.createMultiChat(vo.getChatRoomVO(), vo.getChatMemberVoArray());
		
		return makeResult == true  
					? new ResponseEntity<>(vo.getChatRoomVO().getChatRoomNum().toString(), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #userId")
	@GetMapping("/chatRoom/{chatRoomNum}")
	public String getChatRoom(@PathVariable Long chatRoomNum, @RequestParam("userId")String userId, Model model){
	    	
		log.info("/chatRoom/"+chatRoomNum);
		
		boolean result = chatService.getInChatMember(chatRoomNum, userId);
		
		if(result == true){//채팅방의 멤버가 아니라면
			
			model.addAttribute("message", "채팅방에 입장할 수 없는 경로입니다.");
			
			return "error/commonError";
		}
		
		Date recentOutDate = chatService.getRecentOutDate(chatRoomNum, userId);
		
		model.addAttribute("chatContents", chatService.getChatContents(chatRoomNum, recentOutDate, userId));
		
		int chat_type = chatService.getChat_type(chatRoomNum);
		
		if(chat_type == 0){//1:1채팅방의 경우
			
			model.addAttribute("chatMember", chatService.getChatMember(chatRoomNum, userId));//채팅방의 제목에 들어갈 상대방 정보
			
		}else if(chat_type == 1) {//멀티채팅방의 경우
			
			model.addAttribute("chatTitleInfo", chatService.getChatTitleInfo(chatRoomNum));//멀티 채팅방의 제목,방장 아이디,닉네임
			model.addAttribute("chatMembers", chatService.getChatRoomMembers(chatRoomNum));//멀티 채팅방의 멤버들 아이디,닉네임
		}
		
		model.addAttribute("chatRoomNum", chatRoomNum);
		model.addAttribute("headCount", chatService.getHeadCount(chatRoomNum));
		model.addAttribute("chat_type", chat_type);
		
		return "chat/chatRoom";
	}
	 
	@PreAuthorize("principal.username == #userId")
	@GetMapping("/myChatRoomList")
	public String getMyChatRoomList(Model model, String userId){
		
		log.info("/myChatRoomList");
		
		List<chatRoomDTO> chatRoomList = chatService.getMyChatRoomList(userId);
		
		model.addAttribute("chatRoomList", chatRoomList);
		
		return "chat/chatRoomList";
	} 
	
	@PreAuthorize("principal.username == #userId")
	@ResponseBody
	@GetMapping(value = "/getChatRoomList", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<List<chatRoomDTO>> getChatRoomList(Model model, String userId){
    	
		log.info("/getChatRoomList");
    	
		List<chatRoomDTO> chatRoomList = chatService.getMyChatRoomList(userId);
		
		if(chatRoomList != null) {
			
			return new ResponseEntity<>(chatRoomList, HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	} 
	
	@PreAuthorize("principal.username == #vo.chat_memberId")
	@ResponseBody
	@PostMapping(value = "/readChat", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> readChat(@RequestBody ChatReadVO vo) {

		log.info("/readChat");
		
		int result = chatService.readChat(vo);
		
		if(result == 0) {//읽지 않았는데, 디비에서 읽음 처리를 했을때
			
			return new ResponseEntity<>("0", HttpStatus.OK);
					
		}else if(result == 1){//이미 디비에서 읽음 처리가 되었을때
			
			return new ResponseEntity<>("1", HttpStatus.OK);
			
		}else{//읽지 않아서 디비에서 처리를 하다 실패했을때
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@GetMapping(value = "/getChatUserList", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<List<MemberVO>> getChatUserList(@RequestParam(value = "keyword", required = false )String keyword, Authentication authentication) {
		
		log.info("/getChatUserList?keyword="+keyword);
		
		CustomUser user = (CustomUser)authentication.getPrincipal();
		
		String userId = user.getUsername();
		
		List<MemberVO> chatUserList= chatService.getChatUserList(keyword, userId);
		
		if(chatUserList != null) {
			
			return new ResponseEntity<>(chatUserList, HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@PreAuthorize("principal.username == #chatRoomVO.roomOwnerId")
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, 
					value = "/chatTitle", consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE }) 
	@ResponseBody
	public ResponseEntity<String> chatTitle(@RequestBody ChatRoomVO chatRoomVO) {

		log.info("/chatTitle");
		log.info("ChatRoomVO: " + chatRoomVO);

		return chatService.updateChatTitle(chatRoomVO) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@GetMapping(value = "/getChatInviteList", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<List<MemberVO>> getChatInviteList(@RequestParam("chatRoomNum") Long chatRoomNum, @RequestParam(value = "keyword", required = false )String keyword){
		
		log.info("/getChatInviteList");
		
		String[] exceptUsers = chatService.getExceptUsers(chatRoomNum);
		
		List<MemberVO> chatUserList= chatService.getChatInviteList(exceptUsers, keyword);
		
		if(chatUserList != null) {
			
			return new ResponseEntity<>(chatUserList, HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@PostMapping(value = "/inviteChatMembers", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> inviteChatMembers(@RequestBody commonVO vo) throws IOException{
	
		log.info("/inviteChatMembers");
		log.info(vo);
		
		boolean result = chatService.inviteChatMembers(vo.getChatMemberVO(), vo.getChatMemberVoArray());
		
		return result == true  
					? new ResponseEntity<>(HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@GetMapping(value = "/chat_type", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<String> getChat_type(Long chatRoomNum) {
	
		log.info("getChat_type");
									
		int chat_type = chatService.getChat_type(chatRoomNum);
		
		if(chat_type == 1) {
			
			return new ResponseEntity<>("1", HttpStatus.OK);
			
		}else if(chat_type == 0){
			
			return new ResponseEntity<>("0", HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PreAuthorize("hasRole('ROLE_USER')")
	@ResponseBody
	@GetMapping(value = "/getChatRoomMembers", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<List<ChatMemberVO>> getChatRoomMembers(Long chatRoomNum) {
		
		log.info("/getChatRoomMembers");
		
		List<ChatMemberVO> chatRoomMembers = chatService.getChatRoomMembers(chatRoomNum);
		
		if(chatRoomMembers != null){
			
			return new ResponseEntity<>(chatRoomMembers, HttpStatus.OK);
			
		}else{
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
}
