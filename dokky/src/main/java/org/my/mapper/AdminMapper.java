/*
-  마지막 업데이트 2022-06-13
*/
package org.my.mapper;
	import java.util.List;
	import org.apache.ibatis.annotations.Param;
	import org.my.domain.common.CashVO;
	import org.my.domain.common.Criteria;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.ReportVO;

public interface AdminMapper {
	
	public List<MemberVO> getUserList(Criteria cri);
	
	public int getMemberTotalCount(Criteria cri);
	
	public List<CashVO> getCashRequestList(Criteria cri);
	
	public int getCashListTotalCount();
	
	public List<ReportVO> getUserReportList(Criteria cri);
	
	public int getUserReportCount(Criteria cri);
	
	public MemberVO getUserForm(String userId);
	
	public int updateAccountNonLocked(@Param("userId") String userId, @Param("accountNonLocked") int accountNonLocked);
	
	public int insertRole(@Param("userId") String userId, @Param("role") String role);
	
	public int deleteRole(@Param("userId") String userId, @Param("role") String role);
	
	public void updatePluscash(CashVO vo);

	public void updateMinuscash(CashVO vo);
	
	public int approveCash(Long cash_num);
}
