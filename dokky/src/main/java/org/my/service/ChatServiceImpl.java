/*
- 마지막 업데이트 2022-06-12
*/
package org.my.service;
	import java.io.IOException;
	import java.util.ArrayList;//임포트 해주자
	import java.util.Date;
	import java.util.HashMap;
	import java.util.List;
	import java.util.Map;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMemberVO;
	import org.my.domain.ChatMessage;
	import org.my.domain.ChatReadVO;
	import org.my.domain.ChatRoom;
	import org.my.domain.ChatRoomVO;
	import org.my.domain.MemberVO;
	import org.my.domain.chatRoomDTO;
	import org.my.domain.multiRoomVO;
	import org.my.mapper.ChatMapper;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;
	import org.my.domain.ChatMessageType;
	
@RequiredArgsConstructor
@Service
@Log4j
public class ChatServiceImpl implements ChatService {
	
		private final ChatMapper chatMapper;
		private Map<String, ChatRoom> chatRoomMap = new HashMap<>();
		
	    @Override
	    public String hasRoom(String roomOwnerId, String chat_memberId) {
	    	
	    	log.info("hasRoom");
	    	
	    	String chatRoomNum = chatMapper.hasRoom(chat_memberId, roomOwnerId);
	    	
	    	if(chatRoomNum != null) {
	    		
	    		return chatRoomNum;
	    		
	    	}else {
	    		
	    		return chatMapper.hasRoom(roomOwnerId, chat_memberId);
	    	}
	    }
		
		@Transactional
		@Override
		public boolean createSingleChat(ChatRoomVO chatRoomVO, ChatMemberVO chatMemberVO) {
			 
			log.info("createSingleChat");
			
			int firstResult = chatMapper.createChatRoom(chatRoomVO);//채팅방 만들기
			
			chatMemberVO.setChatRoomNum(chatRoomVO.getChatRoomNum());
			
			int secondResult = chatMapper.createChatMember(chatMemberVO);//채팅 멤버 입력
			
			ChatContentVO chatContentVO = new ChatContentVO();

			chatContentVO.setChatRoomNum(chatRoomVO.getChatRoomNum());
			
			chatContentVO.setChat_content(chatRoomVO.getRoomOwnerNick()+"님이 "+chatMemberVO.getChat_memberNick()+"님을 초대했습니다");
			
			chatContentVO.setRegDate(new Date());
			
			int thirdResult = chatMapper.createNoticeContent(chatContentVO);//공지 내용 입력
	    	
    		chatMapper.createChatReadType(chatContentVO.getChatRoomNum(), chatContentVO.getChatContentNum() , chatMemberVO.getChat_memberId(), chatMemberVO.getChat_memberNick(), 1);//공지라 하더라도 채팅 내용불러올시에 읽음처리 값이 필요함
    		chatMapper.createChatReadType(chatContentVO.getChatRoomNum(), chatContentVO.getChatContentNum() , chatRoomVO.getRoomOwnerId(), chatRoomVO.getRoomOwnerNick(),1 );
			
			chatMemberVO.setChat_memberId(chatRoomVO.getRoomOwnerId());
			
			chatMemberVO.setChat_memberNick(chatRoomVO.getRoomOwnerNick());
			
			int fourthResult = chatMapper.createChatMember(chatMemberVO);//채팅 방장 멤버 입력
			
			return firstResult == 1 && secondResult == 1 && thirdResult == 1 && fourthResult == 1 ;
		}

