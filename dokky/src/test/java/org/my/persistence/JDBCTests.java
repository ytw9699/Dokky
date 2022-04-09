package org.my.persistence;
	import static org.junit.Assert.fail;
	import java.sql.Connection;
	import java.sql.DriverManager;
	import org.junit.Test;
	import lombok.extern.log4j.Log4j;
	
@Log4j
public class JDBCTests {//데이터베이스 연결 테스트,Java와 JDBC 드라이버만으로 구현해서 먼저 테스트

	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testConnection() {

		try(Connection con = DriverManager.getConnection(
				"jdbc:log4jdbc:oracle:thin:@dokkyrds.ckzbvzytxsry.ap-northeast-2.rds.amazonaws.com:1521:ORCL",
				"DokkyRdsAdmin",
				"비밀번호"
			)) {
			
			log.info("데이터베이스 연결 테스트, 정상시 Connection객체 출력");
			log.info(con);//net.sf.log4jdbc.sql.jdbcapi.ConnectionSpy@41e36e46
			log.info("데이터베이스 연결 테스트, 정상시 Connection객체 출력");
			
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}
}
