/*
- 마지막 업데이트 2022-05-25
*/
package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.Criteria;
	import org.my.domain.MemberVO;
	import org.my.domain.cashVO;
	import org.my.domain.reportVO;

public interface AdminMapper {
	
	public List<MemberVO> getUserList(Criteria cri);
	
	public int getMemberTotalCount(Criteria cri);
	
	public List<cashVO> getCashRequestList(Criteria cri);
	
	public int getCashListTotalCount();
	
	public List<reportVO> getUserReportList(Criteria cri);
	
	public int getUserReportCount(Criteria cri);
	
	public MemberVO getUserForm(String userId);
	
	public int updateAccountNonLocked(@Param("userId") String userId, @Param("accountNonLocked") int accountNonLocked);
	
	public int insertRole(@Param("userId") String userId, @Param("role") String role);
	
	public int deleteRole(@Param("userId") String userId, @Param("role") String role);
	
	public int updatePermitLogin(String userId);

	public int approveCash(Long cash_num);

	public void updatePluscash(cashVO vo);

	public void updateMinuscash(cashVO vo);

	public int insertReportdata(reportVO vo);
}
