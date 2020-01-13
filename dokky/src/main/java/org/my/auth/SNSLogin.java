package org.my.auth;
	import org.my.domain.MemberVO;
	import com.fasterxml.jackson.databind.JsonNode;
	import com.fasterxml.jackson.databind.ObjectMapper;
	import com.github.scribejava.core.builder.ServiceBuilder;
	import com.github.scribejava.core.model.OAuth2AccessToken;
	import com.github.scribejava.core.model.OAuthRequest;
	import com.github.scribejava.core.model.Response;
	import com.github.scribejava.core.model.Verb;
	import com.github.scribejava.core.oauth.OAuth20Service;

public class SNSLogin {
	
	private OAuth20Service oauthService;
	private SnsValue sns;
	
	public SNSLogin(SnsValue sns) {
		
		this.oauthService = new ServiceBuilder(sns.getClientId())
	                .apiSecret(sns.getClientSecret())
	                .scope("profile")
	                .callback(sns.getRedirectUrl())
	                .build(sns.getApi20Instance());
		
		this.sns = sns;
	}
	
	public String getAuthURL() {
		return this.oauthService.getAuthorizationUrl();
	}

	public MemberVO getUserProfile(String code) throws Exception {
		
		OAuth2AccessToken accessToken = oauthService.getAccessToken(code);// 1. code를 이용해서 access_token 받기
		
		OAuthRequest request = new OAuthRequest(Verb.GET, this.sns.getProfileUrl());
		
		oauthService.signRequest(accessToken, request);//2. access_token을 이용해서 사용자 profile 정보 가져오기
		
		Response response = oauthService.execute(request);
		
		return parseJson(response.getBody());
	}
	
	private MemberVO parseJson(String body) throws Exception {
		
		MemberVO user = new MemberVO();
		
		ObjectMapper mapper = new ObjectMapper();
		
		JsonNode rootNode = mapper.readTree(body);
		
		if (this.sns.isGoogle()) {
			
			String id = rootNode.get("sub").asText();
			
			user.setUserId(id);
			
			user.setNickName(rootNode.get("name").asText());
			
		}else if (this.sns.isNaver()) {
				
			JsonNode node = rootNode.get("response");
			
			user.setUserId(node.get("id").asText());
			
			user.setNickName(node.get("nickname").asText());
			
			//user.setEmail(node.get("email").asText());
		}
	
		return user;
	}
	
}