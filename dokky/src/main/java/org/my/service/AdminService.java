package org.my.service;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.cashVO;

public interface AdminService {
	
	public List<cashVO> getCashRequest(Criteria cri);

	public int updateApprove(cashVO vo);

	public int getTotalCount();

}
