/*
- 마지막 업데이트 2022-06-14
*/
package org.my.service;
	import java.util.ArrayList;
	import java.util.Iterator;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpSession;
	import org.my.domain.AuthVO;
	import org.my.domain.board.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.VisitCountVO;
	import org.my.domain.AlarmVO;
	import org.my.domain.NoteVO;
	import org.my.mapper.CommonMapper;
	import org.my.security.domain.CustomUser;
	import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.core.GrantedAuthority;
	import org.springframework.security.core.authority.SimpleGrantedAuthority;
	import org.springframework.security.core.context.SecurityContextHolder;
	import org.springframework.security.web.savedrequest.SavedRequest;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;

@RequiredArgsConstructor
@Log4j
@Service
public class CommonServiceImpl implements CommonService {

	private final CommonMapper mapper;
	
	@Override 
	public boolean setAuthentication(MemberVO memberVO){  
		
		log.info("setAuthentication");
			
		try {    
			  
			List<AuthVO> AuthList = memberVO.getAuthList();//사용자의 권한 정보만 list로 가져온다
			
			List<GrantedAuthority> roles = new ArrayList<>(1);// 인증해줄 권한 리스트를 만든다
			
			Iterator<AuthVO> it = AuthList.iterator();
			
			while (it.hasNext()) {
				AuthVO authVO = it.next(); 
				roles.add(new SimpleGrantedAuthority(authVO.getAuth()));
	        }

			Authentication auth = new UsernamePasswordAuthenticationToken(new CustomUser(memberVO), null, roles);
			
			SecurityContextHolder.getContext().setAuthentication(auth);
			
				
		}catch(Exception e) {
			
				e.printStackTrace();
				
			    return false;
		}
		
		return true;
	}
	
	@Override
	public String CustomAuthLoginSuccessHandler(String profileId, HttpServletRequest request){
		
		log.info("CustomAuthLoginSuccessHandler");
		
		updateLoginDate(profileId);
		
		HttpSession session = request.getSession();
		
		if (session != null) {
			
			session.setAttribute("userId", profileId);//웹소켓이 끊겼을때 사용하기 위해 세션에 저장해둔다.
            
			String preUrl = (String)session.getAttribute("preUrl");
          
            String securitySavedUrl = null;
            
            SavedRequest saveRequest = (SavedRequest)session.getAttribute("SPRING_SECURITY_SAVED_REQUEST");
			 
			if(saveRequest != null) {
				 securitySavedUrl = saveRequest.getRedirectUrl();
			}
            
			if(securitySavedUrl != null) {
				 
				 session.removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
				 session.removeAttribute("preUrl");
				 return securitySavedUrl;
			
			 }else if (preUrl != null) {
              	 
                 session.removeAttribute("preUrl");
                 return preUrl;
                 
            }
        }
		
		return "/main";
	}
	
	@Override
	public List<BoardVO> getRealtimeBoardList() {

		log.info("getRealtimeBoardList: ");

		return mapper.getRealtimeBoardList();
	}
	@Override
	public List<BoardVO> getMonthlyBoardList() {

		log.info("getMonthlyBoardList: ");

		return mapper.getMonthlyBoardList();
	}
	@Override
	public List<BoardVO> getDonationBoardList() {

		log.info("getDonationBoardList: ");

		return mapper.getDonationBoardList();
	}
	
	@Override
	public boolean getNicknameCheckedVal(String inputNickname, String userId) {
		
		log.info("getNicknameCheckedVal");
		
		if(userId != null) {
			
			if(inputNickname.equals(mapper.getNickname(userId))) {
				return false;
			}
		}
		
		return mapper.getNicknameCheckedVal(inputNickname) == 1;
	}
	
	@Override 
	public boolean getIdCheckedVal(String profileId) {

		log.info("getIdCheckedVal...");
		
		return mapper.getIdCheckedVal(profileId) == 1;
	}

	@Transactional
	@Override 
	public boolean updateLoginDate(String userName) {
		
		log.info("updateLoginDate..."); 
		
		return mapper.updatePreLoginDate(userName) == 1 && mapper.updatelastLoginDate(userName) == 1;
	}
	
	@Override 
	public boolean insertVisitor(VisitCountVO vo) {  

		log.info("insertVisitor..." + vo); 
		 
		return mapper.insertVisitor(vo) == 1 ;
	}
	
	@Override 
	public int getVisitTodayCount() {
		
		log.info("getVisitTodayCount..."); 
		
		return mapper.getVisitTodayCount();
	}
	
