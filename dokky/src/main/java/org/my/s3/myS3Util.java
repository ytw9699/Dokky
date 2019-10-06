package org.my.s3;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.AmazonS3Exception;
import com.amazonaws.services.s3.model.ObjectMetadata;

import lombok.extern.log4j.Log4j;

@Log4j
public class myS3Util {
	
	String bucket_name = "picksell-bucket/upload";
	AmazonS3 s3;
	
	public myS3Util() {
			 s3 = AmazonS3ClientBuilder.
									 standard().
			 withRegion(Regions.AP_NORTHEAST_2).
										build();
	}
	
	//File uploadPath = new File(uploadFolder, uploadFolderPath);
	//String key_name ;
	//List<AttachFileDTO> list = new ArrayList<>();  
	
	// 파일 업로드
	
	public void fileUpload(String fileName, byte[] fileData, String uploadKind) throws FileNotFoundException {
		
		createFolder();
		
		String filePath = (fileName).replace(File.separatorChar, '/'); // 파일 구별자를 `/`로 설정(\->/) 이게 기존에 / 였어도 넘어오면서 \로 바뀌는 거같다.
		ObjectMetadata metaData = new ObjectMetadata();

		metaData.setContentLength(fileData.length);   //메타데이터 설정 -->원래는 128kB까지 업로드 가능했으나 파일크기만큼 버퍼를 설정시켰다.
	    ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(fileData); //파일 넣음

	    s3.putObject(bucket_name, filePath, byteArrayInputStream, metaData);
		
	}
		
	public void createFolder() {
		
		String uploadFolderPath = getFolder();
		
		try {
			
			if (s3.doesBucketExist(bucket_name + uploadFolderPath) == false) {
				s3.putObject(bucket_name, uploadFolderPath + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());//폴더생성
			}
			
		}catch(AmazonS3Exception e) {
			
			log.info(e.getErrorMessage());
		}
		
	}
	
	public String getFolder() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	
		Date date = new Date();
	
		String str = sdf.format(date);
	
		return str;
	}
}