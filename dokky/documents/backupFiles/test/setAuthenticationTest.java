/*package org.my.security;
	import static org.junit.Assert.assertNotNull;
	import static org.junit.Assert.fail;
	import java.util.ArrayList;
	import java.util.Iterator;
	import java.util.List;
	import org.junit.FixMethodOrder;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.junit.runners.MethodSorters;
	import org.my.domain.common.AuthVO;
	import org.my.domain.common.MemberVO;
	import org.my.domain.common.CustomUser;
	import org.my.service.MemberService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.core.GrantedAuthority;
	import org.springframework.security.core.authority.SimpleGrantedAuthority;
	import org.springframework.security.core.context.SecurityContextHolder;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.springframework.test.context.web.WebAppConfiguration;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context2.xml",
	"file:src/main/webapp/WEB-INF/spring/security-context.xml"	
})
@Log4j
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class setAuthenticationTest {

	@Setter(onMethod_ = { @Autowired })
	private MemberService memberService;
	
	@Test
	public void test_SetAuthenticationTest() throws Exception {
		
		log.info("test_SetAuthenticationTest");
		
		try {
				String userId = "admin";
					
				MemberVO memberVO = memberService.readMembers(userId);
					
				List<AuthVO> AuthList = memberVO.getAuthList();//사용자의 권한 정보만 list로 가져온다
				
				List<GrantedAuthority> roles = new ArrayList<>(1);//인증해줄 권한 리스트를 만든다
				
				Iterator<AuthVO> it = AuthList.iterator();
			
				while(it.hasNext()) {
						
					AuthVO authVO = it.next(); 
					
					String auth = authVO.getAuth();
					
					if(auth.equals("ROLE_LIMIT")) {
						log.info("접속 제한된 아이디입니다.");
					}
					
					roles.add(new SimpleGrantedAuthority(auth));// 가져온 사용자의 권한을 리스트에 담아준다
				}
				
				Authentication auth = new UsernamePasswordAuthenticationToken(new CustomUser(memberVO), null, roles);//사용자의 인증객체를 만든다
				
				assertNotNull(auth);

				SecurityContextHolder.getContext().setAuthentication(auth);//Authentication 인증객체를 SecurityContext에 보관
			
		} catch (Exception e) {
			
			e.printStackTrace();
			fail(e.getMessage());
		}
	}
}







	
	
	


*/