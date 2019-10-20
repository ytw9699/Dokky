package org.my.utils;
	import java.io.IOException;
	import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.s3.myS3Util;
	import org.springframework.stereotype.Component;
	import org.springframework.web.servlet.view.AbstractView;
	import com.amazonaws.auth.AWSCredentials;
	import com.amazonaws.auth.AWSStaticCredentialsProvider;
	import com.amazonaws.auth.BasicAWSCredentials;
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
	import com.amazonaws.services.s3.model.S3Object;
	import com.amazonaws.services.s3.model.S3ObjectInputStream;

		
@Component
public class DownloadView extends AbstractView {//AbstractView를 상속
	
	//private static final String ACCESS_KEY = "AKIA47S6HNIPBSOVXPXH";
    //private static final String SECRET_KEY = "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";
    
	public DownloadView() {//생성자
		setContentType("application/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
		
		 //AWSCredentials awsCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);// 인증 객체를 생성한다.
		 
		/* final AmazonS3 s3  = AmazonS3ClientBuilder.standard().
	                withRegion(Regions.AP_NORTHEAST_2).
	                withCredentials(new AWSStaticCredentialsProvider(awsCredentials)).
				    build();*/
		
		String bucket_name = "picksell-bucket";
		String path = request.getParameter("path");
		String filename = request.getParameter("filename");
		
		System.out.println(filename); 
		
		String uuid = request.getParameter("uuid");
		
		try {
		
			S3Object s3Object = s3.getObject(bucket_name + "/" + path, uuid+"_"+filename);
			
			response.setContentType(getContentType());//리스폰스에 설정//다운로드타입이어야하니까
			
			response.setContentLength((int)s3Object.getObjectMetadata().getContentLength());//파일 크기설정
			
			String userAgent = request.getHeader("User-Agent");
			
			boolean ie = userAgent.indexOf("MSIE") > -1;
		
			if (ie) {
				filename = URLEncoder.encode(filename, "UTF-8");
			} else {
				filename = new String(filename.getBytes("UTF-8"),"iso-8859-1");
			}
			
			response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\";");//다운로드할때의 파일이름설정을 해줘야한다!
			
			response.setHeader("Content-Transfer-Encoding", "binary");//인코딩설정
			
			S3ObjectInputStream s3ObjectInputStream = s3Object.getObjectContent();
			
			OutputStream out = response.getOutputStream();//아웃풋스트림객체얻어내고
			
			byte[] bytesArray = new byte[4096];
			
			int bytesRead = -1;
			
			while ((bytesRead = s3ObjectInputStream.read(bytesArray)) != -1) {
				out.write(bytesArray, 0, bytesRead);
			}
			
			out.close();
			s3ObjectInputStream.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}