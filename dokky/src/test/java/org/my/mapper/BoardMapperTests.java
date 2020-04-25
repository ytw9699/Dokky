package org.my.mapper;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.my.domain.Criteria;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	  "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	  "file:src/main/webapp/WEB-INF/spring/security-context.xml"
	  })
@Log4j
public class BoardMapperTests {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;//BoardMapper 인터페이스의 구현체를 주입받아서 동작

	@Test
	public void testGetAllList() {
		
		log.info("전체글보기 테스트 ");
		log.info("/https://dokky.ga/board/allList?category=0");
		
		Criteria cri = new Criteria();
		
		mapper.getAllList(cri).forEach(boardVO -> log.info(boardVO));

	}
	
	@Test
	public void testGetList() {
	
		Criteria cri = new Criteria();
		
		for(int i=1; i<6; i++) {
			
			log.info("글 "+i);
			
			log.info("글 리스트 테스트 category="+i);
			log.info("https://dokky.ga/board/list?category="+i);
			
			cri.setCategory(i);
			
			mapper.getList(cri).forEach(boardVO -> log.info(boardVO));
		}
	}
}
