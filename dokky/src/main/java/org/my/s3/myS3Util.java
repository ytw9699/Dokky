package org.my.s3;
	import java.io.ByteArrayInputStream;
	import java.io.File;
	import java.io.FileNotFoundException;
	import java.io.FileOutputStream;
	import java.io.InputStream;
	import java.text.SimpleDateFormat;
	import java.util.Date;
	import java.util.List;
	import java.util.UUID;
	
	import org.my.domain.AttachFileDTO;
	import org.springframework.stereotype.Component;
	import org.springframework.web.multipart.MultipartFile;
	
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
	import com.amazonaws.services.s3.model.AmazonS3Exception;
	import com.amazonaws.services.s3.model.CannedAccessControlList;
	import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
	import com.amazonaws.services.s3.model.ObjectMetadata;
	import com.amazonaws.services.s3.model.PutObjectRequest;
	import com.amazonaws.services.s3.model.PutObjectResult;
	
	import lombok.extern.log4j.Log4j;
	import net.coobird.thumbnailator.Thumbnailator;

@Log4j
@Component
public class myS3Util {
	
	String bucket_name = "picksell-bucket";
	String folder_name;
	AmazonS3 s3;
	
	
	public myS3Util() {
		
			 s3 = AmazonS3ClientBuilder.
									 standard().
			 withRegion(Regions.AP_NORTHEAST_2).
										build();
	}
	
	public AttachFileDTO fileUpload(String fileName, byte[] fileData, String uploadKind) throws FileNotFoundException {
		
			createFolder();
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			
			attachDTO.setFileName(fileName);//오리지날 이름 저장
			
			UUID uuid = UUID.randomUUID();
			
			fileName = uuid.toString() + "_" + fileName;
			
			attachDTO.setUuid(uuid.toString());//uuid저장
			
			attachDTO.setUploadPath(folder_name);//폴더 경로저장
			
			if(uploadKind.equals("photo")) {
				
					attachDTO.setImage(true);
			}
			
			ObjectMetadata metaData = new ObjectMetadata();
			
			metaData.setContentLength(fileData.length);   //메타데이터 설정 -->원래는 128kB까지 업로드 가능했으나 파일크기만큼 버퍼를 설정시켰다.
		   
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(fileData); //파일 넣음
			
		    //s3.putObject(bucket_name + "/" + folder_name, fileName, byteArrayInputStream, metaData);//퍼블릭 없이 디폴트로 설정해서 업로드
		    
		    PutObjectRequest putObjectRequest = new PutObjectRequest(bucket_name + "/" + folder_name, fileName, byteArrayInputStream, metaData);
		    
	        putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead); // 파일의 권한 퍼블릭으로 설정
	        
	        s3.putObject(putObjectRequest); // upload file
	        
		    String url = s3.getUrl(bucket_name + "/" + folder_name, fileName).toString();
		    
		    attachDTO.setDownUrl(url);
		    
		    //attachDTO.setDownUrl(s3.generatePresignedUrl(new GeneratePresignedUrlRequest(bucket_name + "/" + folder_name, fileName)).toString());
		    
		    return attachDTO;
	}
		
	public void createFolder() {
		
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	
			Date date = new Date();
	
			String str = sdf.format(date);
			
			folder_name = "upload/" + str;
			
			try {
					if (s3.doesBucketExist(bucket_name + "/" + folder_name)) {
				        
				    	System.out.format("폴더가 이미 있음");
				    	
				    }else {
				    	
			    		s3.putObject(bucket_name, folder_name + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());
			    		
			    		System.out.format("폴더 생성 완료");
			    	}
				    
			}catch(AmazonS3Exception e) {
	    		
	    		System.out.println(e.getErrorMessage());
	    	}
	}
}