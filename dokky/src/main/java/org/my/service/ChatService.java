package org.my.service;
	import java.util.Date;
	import java.util.List;
	import org.my.domain.chat.ChatContentVO;
	import org.my.domain.chat.ChatMemberVO;
	import org.my.domain.chat.ChatReadVO;
	import org.my.domain.chat.ChatRoom;
	import org.my.domain.chat.ChatRoomDTO;
	import org.my.domain.chat.ChatRoomVO;
	import org.my.domain.chat.MultiRoomVO;
	import org.my.domain.common.MemberVO;

public interface ChatService {
	
	public String hasRoom(String roomOwnerId, String chat_memberId);
	
	public boolean createSingleChat(ChatRoomVO chatRoomVO, ChatMemberVO chatMemberVO);
	
	public boolean createMultiChat(ChatRoomVO chatRoomVO, ChatMemberVO[] chatMemberVoArray);
	
	public List<ChatContentVO> getChatContents(Long chatRoomNum, Date recentOutDate, String chat_memberId);
	
	public ChatMemberVO getChatMember(Long chatRoomNum, String userId);
	
	public ChatRoom addChatRoom(String chatRoomNum);
	
	public ChatRoom findChatRoom(String id);
	
	public boolean removeAllChatData(Long chatRoomNum);
	
	public void createChatContent(ChatContentVO chatContentVO);
	
	public void createNoticeContent(ChatContentVO chatContentVO);

	public void updateOutDate(Long chatRoomNum, String chat_memberId , Date date);

	public Date getRecentOutDate(Long chatRoomNum, String chat_memberId);
	
	public boolean updateRoomStatus(Long chatRoomNum, String chat_writerId, int changeCount, int changePosition);

	public boolean getMyRoomStatus(Long chatRoomNum, String myId);
	
	public int getRoomHeadCount(Long chatRoomNum);

	public int getHeadCount(Long chatRoomNum);

	public int readChat(ChatReadVO vo);

	public List<ChatRoomDTO> getMyChatRoomList(String userId);

	public List<MemberVO> getChatUserList(String keyword, String userId);

	public MultiRoomVO getChatTitleInfo(Long chatRoomNum);

	public int updateChatTitle(ChatRoomVO chatRoomVO);

	public String[] getExceptUsers(Long chatRoomNum);

	public List<MemberVO> getChatInviteList(String[] exceptUsers, String keyword);

	public boolean inviteChatMembers(ChatMemberVO chatMemberVO, ChatMemberVO[] chatMemberVoArray);

	public int getChat_type(Long chatRoomNum);

	public List<ChatMemberVO> getChatRoomMembers(Long chatRoomNum);

	public boolean getInChatMember(Long chatRoomNum, String userId);

	
}
