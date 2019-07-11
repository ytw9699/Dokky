package org.my.mapper;
	import java.util.List;
	import org.my.domain.Criteria;
	import org.my.domain.cashVO;

public interface AdminMapper {

	public List<cashVO> getCashRequest(Criteria cri);

	public int updateApprove(Long cash_num);

	public int getTotalCount();

	public void updatePluscash(cashVO vo);

	public void updateMinuscash(cashVO vo);

}
