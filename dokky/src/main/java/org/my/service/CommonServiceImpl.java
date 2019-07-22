package org.my.service;
	import org.my.domain.VisitCountVO;
	import org.my.mapper.CommonMapper;
	import org.springframework.beans.factory.annotation.Autowired;
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
	public int getVisitTotalCount() {
		
		log.info("getVisitTotalCount..."); 
		
		return mapper.getVisitTotalCount();
	}
}
