package org.my.security;
	import static org.junit.Assert.fail;
	import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
	import org.junit.Before;
	import org.junit.FixMethodOrder;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.junit.runners.MethodSorters;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.springframework.test.context.web.WebAppConfiguration;
	import org.springframework.test.web.servlet.MockMvc;
	import org.springframework.test.web.servlet.setup.MockMvcBuilders;
	import org.springframework.web.context.WebApplicationContext;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration//WebApplicationContext를 이용하기 위해서
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml", 
	"file:src/main/webapp/WEB-INF/spring/security-context.xml"	
})
@Log4j
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class adminLoginTest {

	@Setter(onMethod_ = { @Autowired })
	private WebApplicationContext ctx;//스프링 객체 컨테이너
	
	private MockMvc mockMvc;
							 
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void test_adminLogin() throws Exception {
		
		log.info("test_adminLogin");
		
		try {
			 
			 log.info("formLogin");
			 log.info( mockMvc.perform(formLogin("/login").user("admin").password("dokky")));
			
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
}


