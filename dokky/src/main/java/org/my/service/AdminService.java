package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.cashVO;
	import org.my.domain.reportVO;

public interface AdminService {
	
	public List<cashVO> getCashRequest(Criteria cri);

	public int updateApprove(cashVO vo);

	public int getTotalCount();

	public List<MemberVO> getMemberList(Criteria cri);

	public int getMemberTotalCount(Criteria cri);

	public MemberVO getUserForm(String userId);

	public List<reportVO> getUserReportList(Criteria cri);

	public int getUserReportCount(Criteria cri);

}
