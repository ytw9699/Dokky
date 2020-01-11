package org.my.auth;
	import java.util.Iterator;
	import org.my.domain.myUser;
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

	public myUser getUserProfile(String code) throws Exception {
		
		OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
		
		OAuthRequest request = new OAuthRequest(Verb.GET, this.sns.getProfileUrl());
		
		oauthService.signRequest(accessToken, request);
		
		Response response = oauthService.execute(request);
		
		return parseJson(response.getBody());
	}
	
	private myUser parseJson(String body) throws Exception {
		
		System.out.println("============================\n" + body + "\n==================");
		
		myUser user = new myUser();
		
		ObjectMapper mapper = new ObjectMapper();
		
		JsonNode rootNode = mapper.readTree(body);
		
		if (this.sns.isGoogle()) {
			
			String id = rootNode.get("id").asText();
			
			if (sns.isGoogle()){
				user.setId(id);
			}
			
			user.setNickname(rootNode.get("displayName").asText());
			
			JsonNode nameNode = rootNode.path("name");
			
			String uname = nameNode.get("familyName").asText() + nameNode.get("givenName").asText();
			
			//user.setUname(uname);

			Iterator<JsonNode> iterEmails = rootNode.path("emails").elements();
			
			while(iterEmails.hasNext()) {
				
				JsonNode emailNode = iterEmails.next();
				
				String type = emailNode.get("type").asText();
				
				if (type.equals("account")) {
					
					user.setEmail(emailNode.get("value").asText());
					break;
				}
			}
			
			
		}else if (this.sns.isNaver()) {
				
			JsonNode resNode = rootNode.get("response");
			
			user.setId(resNode.get("id").asText());
			
			user.setNickname(resNode.get("nickname").asText());
			
			user.setEmail(resNode.get("email").asText());
		}
	
		return user;
	}
	
}