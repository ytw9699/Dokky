package org.my.mapper;
	import java.util.Date;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.ChatContentVO;
	import org.my.domain.ChatMemberVO;
	import org.my.domain.ChatReadVO;
	import org.my.domain.ChatRoomVO;
	import org.my.domain.MemberVO;
	import org.my.domain.multiRoomVO;

public interface ChatMapper {

	String hasRoom(@Param("roomOwnerId") String roomOwnerId, @Param("chat_memberId") String chat_memberId);
	
	int createChatRoom(ChatRoomVO chatRoomVO);
	
	int createChatMember(ChatMemberVO chatMemberVO);
	
	List<ChatContentVO> getChatContents(@Param("chatRoomNum") Long chatRoomNum,  @Param("recentOutDate") Date recentOutDate, @Param("chat_memberId") String chat_memberId);
	
	ChatMemberVO getChatMember(@Param("chatRoomNum") Long chatRoomNum, @Param("userId") String userId);
	
	void createChatContent(ChatContentVO chatContentVO);
	
	int createNoticeContent(ChatContentVO chatContentVO);

	void updateOutDate(@Param("chatRoomNum") Long chatRoomNum, @Param("chat_memberId") String chat_memberId, @Param("inputDate") Date inputDate);

	Date getRecentOutDate(@Param("chatRoomNum") Long chatRoomNum, @Param("chat_memberId") String chat_memberId);

	int updateHeadCount(@Param("chatRoomNum") Long chatRoomNum, @Param("changeCount") int changeCount);

	int updatePresent_position(@Param("chatRoomNum") Long chatRoomNum, @Param("changePosition") int changePosition, @Param("chat_memberId") String chat_memberId);

	int getMyRoomStatus(@Param("chatRoomNum") Long chatRoomNum, @Param("myId") String myId);

	int getRoomHeadCount(Long chatRoomNum);

	int removeChatRoom(Long chatRoomNum);

	int getHeadCount(Long chatRoomNum);
	
	int createChatReadType(@Param("chatRoomNum") Long chatRoomNum, @Param("chatContentNum") Long chatContentNum, @Param("chat_memberId") String chat_memberId, @Param("chat_memberNick") String chat_memberNick, @Param("read_type") int read_type );

	List<ChatMemberVO> getChatMembers(Long chatRoomNum);

	int updateRead_type(ChatReadVO vo);

	int updateReadCount(ChatReadVO vo);

	List<ChatRoomVO> getMyChatRoomVoList(String userId);

	ChatContentVO getMyChatContentVo(Long chatRoomNum);

	List<ChatReadVO> getMySingleChatReadVo(@Param("chatRoomNum") Long chatRoomNum, @Param("userId") String userId);
	
	List<ChatReadVO> getMyMultiChatReadVo(Long chatRoomNum);

	int getNotReadCnt(@Param("chatRoomNum") Long chatRoomNum, @Param("userId") String userId);

	List<MemberVO> getChatUserList(@Param("keyword") String keyword, @Param("userId") String userId);

	int getRead_type(ChatReadVO vo);

	multiRoomVO getChatTitleInfo(@Param("chatRoomNum") Long chatRoomNum);

	List<ChatMemberVO> getMultiroomMembers(Long chatRoomNum);

	int updateChatTitle(ChatRoomVO chatRoomVO);

	String[] getExceptUsers(Long chatRoomNum);

	List<MemberVO> getChatInviteList(@Param("exceptUsers")String[] exceptUsers, @Param("keyword")String keyword);

}
