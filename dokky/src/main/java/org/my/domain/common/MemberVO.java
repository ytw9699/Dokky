package org.my.domain.common;
	import java.util.Date;
	import java.util.List;
	import lombok.Data;

@Data
public class MemberVO {
	private Long member_num;
	private String userId;
	private String userPw;
	private String nickName;
	private String account;
	private String bankName;
	private Date regDate;
	private Date preLoginDate;
	private Date lastLoginDate;
	private boolean enabled;
	private boolean accountNonLocked;
	private List<AuthVO> authList;
}