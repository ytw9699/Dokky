package org.my.domain;

import java.util.Date;

import lombok.Data;

@Data
//@Builder
public class myUser {
	private String uid;
	private String upw;
	private String uname;
	private Integer upoint;
	
	private String email;
	private String id;
	private String nickname;
	
	private String loginip;
	private Date lastlogin;
	
	public static void main(String[] args) {
		myUser user1 = new myUser();
		user1.setUid("1111111");
		user1.setUname("adsfasfsaf1212121");
		
		myUser user2 = new myUser();
		user2.setUid("1111111");
		user2.setUname("adsfasfsaf");
		System.out.println(user1.equals(user2));
	}
}