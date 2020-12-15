package org.my.controller;
	import java.io.IOException;
	import java.util.Date;
	import java.util.List;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMessage;
	import org.my.domain.ChatMessageType;
	import org.my.domain.ChatReadVO;
	import org.my.domain.ChatRoom;
	import org.my.domain.MemberVO;
	import org.my.domain.chatRoomDTO;
	import org.my.domain.commonVO;
	import org.my.security.domain.CustomUser;
	import org.my.service.ChatService;
	import org.springframework.beans.factory.annotation.Autowired;
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
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class ChatController {
	
	@Setter(onMethod_ = @Autowired)
	private ChatService chatService;
	
	@PreAuthorize("principal.username == #vo.chatRoomVO.roomOwnerId")
	@ResponseBody
	@PostMapping(value = "/makeSingleChat", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> makeSingleChat(@RequestBody commonVO vo) throws IOException{

		 log.info("/makeSingleChat");
		 log.info("vo : " + vo);
		 
		 String myId = vo.getChatRoomVO().getRoomOwnerId();
		 
		 String chatRoomNum = chatService.hasRoom(myId, vo.getChatMemberVO().getChat_memberId());//기존의 1:1채팅방이 있는지 확인
		 					  
		 if(chatRoomNum != null){
	        
			 if(chatService.getMyRoomStatus(Long.parseLong(chatRoomNum), myId)){
				 
				  chatService.updateRoomStatus(Long.parseLong(chatRoomNum), myId, 1 , 0);
				  
				  ChatRoom chatRoom = chatService.findChatRoom(chatRoomNum);
				  
				  ChatMessage chatMessage = new ChatMessage();
		          
		          String reEnterMessage = vo.getChatRoomVO().getRoomOwnerNick()+"님이 들어왔습니다";
		          
	              chatMessage.setMessage(reEnterMessage);
	              chatMessage.setRegDate(new Date());
	              chatMessage.setType(ChatMessageType.IN);
	              
	              chatRoom.reEnterChatRoom(chatMessage);
	            	
	              ChatContentVO chatContentVO = new ChatContentVO();
	            	
	              chatContentVO.setChatRoomNum(Long.parseLong(chatRoomNum));
	              chatContentVO.setChat_content(reEnterMessage);
	              chatContentVO.setRegDate(chatMessage.getRegDate());
	            	
	              chatService.createNoticeContent(chatContentVO);
			 }
			 
			 return new ResponseEntity<>(chatRoomNum, HttpStatus.OK);
		
		 }else{
		
			 boolean makeResult = chatService.createSingleChat(vo.getChatRoomVO(), vo.getChatMemberVO());
											 //1:1채팅방 만들기
			
			 return makeResult == true  
					? new ResponseEntity<>(vo.getChatRoomVO().getChatRoomNum().toString(), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		 }
	}
	
	@ResponseBody
	@PostMapping(value = "/createMultiChat", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> createMultiChat(@RequestBody commonVO vo) throws IOException{
		
		log.info("/createMultiChat");
		log.info(vo);
		
		boolean makeResult = chatService.createMultiChat(vo.getChatRoomVO(), vo.getChatMemberVoArray());
		 //1:1채팅방 만들기
		
		return makeResult == true  
					? new ResponseEntity<>(vo.getChatRoomVO().getChatRoomNum().toString(), HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("principal.username == #userId")
	@GetMapping("/chatRoom/{chatRoomNum}")
	public String getChatRoom(@PathVariable Long chatRoomNum, @RequestParam("chat_type")int chat_type, @RequestParam("userId")String userId, Model model){
	    	
    	log.info("/getChatRoom/"+chatRoomNum);
    
    	Date recentOutDate = chatService.getRecentOutDate(chatRoomNum, userId);
    	
    	model.addAttribute("chatContents", chatService.getChatContents(chatRoomNum, recentOutDate, userId));//채팅방의 메시지들
    	
    	if(chat_type == 0) {//1:1채팅방의 경우
    		model.addAttribute("chatMember", chatService.getChatMember(chatRoomNum, userId));//채팅방의 제목에 들어갈 상대방 정보
    	}else if(chat_type == 1) {//멀티채팅방의 경우
    		model.addAttribute("chatTitleInfo", chatService.getChatTitleInfo(chatRoomNum));//멀티 채팅방의 제목,방장 아이디,닉네임
    		model.addAttribute("chatMembers", chatService.getMultiroomMembers(chatRoomNum));//멀티 채팅방의 멤버들 아이디,닉네임
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
	
	
	
	
	
	
	@PreAuthorize("principal.username == #vo.chat_memberId")
	@ResponseBody
	@PostMapping(value = "/readChat", consumes = "application/json", produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> readChat(@RequestBody ChatReadVO vo) {

		log.info("/readChat");
		
		int result = chatService.readChat(vo);
		
		if(result == 0) {//읽지 않았는데 , 디비에서 읽음 처리를 했을때
			
			return new ResponseEntity<>("0", HttpStatus.OK);
					
		}else if(result == 1){//이미 디비에서 읽음 처리가 되었을때
			
			return new ResponseEntity<>("1", HttpStatus.OK);
			
		}else{ // 읽지 않아서 디비에서 처리를 하다 실패했을때
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@ResponseBody
	@GetMapping(value = "/getChatUserList", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<List<MemberVO>> getChatUserList(@RequestParam(value = "keyword", required = false )String keyword, Authentication authentication) {
		
		log.info("/getChatUserList?keyword="+keyword);
		
		CustomUser user = (CustomUser)authentication.getPrincipal();
		
		String userId = user.getUsername();
		
		List<MemberVO> chatUserList= chatService.getChatUserList(keyword,userId);
		
		if(chatUserList != null) {
			
			return new ResponseEntity<>(chatUserList, HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
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
	
}