		@Transactional
		@Override
		public boolean createMultiChat(ChatRoomVO chatRoomVO, ChatMemberVO[] chatMemberVoArray){
			
			log.info("createMultiChat");
			
			if(chatMapper.createChatRoom(chatRoomVO) != 1) {//그룹방 만들기
				
				return false;
			}
			
			Long chatRoomNum = chatRoomVO.getChatRoomNum();
			
			ChatContentVO chatContentVO = new ChatContentVO();
			
			chatContentVO.setRegDate(new Date());
			
			chatContentVO.setChatRoomNum(chatRoomNum);
			
			String chat_content = chatRoomVO.getRoomOwnerNick()+"님이 ";
			
			for(ChatMemberVO memberVO : chatMemberVoArray){
				
				memberVO.setChatRoomNum(chatRoomNum);
				
				if(chatMapper.createChatMember(memberVO) != 1){//채팅 멤버들 입력
					
					return false;
				}
				
				chat_content += memberVO.getChat_memberNick()+" ";
	    	}
			
			ChatMemberVO roomOwnerVO = new ChatMemberVO();
						 roomOwnerVO.setChatRoomNum(chatRoomNum);
						 roomOwnerVO.setChat_memberId(chatRoomVO.getRoomOwnerId());
						 roomOwnerVO.setChat_memberNick(chatRoomVO.getRoomOwnerNick());
			
			if(chatMapper.createChatMember(roomOwnerVO) != 1 ){//방장 멤버이력
				return false;
			}
			
			chat_content += "님을 초대했습니다";
			
			chatContentVO.setChat_content(chat_content);
			
			if(chatMapper.createNoticeContent(chatContentVO) != 1) {//공지 내용 입력
				
				return false;
			}
			
			Long chatContentNum =  chatContentVO.getChatContentNum();
						 		
			for(ChatMemberVO memberVO : chatMemberVoArray){
				
				if(chatMapper.createChatReadType(chatRoomNum,  chatContentNum, memberVO.getChat_memberId(), memberVO.getChat_memberNick(), 1) != 1){
					//멤버들 읽음 테이블 입력
					return false;
				}
	    	}
			
    		if(chatMapper.createChatReadType(chatRoomNum, chatContentNum , chatRoomVO.getRoomOwnerId(), chatRoomVO.getRoomOwnerNick(), 1) != 1){
    			//방장도 읽음 테이블 입력
    			return false;
    		}
    		
    		return true;
		}
		
		@Override
		public List<ChatContentVO> getChatContents(Long chatRoomNum, Date recentOutDate, String chat_memberId){
	    	
	    	log.info("getChatContents");
	    	
	        return chatMapper.getChatContents(chatRoomNum, recentOutDate, chat_memberId);
	    }
		
		@Override
		public ChatMemberVO getChatMember(Long chatRoomNum, String userId){
	    	
	    	log.info("getChatMember");
	    	
	        return chatMapper.getChatMember(chatRoomNum, userId);
	    }
		
		@Override
	    public ChatRoom addChatRoom(String chatRoomNum){
	    	
	    	log.info("addChatRoom");
	    	
	    	ChatRoom chatRoom = chatRoomMap.get(chatRoomNum);
	    	
	    	if(chatRoom == null) {
	    		
	    		chatRoom = new ChatRoom();
	    		
	    		chatRoomMap.put(chatRoomNum, chatRoom);
	    	}
	    	
	        return chatRoom;
	    }
		
		@Override
	    public ChatRoom findChatRoom(String chatRoomNum){
	    		
	    	log.info("findChatRoom");
	    	
	        return chatRoomMap.get(chatRoomNum);
	    }
		
		@Override
	    public boolean removeAllChatData(Long chatRoomNum){
	    		
	    	log.info("removeAllChatData");
	    	
	    	if(chatMapper.removeChatRoom(chatRoomNum) == 1){
	    		
		    	chatRoomMap.remove(chatRoomNum.toString());
		    	
		    	log.info("chatRoomMap.remove");

		    	return true;
	    	
	    	}else {
	    		
	    		return false;
	    	}
	    }
		
