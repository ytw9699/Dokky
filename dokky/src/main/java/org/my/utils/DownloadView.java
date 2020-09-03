package org.my.utils;
	import java.util.Map;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.s3.myS3Util;
	import org.my.service.CommonService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Component;
	import org.springframework.web.servlet.view.AbstractView;
	import lombok.Setter;
		
@Component
public class DownloadView extends AbstractView {//AbstractView를 상속
	
	@Setter(onMethod_ = @Autowired)
	private myS3Util s3Util;
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
    
	public DownloadView() {//생성자
		setContentType("application/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		if(request.getServerName().equals("localhost")){//테스트 환경이 로컬호스트라면
			
			myS3Util localS3Util = new myS3Util(commonService);
			
			localS3Util.fileDownload(request, response, getContentType());
			
		}else {
			
			s3Util.fileDownload(request, response , getContentType());
		}
	}
}