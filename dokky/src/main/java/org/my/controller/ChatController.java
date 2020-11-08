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
	import org.my.service.ChatService;
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
	
	@PreAuthorize("principal.username == #userId")
	@GetMapping("/chatRoom/{chatRoomNum}")
	public String getChatRoom(@PathVariable Long chatRoomNum, @RequestParam("userId")String userId, Model model){
	    	
    	log.info("/getChatRoom/"+chatRoomNum);
    
    	Date recentOutDate = chatService.getRecentOutDate(chatRoomNum, userId);
    	
    	model.addAttribute("chatContents", chatService.getChatContents(chatRoomNum, recentOutDate, userId));//채팅방의 메시지들
        model.addAttribute("chatMember", chatService.getChatMember(chatRoomNum, userId));//채팅방의 제목에 들어갈 상대방 정보
        model.addAttribute("chatRoomNum", chatRoomNum);
        model.addAttribute("headCount", chatService.getHeadCount(chatRoomNum));
        
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
		
		boolean result = chatService.readChat(vo);
		
		return result == true  
				? new ResponseEntity<>(HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER')")
	@ResponseBody
	@GetMapping(value = "/getChatUserList", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<List<MemberVO>> getChatUserList() {
		
		log.info("/getChatUserList");
		
		List<MemberVO> chatUserList = chatService.getChatUserList();
		
		if(chatUserList != null) {
			
			return new ResponseEntity<>(chatUserList, HttpStatus.OK);
			
		}else {
			
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
}