		@Transactional
		@Override
	    public void createChatContent(ChatContentVO chatContentVO){//채팅 내용 입력
	    		
	    	log.info("createChatContent");
	    	
	    	chatMapper.createChatContent(chatContentVO);
	    	//chatMapper.updateInput_content_date(chatContentVO.getChatRoomNum());
	    	
	    	List<ChatMemberVO> memberList = chatMapper.getChatMembers(chatContentVO.getChatRoomNum());
	    	
	    	log.info("createChatReadType");
	    	
	    	for(ChatMemberVO memberVO : memberList){
	    		
	    		chatMapper.createChatReadType(chatContentVO.getChatRoomNum(), chatContentVO.getChatContentNum() , memberVO.getChat_memberId(), memberVO.getChat_memberNick(), 0);
	    	}
	    }
		
		@Override
	    public void createNoticeContent(ChatContentVO chatContentVO){//공지 내용 입력
	    		
	    	log.info("createNoticeContent");
	    	
	    	chatMapper.createNoticeContent(chatContentVO);
	    	
	    	List<ChatMemberVO> memberList = chatMapper.getChatMembers(chatContentVO.getChatRoomNum());
	    	
	    	log.info("createChatReadType");
	    	
	    	for(ChatMemberVO memberVO : memberList){
	    		
	    		chatMapper.createChatReadType(chatContentVO.getChatRoomNum(), chatContentVO.getChatContentNum() , memberVO.getChat_memberId(), memberVO.getChat_memberNick(), 1);
	    	}
	    }
		
		@Override
		public void updateOutDate(Long chatRoomNum, String chat_memberId, Date date){
	    		
	    	log.info("updateOutDate");
	    	
	    	chatMapper.updateOutDate(chatRoomNum, chat_memberId, date);
		}
		
		@Override
		public Date getRecentOutDate(Long chatRoomNum, String chat_memberId){
			
			log.info("getRecentOutDate");
			
			return chatMapper.getRecentOutDate(chatRoomNum, chat_memberId);
		}	
		
		@Transactional
		@Override
		public boolean updateRoomStatus(Long chatRoomNum, String chat_writerId, int changeCount, int changePosition){
	    		
	    	log.info("updateRoomStatus");
	    	
	    	return chatMapper.updatePresent_position(chatRoomNum, changePosition, chat_writerId) == 1 && chatMapper.updateHeadCount(chatRoomNum, changeCount) == 1;
		}
		
		@Override
		public boolean getMyRoomStatus(Long chatRoomNum, String myId){
			
			log.info("getMyRoomStatus");
			
			return chatMapper.getMyRoomStatus(chatRoomNum, myId) == 1;
		}
		
		@Override
		public int getRoomHeadCount(Long chatRoomNum){
			
			log.info("getRoomHeadCount");
			
			return chatMapper.getRoomHeadCount(chatRoomNum);
		}
		
		@Override
		public int getHeadCount(Long chatRoomNum){
			
			log.info("getHeadCount");
			
			return chatMapper.getHeadCount(chatRoomNum);
		}
		
		@Transactional
		@Override
		public int readChat(ChatReadVO vo){
			
			log.info("readChat");
			
			if(chatMapper.getRead_type(vo) == 0) {//읽지 않음 
					
					if(chatMapper.updateRead_type(vo) == 1 && chatMapper.updateReadCount(vo) == 1) {
						
						return 0;
						
					}else {
						
						return 2;
					}
					
			}else{//이미 읽음
				
				return 1;
			}
		}
		
