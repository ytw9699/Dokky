package org.my.service;
	import java.util.Date;
	import java.util.List;
	import org.my.domain.ChatMemberVO;
	import org.my.domain.ChatRoomVO;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatRoom;

public interface ChatService {
	
	public String hasRoom(String roomOwnerId, String chat_memberId);
	
	public boolean createSingleChat(ChatRoomVO chatRoomVO, ChatMemberVO chatMemberVO);
	
	public List<ChatContentVO> getChatContents(Long chatRoomNum, Date recentOutDate);
	
	public ChatMemberVO getChatMember(Long chatRoomNum, String userId);
	
	public ChatRoom addChatRoom(String chatRoomNum);
	
	public ChatRoom findChatRoom(String id);
	
	public void createChatContent(ChatContentVO chatContentVO);
	
	public void createNoticeContent(ChatContentVO chatContentVO);

	public void updateOutDate(Long chatRoomNum, String chat_memberId);

	public Date getRecentOutDate(Long chatRoomNum, String chat_memberId);
	
	public boolean updateRoomStatus(Long chatRoomNum, String chat_writerId);
	
}
