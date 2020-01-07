package org.my.domain;

import java.util.Date;

import lombok.Data;

@Data
//@Builder
public class User {
	private String uid;
	private String upw;
	private String uname;
	private Integer upoint;
	
	private String email;
	private String googleid;
	private String naverid;
	private String nickname;
	
	private String loginip;
	private Date lastlogin;
	
	public static void main(String[] args) {
		User user1 = new User();
		user1.setUid("1111111");
		user1.setUname("adsfasfsaf1212121");
		
		User user2 = new User();
		user2.setUid("1111111");
		user2.setUname("adsfasfsaf");
		System.out.println(user1.equals(user2));
	}
}