		@Override
		public List<chatRoomDTO> getMyChatRoomList(String userId){
			
			log.info("getMyChatRoomList");
			
			List<chatRoomDTO> myChatRoomList = new ArrayList<>();
		    
			List<ChatRoomVO> myChatRoomVoList = chatMapper.getMyChatRoomVoList(userId);
			
			log.info("myChatRoomVoList="+myChatRoomVoList);
			
			for(ChatRoomVO ChatRoomVo : myChatRoomVoList) {
				
				Long chatRoomNum = ChatRoomVo.getChatRoomNum();
				
				log.info("chatRoomNum="+chatRoomNum);
				
				ChatContentVO ChatContentVo = chatMapper.getMyChatContentVo(chatRoomNum);
				
				log.info("ChatContentVo="+ChatContentVo);
				
				List<ChatReadVO> chatReadVoList;
				
				if(ChatRoomVo.getChat_type() == 1){//멀티채팅방이라면
					 chatReadVoList = chatMapper.getMyMultiChatReadVo(chatRoomNum);
				}else {
					 chatReadVoList = chatMapper.getMySingleChatReadVo(chatRoomNum, userId);
				}
				
				log.info("chatReadVoList="+chatReadVoList);
				
				int notReadCnt = chatMapper.getNotReadCnt(chatRoomNum, userId);
				
				log.info("notReadCnt="+notReadCnt);
				
				myChatRoomList.add(new chatRoomDTO(ChatRoomVo, ChatContentVo, chatReadVoList, notReadCnt));
			}
			
			return myChatRoomList;
		}
		
		@Override
		public List<MemberVO> getChatUserList(String keyword, String userId){
			
			log.info("getChatUserList");
			
			return chatMapper.getChatUserList(keyword, userId);
		}
		
		@Override
		public multiRoomVO getChatTitleInfo(Long chatRoomNum){
			
			log.info("getChatTitleInfo");
			
			return chatMapper.getChatTitleInfo(chatRoomNum);
		}
		
		@Override
		public int updateChatTitle(ChatRoomVO chatRoomVO){
			
			log.info("updateChatTitle");
			
			return chatMapper.updateChatTitle(chatRoomVO);
		}
		
		@Override
		public String[] getExceptUsers(Long chatRoomNum){
			
			log.info("getExceptUsers");
			
			return chatMapper.getExceptUsers(chatRoomNum);
		}
		

		@Override
		public List<MemberVO> getChatInviteList(String[] exceptUsers, String keyword){
			
			log.info("getChatInviteList");
			
			return chatMapper.getChatInviteList(exceptUsers, keyword);
		}
		
