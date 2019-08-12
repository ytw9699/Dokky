package org.my.domain;
	import java.util.Date;
	import java.util.List;
	import lombok.Data;

@Data
public class MemberVO {

	private Long member_num;
	private String userId;
	private String userPw;
	private String nickName;
	private String email;
	private String phoneNum;
	private String account;
	private String bankName;
	private Date regDate;
	private Date loginDate;
	private boolean enabled;
	private List<AuthVO> authList;
	
}