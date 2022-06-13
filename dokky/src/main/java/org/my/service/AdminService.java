/*
-  마지막 업데이트 2022-06-13
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.cashVO;
	import org.my.domain.commonVO;
	import org.my.domain.reportVO;
	import org.my.domain.alarmVO;

public interface AdminService {
	
	public List<MemberVO> getUserList(Criteria cri);
	
	public int getMemberTotalCount(Criteria cri);
	
	public List<cashVO> getCashRequestList(Criteria cri);
	
	public int getCashListTotalCount();
	
	public List<reportVO> getUserReportList(Criteria cri);

	public int getUserReportCount(Criteria cri);
	
	public MemberVO getUserForm(String userId);
	
	public int limitLogin(String userId , alarmVO vo);
	
	public int permitLogin(String userId , alarmVO vo);

	public int insertRole(String userId, String role, alarmVO vo);
	
	public int deleteRole(String userId, String role, alarmVO vo);

	public int approveCash(commonVO vo);
}
