package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMemberVO;
	import org.my.domain.ChatRoomVO;

public interface ChatMapper {

	String hasRoom(@Param("roomOwnerId") String roomOwnerId, @Param("chat_memberId") String chat_memberId);
	
	int createChatRoom(ChatRoomVO chatRoomVO);
	
	int createChatMember(ChatMemberVO chatMemberVO);
	
	List<ChatContentVO> getChatContents(Long chatContents);
	
	ChatMemberVO getChatMember(@Param("chatRoomNum") Long chatRoomNum, @Param("userId") String userId);
	
	void createChatContent(ChatContentVO chatContentVO);
	
	int createNoticeContent(ChatContentVO chatContentVO);
}
