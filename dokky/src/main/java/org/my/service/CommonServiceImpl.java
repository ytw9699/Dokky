package org.my.service;
	import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.my.domain.Criteria;
	import org.my.domain.VisitCountVO;
	import org.my.domain.alarmVO;
	import org.my.domain.noteVO;
	import org.my.mapper.CommonMapper;
	import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CommonServiceImpl implements CommonService {

	@Setter(onMethod_ = @Autowired)
	private CommonMapper mapper;
	
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
	public String tests1(){
		
		log.info("tests1..."); 
		
		return mapper.tests1();
	}
	
	@Override 
	public String tests2(){
		
		log.info("tests2..."); 
		
		return mapper.tests2();
	}
	
	@Override 
	public String tests3(){
		
		log.info("tests3..."); 
		
		return mapper.tests3();
	}
	
	@Override 
	public String tests4(){
		
		log.info("tests4..."); 
		
		return mapper.tests4();
	}
	
	@Override 
	public String tests5(){
		
		log.info("tests5..."); 
		
		return mapper.tests5();
	}
	
	
	@Override 
	public String tests6(){
		
		log.info("tests6..."); 
		
		return mapper.tests6();
	}
	
	@Override 
	public int getVisitTotalCount() {
		
		log.info("getVisitTotalCount..."); 
		
		return mapper.getVisitTotalCount();
	}
	
	@Override 
	public int getAlarmCount(Criteria cri) {
		log.info("getAlarmCount");
		
		return mapper.getAlarmCount(cri);
	}
	
	@Override 
	public int getAlarmReadCount(Criteria cri) {
		log.info("getAlarmReadCount");
		
		return mapper.getAlarmReadCount(cri);
	}
	@Override 
	public String getAlarmRealCount(String userId) {
		log.info("getAlarmRealCount");
		
		return mapper.getAlarmRealCount(userId);
	}
	
	@Override 
	public String getNoteCount(String userId) {
		log.info("getNoteCount");
		
		return mapper.getNoteCount(userId);
	}
	
	
	@Override
	public List<alarmVO> getAllAlarmList(Criteria cri){
		log.info("getAllAlarmList");
		
		return mapper.getAllAlarmList(cri);
	}
	
	@Override
	public List<alarmVO> getReadedAlarmList(Criteria cri){
		log.info("getReadedAlarmList");
		
		return mapper.getReadedAlarmList(cri);
	}
	
	@Override
	public List<alarmVO> getNotReadedAlarmList(Criteria cri){
		log.info("getNotReadedAlarmList");
		
		return mapper.getNotReadedAlarmList(cri);
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
	public int insertAlarm(alarmVO vo) {  

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
	public List<noteVO> getFromNoteList(Criteria cri){
		log.info("getFromNoteList");
		
		return mapper.getFromNoteList(cri);
	}
	
	@Override
	public List<noteVO> getMyNoteList(Criteria cri){
		log.info("getMyNoteList");
		
		return mapper.getMyNoteList(cri);
	}
	
	@Override
	public List<noteVO> getToNoteList(Criteria cri){
		log.info("getToNoteList");
		
		return mapper.getToNoteList(cri);
	}
	
	@Override 
	public noteVO getDetailNotepage(Long note_num) {
		
		log.info("getDetailNotepage");
		
		return mapper.getDetailNotepage(note_num);
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
	public int insertNote(noteVO vo) {  

		log.info("insertNote : " + vo); 
		
		return mapper.insertNote(vo) ;
	}
	
	@Override 
	public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {  
		
		log.info("logout"); 
		
		if(authentication != null) {
			log.info(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
			SecurityContextHolder.getContext().setAuthentication(null);//인증 풀기
		}
		
		request.getSession().invalidate();//세션무효화

		Cookie JSESSIONID = new Cookie("JSESSIONID", null);

		JSESSIONID.setMaxAge(0);

		response.addCookie(JSESSIONID);//쿠키 삭제
	}
	
}
