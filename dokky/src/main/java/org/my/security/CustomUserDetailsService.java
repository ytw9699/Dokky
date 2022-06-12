/*
- 마지막 업데이트 2022-05-18
- UserDetailsService 사용자의 정보와 권한을 DB에서 조회해서 AuthenticationProvider로 반환하는 역할
*/
package org.my.security;
	import org.my.security.domain.CustomUser;
	import org.my.service.MemberService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.core.userdetails.UserDetails;
	import org.springframework.security.core.userdetails.UserDetailsService;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import org.my.domain.MemberVO;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService  {

	@Setter(onMethod_ = @Autowired)
	private MemberService memberService;

	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("Load User By UserName : " + userName);
		
		MemberVO vo = memberService.readMembers(userName);
				
		log.warn("MemberVO = " + vo);
		
		return vo == null ? null : new CustomUser(vo);
		
	} 
}
