/*
- 마지막 업데이트 2022-06-14
*/
package org.my.service;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpSession;
	import org.my.domain.board.BoardVO;
	import org.my.domain.common.AlarmVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.NoteVO;
	import org.my.domain.common.VisitCountVO;

public interface CommonService {
	
	public List<BoardVO> getRealtimeBoardList();

	public List<BoardVO> getMonthlyBoardList();

	public List<BoardVO> getDonationBoardList();
	
	public boolean getNicknameCheckedVal(String inputNickname, String userId);
	 
	public boolean getIdCheckedVal(String profileId);
	
	public boolean updateLoginDate(String userName);
	
	public boolean insertVisitor(VisitCountVO vo);

	public int getVisitTodayCount();

	public int getVisitTotalCount();

	public int getAllAlarmCount(Criteria cri);
	
	public int getAlarmCountRead(Criteria cri);

	public List<AlarmVO> getAllAlarmList(Criteria cri);
	
	public List<AlarmVO> getAlarmListRead(Criteria cri);

	public List<AlarmVO> getAlarmListNotRead(Criteria cri);
	
	public int insertAlarm(AlarmVO vo);

	public int getAlarmCountNotRead(String userId);
	
	public int updateAlarmCheck(String alarmNum);

	public boolean deleteAllAlarms(String checkRow);
	
	public boolean deleteMyNote(Long note_num);

	public int updateNoteCheck(String note_num);

	public NoteVO getDetailNotepage(Long note_num);

	public int updateFromNote(Long note_num);

	public int updateToNote(Long note_num);

	public List<NoteVO> getFromNoteList(Criteria cri);
	
	public List<NoteVO> getToNoteList(Criteria cri);

	public List<NoteVO> getMyNoteList(Criteria cri);

	public String getNoteCount(String userId);
	
	public String getChatCount(String userId);
	
	public int getEnabled(String userId);
	
	public boolean setAuthentication(MemberVO memberVO);  
	
	public int getFromNoteCount(Criteria cri);

	public int getToNoteCount(Criteria cri);

	public int getMyNoteCount(Criteria cri);
	
	public int insertNote(NoteVO note);
	
	public String CustomAuthLoginSuccessHandler(String profileId, HttpServletRequest request);

	public void customLogout(String userId, HttpSession session);
}
