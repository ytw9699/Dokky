/*
- 마지막 업데이트 2022-05-20
- 사용자 실제 인증 작업
1. 사용자 존재 여부
2. 비밀번호 매칭 여부
3. 계정 비활성 및 접속제한 여부
*/
package org.my.security;
	import org.my.security.domain.CustomUser;
	import org.springframework.security.authentication.AuthenticationProvider;
	import org.springframework.security.authentication.BadCredentialsException;
	import org.springframework.security.authentication.DisabledException;
	import org.springframework.security.authentication.LockedException;
	import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
	import org.springframework.security.core.Authentication;
	import org.springframework.security.core.AuthenticationException;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
	import lombok.extern.log4j.Log4j;

@Log4j
public class CustomAuthenticationProvider implements AuthenticationProvider {
    
	private final CustomUserDetailsService userService;
    private final BCryptPasswordEncoder passwordEncoder;
    
    public CustomAuthenticationProvider(CustomUserDetailsService userService, BCryptPasswordEncoder passwordEncoder) {
    	this.passwordEncoder  = passwordEncoder;
    	this.userService  = userService;
    }
   
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException 
    {
    	log.warn("authenticate");
    		
        String userId = (String)authentication.getPrincipal();    
        String userPassword = (String)authentication.getCredentials();
        
    	CustomUser user = (CustomUser)userService.loadUserByUsername(userId);
			
		if(user == null){
            throw new UsernameNotFoundException(userId);
        }
		
		if(!passwordEncoder.matches(userPassword, user.getPassword())){
            throw new BadCredentialsException(userId);
        }
    	
    	if(!user.isAccountNonLocked()){
            throw new LockedException(userId);
        }
    	
    	if(!user.isEnabled()){
            throw new DisabledException(userId);
        }
         
        return new UsernamePasswordAuthenticationToken(user, userPassword, user.getAuthorities());
    }
     
    @Override
    public boolean supports(Class<?> authentication) 
    {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}


