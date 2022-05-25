package org.my.mapper;
	import static org.junit.Assert.assertNotNull;
	import org.junit.Test;
	import org.junit.runner.RunWith;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import org.my.domain.MemberVO;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	  "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	  "file:src/main/webapp/WEB-INF/spring/security-context.xml"
	  })
@Log4j
public class MemberMapperTests{

	@Autowired 
	private MemberMapper memberMapper;
	
	@Test
	public void testReadMember(){// MemberVO 가져오는지 확인후, resultmap사용해서 맵핑이 잘 되어 리스트에 담겼는지 체크
		
		MemberVO memberVO = memberMapper.readMembers("admin");
		
		log.info(memberVO);
		
		assertNotNull(memberVO.getAuthList());
	}
}