		@Transactional
		@Override
		public boolean inviteChatMembers(ChatMemberVO chatMemberVO, ChatMemberVO[] chatMemberVoArray){
			
				log.info("inviteChatMembers");
				
				Long chatRoomNum = chatMemberVO.getChatRoomNum();
				
				ChatContentVO chatContentVO = new ChatContentVO();
				chatContentVO.setRegDate(new Date());
				chatContentVO.setChatRoomNum(chatRoomNum);
				String chat_content = chatMemberVO.getChat_memberNick()+"님이 ";
				
				int headCount = chatMemberVoArray.length;
	    		
				if(chatMapper.updateHeadCount(chatRoomNum, headCount) != 1){
					return false;
				}	 
				
				int chat_type = chatMapper.getChat_type(chatRoomNum);
				
				if(chat_type == 0){//1:1채팅방이라면
					
					if(headCount == 1){
						
						if(chatMapper.getMember(chatRoomNum, chatMemberVoArray[0].getChat_memberId()) == 1){
							//초대한 인원이 기존의 1:1채팅 멤버였다면 1:1채팅방 타입을 유지
								
							if(chatMapper.updatePresent_position(chatRoomNum, 0, chatMemberVoArray[0].getChat_memberId()) != 1){
								
								return false;
							}
							
						}else{//초대한 인원이 기존의 1:1채팅 멤버가 아님
							
							if(chatMapper.createChatMember(chatMemberVoArray[0]) != 1){//채팅 멤버 입력
								
								return false;
							}
							
							if(chatMapper.updateChat_typeToMulti(chatRoomNum) != 1){
								
								return false;
							}
						}
						
						chat_content += chatMemberVoArray[0].getChat_memberNick();
						
					}else if(headCount > 1){
						
						for(int i=0; i<chatMemberVoArray.length; i++){
							
							ChatMemberVO memberVO = chatMemberVoArray[i];
							
							if(chatMapper.getMember(chatRoomNum, memberVO.getChat_memberId()) == 1){
								
								if(chatMapper.updatePresent_position(chatRoomNum, 0, memberVO.getChat_memberId()) != 1){
									
									return false;
								}
								
							}else{
								
								if(chatMapper.createChatMember(memberVO) != 1){
									
									return false;
								}
							}
							
							if(i != chatMemberVoArray.length-1) {
								chat_content += memberVO.getChat_memberNick()+" ";
								
							}else {
								chat_content += memberVO.getChat_memberNick();
							}
				    	}
							
						if(chatMapper.updateChat_typeToMulti(chatRoomNum) != 1){
							return false;
						}
					}
					
				}else if(chat_type == 1){
					
					for(int i=0; i<chatMemberVoArray.length; i++){
						
						ChatMemberVO memberVO = chatMemberVoArray[i];
						
						if(chatMapper.getMember(chatRoomNum, memberVO.getChat_memberId()) == 1){
							
							if(chatMapper.updatePresent_position(chatRoomNum, 0, memberVO.getChat_memberId()) != 1){
								
								return false;
							}
							
						}else{
							
							if(chatMapper.createChatMember(memberVO) != 1){
								
								return false;
							}
						}
								
						if(i != chatMemberVoArray.length-1) {
							chat_content += memberVO.getChat_memberNick()+" ";
							
						}else {
							chat_content += memberVO.getChat_memberNick();
						}
						
					}
				}
				
				chat_content += "님을 초대했습니다";
				
				chatContentVO.setChat_content(chat_content);
				
				if(chatMapper.createNoticeContent(chatContentVO) != 1) {//공지 내용 입력
					
					return false;
				}
				
				Long chatContentNum =  chatContentVO.getChatContentNum();	
				
				List<ChatMemberVO> memberList = chatMapper.getChatMembers(chatRoomNum);
				
				for(ChatMemberVO memberVO : memberList){
					
					if(chatMapper.createChatReadType(chatRoomNum, chatContentNum, memberVO.getChat_memberId(), memberVO.getChat_memberNick(), 1) != 1){
						//멤버들 읽음 테이블 입력
						return false;
					}
		    	}
				
				String memberIds = "";
				String chatTitle = "";
				
				for(int i=0; i<memberList.size(); i++){
					
					ChatMemberVO memberVO = memberList.get(i);
					
					if(i == memberList.size()-1){
						chatTitle += memberVO.getChat_memberNick();
						memberIds += memberVO.getChat_memberId();
						
					}else {
						chatTitle += memberVO.getChat_memberNick()+", ";
						memberIds += memberVO.getChat_memberId()+",";
					}
					
				}
				
				ChatRoom chatRoom = findChatRoom(chatRoomNum.toString());
				
				ChatMessage chatMessage = new ChatMessage();
				chatMessage.setType(ChatMessageType.INVITE);
				chatMessage.setMessage(chat_content);
				chatMessage.setMemberIds(memberIds);
				chatMessage.setChatTitle(chatTitle);
				
				try {
					chatRoom.handleMessage(null, chatMessage);
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				return true;
		}
		
		@Override
		public int getChat_type(Long chatRoomNum){
			
			log.info("getChat_type");
			
			return chatMapper.getChat_type(chatRoomNum);
		}
		
		@Override
		public List<ChatMemberVO> getChatRoomMembers(Long chatRoomNum){
			
			log.info("getChatRoomMembers");
			
			return chatMapper.getChatMembers(chatRoomNum);
		}
		
		@Override
		public boolean getInChatMember(Long chatRoomNum, String userId){
			
			log.info("getInChatMember");
			
			return chatMapper.getInChatMember(chatRoomNum, userId) == 0;//멤버가 아니라면 true 반환
		}
}

