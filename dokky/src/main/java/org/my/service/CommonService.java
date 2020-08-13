package org.my.service;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.VisitCountVO;
	import org.my.domain.alarmVO;
	import org.my.domain.noteVO;
	import org.springframework.security.core.Authentication;

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

	public int getAlarmCount(Criteria cri);
	
	public int getAlarmReadCount(Criteria cri);

	public List<alarmVO> getAllAlarmList(Criteria cri);
	
	public List<alarmVO> getReadedAlarmList(Criteria cri);

	public List<alarmVO> getNotReadedAlarmList(Criteria cri);
	
	public int insertAlarm(alarmVO vo);

	public String getAlarmRealCount(String userId);
	
	public int updateAlarmCheck(String alarmNum);

	public boolean deleteAllAlarm(Long alarmNum);
	
	public boolean deleteMyNote(Long note_num);

	public int getFromNoteCount(Criteria cri);

	public int getToNoteCount(Criteria cri);

	public int getMyNoteCount(Criteria cri);

	public int insertNote(noteVO note);

	public int updateNoteCheck(String note_num);

	public noteVO getDetailNotepage(Long note_num);

	public int updateFromNote(Long note_num);

	public int updateToNote(Long note_num);

	public List<noteVO> getFromNoteList(Criteria cri);
	
	public List<noteVO> getToNoteList(Criteria cri);

	public List<noteVO> getMyNoteList(Criteria cri);

	public String getNoteCount(String userId);
	
	public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication);

	public int getEnabled(String userId);
	
	public boolean setAuthentication(MemberVO memberVO, boolean checkAuth);  
	
	public String getAccessKey();

	public String getSecretKey();
}
