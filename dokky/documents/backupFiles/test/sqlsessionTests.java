package org.my.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
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
        "file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
@Log4j
public class sqlsessionTests {

    @Setter(onMethod_ = {@Autowired})
    private SqlSessionFactory sqlSessionFactory;

    @Test
    public void testMyBatis() {//SqlSessionFactoryBean을 이용해서 SqlSession을 사용해 보는 테스트
        //프로젝트는 이 SQLSession을 통해서 Connection을 생성하거나 원하는 SQL을 전달하고, 결과를 리턴 받을것
        try (SqlSession session = sqlSessionFactory.openSession();
             Connection con = session.getConnection();
        ) {

            log.info("session객체 출력");// org.apache.ibatis.session.defaults.DefaultSqlSession@9fec931
            log.info(session);
            log.info("Connection객체 출력");//HikariConnectionProxy(2097989776) wrapping net.sf.log4jdbc.sql.jdbcapi.ConnectionSpy@49293b43
            log.info(con);

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }
}


