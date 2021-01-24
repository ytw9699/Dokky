package org.my.controller;
	import static org.junit.Assert.assertEquals;
	import static org.junit.Assert.fail;
	import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
	import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
	import org.junit.Before;
	import org.junit.FixMethodOrder;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.junit.runners.MethodSorters;
	import org.my.domain.ReplyVO;
	import org.my.domain.commonVO;
	import org.my.mapper.BoardMapper;
	import org.my.mapper.ReplyMapper;
	import org.my.service.BoardService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.http.MediaType;
	import org.springframework.security.test.context.support.WithMockUser;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.springframework.test.context.web.WebAppConfiguration;
	import org.springframework.test.web.servlet.MockMvc;
	import org.springframework.test.web.servlet.setup.MockMvcBuilders;
	import org.springframework.web.context.WebApplicationContext;
	import com.google.gson.Gson;
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
public class ReplyControllerTests {

	@Setter(onMethod_ = { @Autowired })
	private WebApplicationContext ctx;
	
	@Setter(onMethod_ = { @Autowired })
	private BoardService service;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replyMapper;
	
	private MockMvc mockMvc; 
							 
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void test1_ReplyRegister() throws Exception {//로그인처리후 동작 가능
		
		log.info("가장 최근의 자신의 글에 일반적인 댓글 등록 테스트");
		log.info("https://dokky.site/replies/new");
		
		try {
			
			Long board_num = service.getRecentBoard_num();
			
			ReplyVO replyVO = new ReplyVO();
			
			replyVO.setReply_content("댓글 테스트 내용");
			replyVO.setUserId("admin");
			replyVO.setNickName("슈퍼관리자");
			replyVO.setBoard_num(board_num);
				
			commonVO commonVO = new commonVO();
			
			commonVO.setReplyVO(replyVO);
			
			String jsonStr = new Gson().toJson(commonVO);
			
			log.info("jsonStr"+jsonStr);
		
			mockMvc.perform(post("/replies/reply")
				        .contentType(MediaType.APPLICATION_JSON)
				        .content(jsonStr))
				        .andExpect(status().is(200));
			
			Long reply_num = replyMapper.getRecentReply_num();
			
			ReplyVO vo = replyMapper.read(reply_num);
			
			log.info("ReplyVO="+vo);
			
			assertEquals(vo.getReply_content(), "댓글 테스트 내용");
			assertEquals(vo.getUserId(), "admin");
			assertEquals(vo.getNickName(), "슈퍼관리자");
			assertEquals(vo.getBoard_num(), board_num);
			
		}catch(Exception e) {
			log.info("test1_ReplyRegister() 테스트 실패");
			e.printStackTrace();
			fail(e.getMessage());
		}
		
	}
}


