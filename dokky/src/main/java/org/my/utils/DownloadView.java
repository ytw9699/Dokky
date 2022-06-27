/*
- 마지막 업데이트 2022-06-12
*/
package org.my.utils;
	import java.util.Map;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.service.CommonService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.web.servlet.view.AbstractView;
	import lombok.Setter;
		
public class DownloadView extends AbstractView {//AbstractView를 상속
	
	@Setter(onMethod_ = @Autowired)
	private S3util S3util;
	
	@Setter(onMethod_ = @Autowired)
	private CommonService commonService;
    
	public DownloadView() {//생성자
		setContentType("application/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		S3util.fileDownload(request, response , getContentType());
	}
}