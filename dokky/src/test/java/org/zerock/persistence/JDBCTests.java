package org.zerock.persistence;
	import static org.junit.Assert.assertNotNull;
	import static org.junit.Assert.fail;
	import java.sql.Connection;
	import java.sql.DriverManager;
	import java.sql.SQLException;
	import org.junit.Test;
	import lombok.extern.log4j.Log4j;

@Log4j
public class JDBCTests {
	//JDBC 드라이버만으로 구현해서 먼저 테스트
		static{//클래스 초기화 블럭 , 생성자보다 먼저 호출
		try {
			Class clz = Class.forName("oracle.jdbc.driver.OracleDriver");//먼저 oracle 드라이버 정상 로딩 확인
			
			log.info(clz);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testConnection() throws SQLException {//간단 jdbc oracle 연결 테스트
		
		Connection con = null;
		
		try {
			   con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "book_ex",
					"book_ex");
			   
			   log.info(con);
			   assertNotNull(con);
			
		} catch (Exception e) {
			fail(e.getMessage());
		}finally {
			con.close();
		}
	}
}
