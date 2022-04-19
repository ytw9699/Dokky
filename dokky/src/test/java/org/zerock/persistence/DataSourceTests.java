package org.zerock.persistence;
	import static org.junit.Assert.fail;
	import java.sql.Connection;
	import javax.sql.DataSource;
	import org.apache.ibatis.session.SqlSession;
	import org.apache.ibatis.session.SqlSessionFactory;
	import org.junit.Test;
	import org.junit.runner.RunWith;
import org.my.mapper.BoardMapperTests;
import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.test.context.ContextConfiguration;
	import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
	import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	  "file:src/main/webapp/WEB-INF/spring/root-context.xml",
	  "file:src/main/webapp/WEB-INF/spring/security-context.xml"
	  })
@Log4j
public class DataSourceTests {

	  @Autowired // 필드주입 빠른 테스트
	  private DataSource dataSource;
	
	  @Autowired
	  private SqlSessionFactory sqlSessionFactory;
	  
	  @Test
	  public void testConnection() {
		  
	    try (Connection con = dataSource.getConnection()){
	    	//스프링에 빈으로 등록된 dataSource를 이용해서 Connection을 제대로 처리할 수 있는지를 확인해 보는 용도,
	
	      log.info(con);//내부적으로 HikariCP가 시작되고，종료되는 로그를 확인
	      
	    }catch(Exception e) {
	      fail(e.getMessage());
	    }
	  }
	 
	  @Test
	  public void testMyBatis() {
		  //MyBatis의 SqlSessionFactoryBean을 이용해서 SqlSession을 사용해 보고 디비 Connection객체 까지 얻어내는 테스트

		  try (SqlSession session = sqlSessionFactory.openSession();
		     Connection con = session.getConnection();
		    ) {
	
		    log.info(session);
		    log.info(con);	    //close작업은 오토로 될것임.
		  } catch (Exception e) {
		    fail(e.getMessage());
		  }
	  }
}
  


