package org.my.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;
import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
        "file:src/main/webapp/WEB-INF/spring/root-context.xml",
        "file:src/main/webapp/WEB-INF/spring/security-context.xml"//시큐리티 설정 까지 안불러오면 연관된 빈생성이 안되는것같다 mypageServiceImpl에서 에러
})
@Log4j
public class DataSourceTests {

    @Setter(onMethod_ = {@Autowired})
    private DataSource dataSource;

    @Test
    public void testConnection() {

        try (Connection con = dataSource.getConnection()) {

            log.info(con);

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }
		  /*스프링에 빈으로 등록된 dataSource를 이용해서 Connection을
		  	제대로 처리할 수 있는지를 확인해 보는 용도, 
		  	내부으로 hikariConfig가 시작되고, 종료되는 로그를 확인가능
		  	INFO : org.springframework.context.support.GenericApplicationContext - 
			Closing org.springframework.context.support.GenericApplicationContext@45820e51: 
	  		startup date [Mon Apr 20 22:17:45 KST 2020]; root of context hierarchy
			INFO : com.zaxxer.hikari.pool.HikariPool - HikariCP pool HikariPool-0 is shutting down.
		  	*/

}


