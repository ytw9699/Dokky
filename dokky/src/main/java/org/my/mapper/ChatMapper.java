package org.my.mapper;
	import java.util.Date;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMemberVO;
	import org.my.domain.ChatRoomVO;

public interface ChatMapper {

	String hasRoom(@Param("roomOwnerId") String roomOwnerId, @Param("chat_memberId") String chat_memberId);
	
	int createChatRoom(ChatRoomVO chatRoomVO);
	
	int createChatMember(ChatMemberVO chatMemberVO);
	
	List<ChatContentVO> getChatContents(@Param("chatRoomNum") Long chatRoomNum,  @Param("recentOutDate") Date recentOutDate);
	
	ChatMemberVO getChatMember(@Param("chatRoomNum") Long chatRoomNum, @Param("userId") String userId);
	
	void createChatContent(ChatContentVO chatContentVO);
	
	int createNoticeContent(ChatContentVO chatContentVO);

	void updateOutDate(@Param("chatRoomNum") Long chatRoomNum, @Param("chat_memberId") String chat_memberId);

	Date getRecentOutDate(@Param("chatRoomNum") Long chatRoomNum, @Param("chat_memberId") String chat_memberId);

	int updateHeadCount(@Param("chatRoomNum") Long chatRoomNum, @Param("changeCount") int changeCount);

	int updatePresent_position(@Param("chatRoomNum") Long chatRoomNum, @Param("changePosition") int changePosition, @Param("chat_memberId") String chat_memberId);
}
