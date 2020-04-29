package org.my.controller;
	import org.junit.Before;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.my.service.BoardService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.springframework.test.context.web.WebAppConfiguration;
	import org.springframework.test.web.servlet.MockMvc;
	import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
	import org.springframework.test.web.servlet.setup.MockMvcBuilders;
	import org.springframework.web.context.WebApplicationContext;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	import static org.junit.Assert.fail;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration//WebApplicationContext를 이용하기 위해서
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml", 
	"file:src/main/webapp/WEB-INF/spring/security-context.xml"	
})
@Log4j
public class BoardControllerTests {

	@Setter(onMethod_ = { @Autowired })
	private WebApplicationContext ctx;//스프링 객체 컨테이너
	
	@Setter(onMethod_ = { @Autowired })
	private BoardService service;
	
	private MockMvc mockMvc; //가짜 mvc라고 생각
							 //가짜로URL과 파라미터 등을 브라우저에서 사용하는 것처럼 만들어서 Controller를 실행

	@Before//모든 테스트 전에 매번 실행되는 메서드
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void testRegister() throws Exception {//로그인처리후 동작 가능
		
		log.info("첨부파일 없는 단순 글 등록 테스트");
		log.info("https://dokky.ga/board/register");
		
		try {
			String resultPage = mockMvc
					.perform(MockMvcRequestBuilders.post("/board/register")//POST방식으로 데이터를 전달
					.param("title", "테스트 새글 제목") //전달해야 하는 파라미터들을 지정
					.param("content", "테스트 새글 내용")
					.param("nickName", "슈퍼관리자")
					.param("userId", "admin")
					.param("category", "1"))
					.andReturn().getModelAndView().getViewName();
			
			log.info("resultPage="+resultPage);//resultPage=redirect:/board/get
			
		} catch (Exception e) {
			log.info("testRegister() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void testGet() throws Exception {
		
		log.info("글 상세페이지 가져오기 테스트");
		
		try {
			
			String board_num = service.getBoard_num().toString();//가장 최근의 글번호 가져오기, 하지만 테스트에서 register한 번호를 못가져옴
			
			log.info("https://dokky.ga/board/get?board_num="+board_num);
			
			log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/get").param("board_num", board_num)).andReturn()
					.getModelAndView().getModelMap());
			
		}catch(Exception e) {
			log.info("testGet() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void testModify() throws Exception {//로그인처리후 동작 가능
		
		log.info("첨부파일 없는 게시글 수정 테스트");
		
		try {
			
			String board_num = service.getBoard_num().toString();
			
			String resultPage = mockMvc
					.perform(MockMvcRequestBuilders.post("/board/modify")
							.param("board_num", board_num)
							.param("title", "수정된 테스트 새글 제목")
							.param("content", "수정된 테스트 새글 내용")
							.param("category", "1")
							.param("userId", "admin"))
					.andReturn().getModelAndView().getViewName();

			log.info("resultPage="+resultPage);
			
		}catch(Exception e) {
			log.info("testModify() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void testRemove() throws Exception {
		
		log.info("게시글 삭제 테스트");
		
		try {
			
			String board_num = service.getBoard_num().toString();
			
			String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
					.param("board_num", board_num)
					.param("userId", "admin"))
					.andReturn()
					.getModelAndView().getViewName();

			log.info("resultPage="+resultPage);
			
		}catch(Exception e){
			log.info("testRemove() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
	
	@Test
	public void testGetAllList() throws Exception {
			
		log.info("전체글보기 리스트 테스트 ");
		
		try {
			
			log.info("https://dokky.ga/board/allList?category=0");
			
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
	
}


