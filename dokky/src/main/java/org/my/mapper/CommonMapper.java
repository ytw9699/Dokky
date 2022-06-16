/*
- 마지막 업데이트 2022-06-14
*/
package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.board.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.VisitCountVO;
	import org.my.domain.AlarmVO;
	import org.my.domain.NoteVO;

public interface CommonMapper {
	
	public List<BoardVO> getRealtimeBoardList();

	public List<BoardVO> getMonthlyBoardList();

	public List<BoardVO> getDonationBoardList();
	
	public String getNickname(@Param("userId") String userId);
	
	public int getNicknameCheckedVal(@Param("nickName") String nickName);
	
	public int getIdCheckedVal(String profileId);
	
	public int updatePreLoginDate(String userName);

	public int updatelastLoginDate(String userName);
	
	public int insertVisitor(VisitCountVO vo);

	public int getVisitTodayCount();

	public int getVisitTotalCount();

	public int getAllAlarmCount(Criteria cri);

	public List<AlarmVO> getAllAlarmList(Criteria cri);

	public int insertAlarm(AlarmVO vo);
	
	public int deleteAlarm(AlarmVO vo);

	public int getAlarmCountNotRead(String userId);

	public int updateAlarmCheck(String alarmNum);

	public int deleteAllAlarm(Long alarmNum);
	
	public int deleteMyNote(Long note_num);

	public int updateNoteCheck(String note_num);

	public NoteVO getDetailNotepage(Long note_num);

	public int updateFromNote(Long note_num);

	public int updateToNote(Long note_num);

	public List<NoteVO> getToNoteList(Criteria cri);

	public List<NoteVO> getMyNoteList(Criteria cri);

	public String getNoteCount(String userId);
	
	public String getChatCount(String userId);

	public int getAlarmCountRead(Criteria cri);

	public List<AlarmVO> getAlarmListRead(Criteria cri);

	public List<AlarmVO> getAlarmListNotRead(Criteria cri);

	public int getEnabled(String userId);
	
	public int getFromNoteCount(Criteria cri);
	
	public int getToNoteCount(Criteria cri);

	public int getMyNoteCount(Criteria cri);
	
	public int insertNote(NoteVO vo);
	
	public List<NoteVO> getFromNoteList(Criteria cri);

	public int deleteRememberMeToken(String userId);
}
