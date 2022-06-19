package org.my.auth;
	import com.github.scribejava.apis.GoogleApi20;
	import com.github.scribejava.core.builder.api.DefaultApi20;
	import lombok.Data;

@Data
public class SnsValue implements SnsUrls {//SnsValue는 중요 값들을 가지고있는것이다.
	
	private String service; 
	private String clientId;
	private String clientSecret;
	private String redirectUrl;
	private DefaultApi20 api20Instance;
	private String profileUrl;
	private boolean isGoogle;
	private boolean isNaver;
	
	public SnsValue(String service, String clientId, String clientSecret, String redirectUrl) {
		
		this.service = service;
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.redirectUrl = redirectUrl;
		
		this.isGoogle = "google".equalsIgnoreCase(this.service);
		this.isNaver = "naver".equalsIgnoreCase(this.service);
		
		if(isNaver) {
			
			this.api20Instance = NaverAPI20.instance();
			this.profileUrl = NAVER_PROFILE_URL;
			
		}else if (isGoogle) {
			
			this.api20Instance = GoogleApi20.instance();
			this.profileUrl = GOOGLE_PROFILE_URL;
		}
		
	}
}
	
