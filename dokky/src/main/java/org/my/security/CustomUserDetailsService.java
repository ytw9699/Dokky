package org.my.security;
	import org.my.security.domain.CustomUser;
	import org.my.service.MemberService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.authentication.BadCredentialsException;
	import org.springframework.security.core.userdetails.UserDetails;
	import org.springframework.security.core.userdetails.UserDetailsService;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import java.util.List;
	import org.my.domain.AuthVO;
	import org.my.domain.MemberVO;
	import org.my.mapper.MemberMapper;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {

	@Setter(onMethod_ = { @Autowired })
	private MemberMapper memberMapper;
	
	@Setter(onMethod_ = @Autowired)
	private MemberService memberService;

	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("Load User By UserName(userId) : " + userName);// userName means userId
		
		MemberVO vo = memberMapper.read(userName);// userName means userId
		
		log.warn("queried by member mapper: " + vo);
		
		if(vo == null ) {
			throw new BadCredentialsException("NULL");
		}
		else if(vo != null) { 
			
			List<AuthVO> AuthList = vo.getAuthList(); 
			
			for(AuthVO authvo : AuthList){
				if(authvo.getAuth().equals("ROLE_LIMIT"))
					throw new BadCredentialsException("limit");
			}
		}
		
		memberService.updateLoginDate(userName); //로긴날짜찍기
		
		return new CustomUser(vo);
	} 
}

  
