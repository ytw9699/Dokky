/*
- 마지막 업데이트 2022-06-12
*/
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
	private myS3Util myS3Util;
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
    
	public DownloadView() {//생성자
		setContentType("application/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		myS3Util.fileDownload(request, response , getContentType());
	}
}