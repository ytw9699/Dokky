package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.cashVO;
	import org.my.domain.commonVO;
	import org.my.domain.reportVO;
	import org.my.domain.alarmVO;

public interface AdminService {
	
	public List<MemberVO> getMemberList(Criteria cri);
	
	public int getMemberTotalCount(Criteria cri);
	
	public List<cashVO> getCashRequest(Criteria cri);

	public int updateApprove(commonVO vo);

	public int getTotalCount();

	public MemberVO getUserForm(String userId);

	public List<reportVO> getUserReportList(Criteria cri);

	public int getUserReportCount(Criteria cri);

	public int updateRoleStop(String userId, alarmVO vo);

	public int updateRoleLimit(String userId , alarmVO vo);

	public int updateRoleUser(String userId, alarmVO vo);

	public int updateRoleAdmin(String userId, alarmVO vo);

}
