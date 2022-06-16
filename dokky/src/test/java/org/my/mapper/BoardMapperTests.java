package org.my.mapper;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.my.domain.board.BoardVO;
	import org.my.domain.Criteria;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	  "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	  "file:src/main/webapp/WEB-INF/spring/security-context.xml"
	  })
@Log4j
public class BoardMapperTests {

	@Autowired 
	private BoardMapper mapper;//BoardMapper 인터페이스의 구현체를 주입받아서 동작
	
	//Long board_num;
	
	@Test
	public void testRegister() {
		
		log.info("첨부파일 없는 단순 글 등록 테스트");
		
		BoardVO board = new BoardVO();
				board.setTitle("테스트 새글 제목");
				board.setContent("테스트 새글 내용");
				board.setNickName("슈퍼관리자");
				board.setUserId("admin");
				board.setCategory(1);
		
		mapper.register(board);

		log.info("생성된 게시물 번호 = "+board.getBoard_num());
		log.info(board);
		
		//board_num = board.getBoard_num();
	}
	
	@Test
	public void testGet() {
		
		log.info("글 상세페이지 가져오기 테스트");

		BoardVO board = mapper.read(444L);//최근의 게시물 번호

		log.info(board);
	}
	
	@Test
	public void testModify() {
		
		log.info("첨부파일 없는 게시글 수정 테스트");
		
		BoardVO board = new BoardVO();
		
		board.setBoard_num(444L);//최근의 게시물 번호
		board.setTitle("수정된 테스트 제목");
		board.setContent("수정된 테스트 내용");

		int count = mapper.updateBoard(board);
		
		if(count == 1) {
			log.info("수정 완료");
		}else {
			log.info("수정 실패");
		}
	}
	
	@Test
	public void testRemove() {
		
		log.info("게시글 삭제 테스트");
		
		int count = mapper.deleteBoard(444L);
		
		if(count == 1) {
			log.info("삭제 완료");
		}else {
			log.info("삭제 실패");
		}
	}

	
	@Test
	public void testGetAllList() {
		
		log.info("전체글보기 리스트 테스트 ");
		
		mapper.getAllList(new Criteria()).forEach(boardVO -> log.info(boardVO));
	}
	
	@Test
	public void testGetLists() {
		
		String[] title = {"공지사항","자유게시판","묻고답하기","칼럼/tech","정기모임/스터디"};
		
		Criteria cri = new Criteria();
		
		for(int i=1; i<6; i++) {
			
			log.info(title[i-1]+" 글 리스트 테스트");
			log.info("https://dokky.site/board/list?category="+i);
			
			cri.setCategory(i);
			
			mapper.getList(cri).forEach(boardVO -> log.info(boardVO));
		}
	}
	
	
	
}
