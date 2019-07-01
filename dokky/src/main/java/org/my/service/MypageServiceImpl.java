package org.my.service;
	import org.my.domain.MemberVO;
	import org.my.mapper.MemberMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class MypageServiceImpl implements MypageService {

	//@Setter(onMethod_ = @Autowired)
	//private MypageMapper mapper;
	
}