	@Override 
	public int getVisitTotalCount() {
		
		log.info("getVisitTotalCount..."); 
		
		return mapper.getVisitTotalCount();
	}
	
	@Override 
	public int getAllAlarmCount(Criteria cri) {
		log.info("getAllAlarmCount");
		
		return mapper.getAllAlarmCount(cri);
	}
	
	@Override 
	public int getAlarmCountRead(Criteria cri) {
		log.info("getAlarmCountRead");
		
		return mapper.getAlarmCountRead(cri);
	}
	@Override 
	public int getAlarmCountNotRead(String userId) {
		log.info("getAlarmCountNotRead");
		
		return mapper.getAlarmCountNotRead(userId);
	}
	
	@Override 
	public String getNoteCount(String userId) {
		log.info("getNoteCount");
		
		return mapper.getNoteCount(userId);
	}
	
	@Override 
	public String getChatCount(String userId) {
		log.info("getChatCount");
		
		return mapper.getChatCount(userId);
	}
	
	@Override
	public List<AlarmVO> getAllAlarmList(Criteria cri){
		log.info("getAllAlarmList");
		
		return mapper.getAllAlarmList(cri);
	}
	
	@Override
	public List<AlarmVO> getAlarmListRead(Criteria cri){
		log.info("getAlarmListRead");
		
		return mapper.getAlarmListRead(cri);
	}
	
	@Override
	public List<AlarmVO> getAlarmListNotRead(Criteria cri){
		log.info("getAlarmListNotRead");
		
		return mapper.getAlarmListNotRead(cri);
	}
	
	
	@Override
	public boolean deleteAllAlarm(Long alarmNum) {

		log.info("remove...." + alarmNum);

		return mapper.deleteAllAlarm(alarmNum) == 1;
	}
	
	@Override
	public boolean deleteMyNote(Long note_num) {

		log.info("deleteMyNote...." + note_num);

		return mapper.deleteMyNote(note_num) == 1;
	}
	
	@Override 
	public int insertAlarm(AlarmVO vo) {  

		log.info("insertAlarm..." + vo); 
		 
		return mapper.insertAlarm(vo) ;
	}
	
	@Override
	public int updateAlarmCheck(String alarmNum){
		log.info("updateAlarmCheck");
		
		return mapper.updateAlarmCheck(alarmNum);
	}
	
	@Override
	public int updateFromNote(Long note_num){
		log.info("updateFromNote");
		
		return mapper.updateFromNote(note_num);
	}
	
	@Override
	public int updateToNote(Long note_num){
		log.info("updateToNote");
		
		return mapper.updateToNote(note_num);
	}
	
	@Override
	public int updateNoteCheck(String note_num){
		log.info("updateNoteCheck");
		
		return mapper.updateNoteCheck(note_num);
	}
	
	@Override 
	public NoteVO getDetailNotepage(Long note_num) {
		
		log.info("getDetailNotepage");
		
		return mapper.getDetailNotepage(note_num);
	}
	
	@Override 
	public int getEnabled(String userId){  

		log.info("getEnabled : " + userId); 
		
		return mapper.getEnabled(userId);
	}
	
	@Override 
	public int getFromNoteCount(Criteria cri) {
		log.info("getFromNoteCount");
		
		return mapper.getFromNoteCount(cri);
	}
	
	@Override 
	public int getToNoteCount(Criteria cri) {
		log.info("getToNoteCount");
		
		return mapper.getToNoteCount(cri);
	}
	
	@Override 
	public int getMyNoteCount(Criteria cri) {
		log.info("getMyNoteCount");
		
		return mapper.getMyNoteCount(cri);
	}
	
	@Override 
	public int insertNote(NoteVO vo) {  

		log.info("insertNote : " + vo); 
		
		return mapper.insertNote(vo) ;
	}
	
	@Override
	public List<NoteVO> getFromNoteList(Criteria cri){
		log.info("getFromNoteList");
		
		return mapper.getFromNoteList(cri);
	}
	
	@Override
	public List<NoteVO> getMyNoteList(Criteria cri){
		log.info("getMyNoteList");
		
		return mapper.getMyNoteList(cri);
	}
	
	@Override
	public List<NoteVO> getToNoteList(Criteria cri){
		log.info("getToNoteList");
		
		return mapper.getToNoteList(cri);
	}
	
	@Override
	public void customLogout(String userId, HttpSession session){
		
		log.info("customLogout");
		
		session.invalidate();
		
		mapper.deleteRememberMeToken(userId);
	}	
}
