package org.my.controller;
	import static org.junit.Assert.assertEquals;
	import static org.junit.Assert.assertNotNull;
	import static org.junit.Assert.assertNull;
	import static org.junit.Assert.fail;
	import java.util.Map;
	import org.junit.Before;
	import org.junit.FixMethodOrder;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.junit.runners.MethodSorters;
	import org.my.domain.BoardVO;
	import org.my.mapper.BoardMapper;
	import org.my.service.BoardService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.test.context.support.WithMockUser;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.springframework.test.context.web.WebAppConfiguration;
	import org.springframework.test.web.servlet.MockMvc;
	import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
	import org.springframework.test.web.servlet.setup.MockMvcBuilders;
	import org.springframework.web.context.WebApplicationContext;
	import org.springframework.web.servlet.ModelAndView;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml", 
	"file:src/main/webapp/WEB-INF/spring/security-context.xml"	
})
@Log4j
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WithMockUser(username="admin", roles={"ADMIN"})
public class BoardControllerTests {

	@Setter(onMethod_ = { @Autowired })
	private WebApplicationContext ctx;
	
	@Setter(onMethod_ = { @Autowired })
	private BoardService service;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	private MockMvc mockMvc; 

	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void test1_Register() throws Exception {//로그인처리후 동작 가능
		
		log.info("첨부파일 없는 단순 글 등록 테스트");
		log.info("https://dokky.site/board/register");
		
		try {
			 ModelAndView modelAndView = mockMvc
					.perform(MockMvcRequestBuilders.post("/board/register")//POST방식으로 데이터를 전달
					.param("title", "테스트 새글 제목") //전달해야 하는 파라미터들을 지정
					.param("content", "테스트 새글 내용")
					.param("nickName", "슈퍼관리자")
					.param("userId", "admin")
					.param("category", "1"))
					.andReturn().getModelAndView();
			 
			Map<String, Object> map = modelAndView.getModel();
			
			Long board_num = Long.parseLong((String)map.get("board_num"));
			
			BoardVO board = mapper.read(board_num);
			
			String resultPage = modelAndView.getViewName();

			assertEquals(board.getTitle(), "테스트 새글 제목");
			assertEquals(board.getContent(), "테스트 새글 내용");
			assertEquals(board.getNickName(), "슈퍼관리자");
			assertEquals(board.getUserId(), "admin");
			assertEquals(board.getCategory(), 1);
			assertEquals(resultPage, "redirect:/board/get");
			
		} catch (Exception e) {
			log.info("test1_Register() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void test2_Get() throws Exception {
		
		log.info("글 상세페이지 가져오기 테스트");
		
		try {
			
			String board_num = service.getRecentBoard_num().toString();//가장 최근의 글번호
			
			log.info("https://dokky.site/board/get?board_num="+board_num);
			
			BoardVO board = (BoardVO) mockMvc.perform(MockMvcRequestBuilders.get("/board/get").param("board_num", board_num)).andReturn()
					.getModelAndView().getModel().get("board");
			
			log.info("board"+board);
			
			assertNotNull(board);
			
		}catch(Exception e) {
			log.info("test2_Get() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void test3_Modify() throws Exception {//로그인처리후 동작 가능
		
		log.info("첨부파일 없는 게시글 수정 테스트");
		
		try {
			
			Long board_num = service.getRecentBoard_num();
			
			ModelAndView modelAndView = mockMvc
					.perform(MockMvcRequestBuilders.post("/board/modify")
							.param("board_num", board_num.toString())
							.param("title", "수정된 테스트 새글 제목")
							.param("content", "수정된 테스트 새글 내용")
							.param("category", "1")
							.param("userId", "admin"))
					.andReturn().getModelAndView();

			BoardVO board = mapper.read(board_num);
			
			String resultPage = modelAndView.getViewName();
			
			assertEquals(board.getTitle(), "수정된 테스트 새글 제목");
			assertEquals(board.getContent(), "수정된 테스트 새글 내용");
			assertEquals(board.getCategory(), 1);
			assertEquals(resultPage, "redirect:/board/get");
			
		}catch(Exception e) {
			log.info("test3_Modify() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void test4_Remove() throws Exception {
		
		log.info("게시글 삭제 테스트");
		
		try {
			
			String board_num = service.getRecentBoard_num().toString();
			
			mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
					.param("board_num", board_num)
					.param("userId", "admin"));
			
			BoardVO board = mapper.read(Long.parseLong(board_num));
			
			assertNull(board);
			
		}catch(Exception e){
			log.info("test4_Remove() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	

	@Test
	public void testGetAllList() throws Exception {
			
		log.info("전체글보기 리스트 테스트 ");
		
		try {
			
			log.info("https://dokky.site/board/allList?category=0");
			
			log.info(									  //GET 방식의 호출
					mockMvc.perform(MockMvcRequestBuilders.get("/board/allList?category=0"))
					.andReturn()
					.getModelAndView()
					.getModelMap());//모델에 있는 데이터 확인
			
		}catch(Exception e) {
			log.info("testGetAllList() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void testGetLists() throws Exception {
		
		try {
			String[] title = {"공지사항","자유게시판","묻고답하기","칼럼/tech","정기모임/스터디"};
			
			for(int i=1; i<6; i++) {
				
				log.info(title[i-1]+" 글 리스트 테스트");
				
				log.info(									  //GET 방식의 호출
						mockMvc.perform(MockMvcRequestBuilders.get("/board/list?category="+i))
						.andReturn()
						.getModelAndView()
						.getModelMap());//모델에 있는 데이터 확인
			}
		}catch(Exception e) {
			log.info("testGetLists() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	/*@Test
	public void testGetListPaging() throws Exception {//미완성 유닛테스트

		log.info("공지사항 리스트 페이징 테스트 ");
		
		try {
			
			log.info(mockMvc.perform(
					MockMvcRequestBuilders.get("/board/list")
					.param("pageNum", "2")
					.param("category", "1")
					.param("amount", "10"))
					.andReturn().getModelAndView().getModelMap());
			
		}catch(Exception e){
			
			log.info("testGetListPaging() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}*/
}


