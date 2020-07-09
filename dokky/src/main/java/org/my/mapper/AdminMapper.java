package org.my.mapper;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.cashVO;
	import org.my.domain.reportVO;

public interface AdminMapper {
	
	public List<MemberVO> getMemberList(Criteria cri);
	
	public int getMemberTotalCount(Criteria cri);
	
	public List<cashVO> getCashRequestList(Criteria cri);
	
	public int getCashListTotalCount();

	public int updateApprove(Long cash_num);

	public void updatePluscash(cashVO vo);

	public void updateMinuscash(cashVO vo);

	public MemberVO getUserForm(String userId);

	public List<reportVO> getUserReportList(Criteria cri);

	public int insertReportdata(reportVO vo);

	public int getUserReportCount(Criteria cri);

	public int updateRoleStop(String userId);

	public int updateRoleLimit(String userId);

	public int updateRoleUser(String userId);

	public int updateRoleAdmin(String userId);
	
}
