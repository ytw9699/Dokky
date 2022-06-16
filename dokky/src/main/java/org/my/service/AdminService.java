/*
-  마지막 업데이트 2022-06-13
*/
package org.my.service;
	import java.util.List;
	import org.my.domain.common.AlarmVO;
	import org.my.domain.common.CashVO;
	import org.my.domain.common.CommonVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.ReportVO;

public interface AdminService {
	
	public List<MemberVO> getUserList(Criteria cri);
	
	public int getMemberTotalCount(Criteria cri);
	
	public List<CashVO> getCashRequestList(Criteria cri);
	
	public int getCashListTotalCount();
	
	public List<ReportVO> getUserReportList(Criteria cri);

	public int getUserReportCount(Criteria cri);
	
	public MemberVO getUserForm(String userId);
	
	public int limitLogin(String userId , AlarmVO vo);
	
	public int permitLogin(String userId , AlarmVO vo);

	public int insertRole(String userId, String role, AlarmVO vo);
	
	public int deleteRole(String userId, String role, AlarmVO vo);

	public int approveCash(CommonVO vo);
}
