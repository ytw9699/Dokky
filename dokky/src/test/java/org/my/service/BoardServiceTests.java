package org.my.service;
	import static org.junit.Assert.assertNotNull;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	  "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	  "file:src/main/webapp/WEB-INF/spring/security-context.xml"
	  })
@Log4j
public class BoardServiceTests {

	@Setter(onMethod_ = { @Autowired })
	private BoardService service;
	
    //Long board_num;
	
	@Test
	public void testExist() {
		
		log.info("BoardService를 구현한 객체의 의존성 자동 주입 확인 테스트");
		log.info(service);
		assertNotNull(service);
	}
	
	@Test
	public void testRegister() {
		
		log.info("첨부파일 없는 단순 글 등록 테스트");
		
		BoardVO board = new BoardVO();
				board.setTitle("테스트 새글 제목");
				board.setContent("테스트 새글 내용");
				board.setNickName("슈퍼관리자");
				board.setUserId("admin");
				board.setCategory(1);
		
		service.register(board);//글입력

		log.info("생성된 게시물 번호 = "+board.getBoard_num());
		log.info(board);
		
		//board_num = board.getBoard_num();
	}
	
	@Test
	public void testGet() {
	    
		log.info("글 상세페이지 가져오기 테스트");
		
		Long board_num = service.getRecentBoard_num();//가장 최근에 작성한 게시물 번호 가져오기
		//하지만 testRegister()를 통해 방금 생성한 게시물 번호를 못가져온다..커밋이 안되는듯
		
		log.info("가져온 게시물 번호"+board_num);
		
		BoardVO board = service.get(board_num);
		
		log.info(board);
	}
	
	@Test
	public void testModify() {
		
		log.info("첨부파일 없는 게시글 수정 테스트");
		
		Long board_num = service.getRecentBoard_num();
		
		BoardVO board = service.get(board_num);

		if (board == null) {
			log.info("수정할 게시글 없음");
			return;
		}

		board.setTitle("수정된 테스트 제목");
		board.setContent("수정된 테스트 내용");
		
		if(service.modify(board) == true) {
			log.info("수정 완료");
		}else {
			log.info("수정 실패");
		}
	}
	
	
	@Test
	public void testRemove() {
		
		log.info("게시글 삭제 테스트");
		
		Long board_num = service.getRecentBoard_num();
		
		if(service.remove(board_num) == true) {
			log.info("삭제 완료");
		}else {
			log.info("삭제 실패");
		}
	}

	@Test
	public void testGetAllList() {
		
		log.info("전체글보기 리스트 테스트 ");
		
		service.getAllList(new Criteria()).forEach(boardVO -> log.info(boardVO));
	}

	@Test
	public void testGetList() {
	
		String[] title = {"공지사항","자유게시판","묻고답하기","칼럼/tech","정기모임/스터디"};
		
		Criteria cri = new Criteria();
		
		for(int i=1; i<6; i++) {
			
			log.info(title[i-1]+" 글 리스트 테스트");
			log.info("https://dokky.ga/board/list?category="+i);
			
			cri.setCategory(i);
			
			service.getList(cri).forEach(boardVO -> log.info(boardVO));
		}
	}
}
