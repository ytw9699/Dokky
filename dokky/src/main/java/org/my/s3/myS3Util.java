package org.my.s3;
	import java.io.BufferedOutputStream;
	import java.io.ByteArrayInputStream;
	import java.io.File;
	import java.io.FileNotFoundException;
	import java.io.FileOutputStream;
	import java.io.IOException;
	import java.io.InputStream;
	import java.io.OutputStream;
	import java.text.SimpleDateFormat;
	import java.util.Date;
	import java.util.List;
	import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.my.domain.AttachFileDTO;
	import org.springframework.stereotype.Component;
	import org.springframework.web.multipart.MultipartFile;
	import com.amazonaws.AmazonServiceException;
	import com.amazonaws.auth.AWSCredentials;
	import com.amazonaws.auth.AWSStaticCredentialsProvider;
	import com.amazonaws.auth.BasicAWSCredentials;
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
	import com.amazonaws.services.s3.model.AmazonS3Exception;
	import com.amazonaws.services.s3.model.CannedAccessControlList;
	import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
	import com.amazonaws.services.s3.model.ObjectListing;
	import com.amazonaws.services.s3.model.ObjectMetadata;
	import com.amazonaws.services.s3.model.PutObjectRequest;
	import com.amazonaws.services.s3.model.PutObjectResult;
	import com.amazonaws.services.s3.model.S3Object;
	import com.amazonaws.services.s3.model.S3ObjectInputStream;
	import com.amazonaws.services.s3.model.S3ObjectSummary;
	import lombok.extern.log4j.Log4j;
	import net.coobird.thumbnailator.Thumbnailator;

@Log4j
@Component
public class myS3Util {
	
	String bucket_name = "dokky-bucket";
	String folder_name;
	AmazonS3 s3;
	
	public myS3Util() {
		
			 s3 = AmazonS3ClientBuilder.
									 standard().
			 withRegion(Regions.AP_NORTHEAST_2).
										build();
			 
			 /*String ACCESS_KEY = "";
	         String SECRET_KEY = "";
		         
	   AWSCredentials awsCredentials = 
			   new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);// 인증 객체를 생성한다.
	   
				final AmazonS3 s3 = AmazonS3ClientBuilder.standard().
					                withRegion(Regions.AP_NORTHEAST_2).
					                withCredentials(new AWSStaticCredentialsProvider(awsCredentials)).
								    build();*/
	}
	
	public AttachFileDTO fileUpload(String fileName, MultipartFile multipartFile, String uploadKind) throws FileNotFoundException {
		
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
			
			File uploadFile = new File(fileName);

			try {
				FileUtils.writeByteArrayToFile(uploadFile, multipartFile.getBytes());
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			
			PutObjectRequest putObjectRequest = new PutObjectRequest(bucket_name + "/" + folder_name, fileName, uploadFile);
		    
	        putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead); // 파일의 권한 퍼블릭으로 설정
	        
	        s3.putObject(putObjectRequest); // upload file
	        
		    String url = s3.getUrl(bucket_name + "/" + folder_name, fileName).toString();
		    
		    attachDTO.setDownUrl(url);
		    
		    //attachDTO.setDownUrl(s3.generatePresignedUrl(new GeneratePresignedUrlRequest(bucket_name + "/" + folder_name, fileName)).toString());
		  
		    return attachDTO;
	}
	
	public AttachFileDTO fileUpload2(String fileName, byte[] fileData, String uploadKind) throws FileNotFoundException {
		
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
	
	public String getPresignedUrl(String folder_path, String fileName) {
		
		return s3.generatePresignedUrl(new GeneratePresignedUrlRequest(bucket_name + "/" + folder_path, fileName)).toString();
	}

	
	public void downloadObject(String folder_name, String objectName) {
		
			String downloadPath = "C:\\Users\\champ\\Downloads\\";
			
			try {
	    		
	    		S3Object s3Object = s3.getObject(bucket_name + "/" + folder_name, objectName);

    		    objectName = objectName.substring(objectName.indexOf("_") + 1);//uuid제거
	    		
			    S3ObjectInputStream s3ObjectInputStream = s3Object.getObjectContent();
			    
			    OutputStream outputStream = new BufferedOutputStream(new FileOutputStream(downloadPath + objectName));
			    
			    byte[] bytesArray = new byte[4096];
			    
			    int bytesRead = -1;
			    
			    while ((bytesRead = s3ObjectInputStream.read(bytesArray)) != -1) {
			        outputStream.write(bytesArray, 0, bytesRead);
			    }
	
			    outputStream.close();
			    s3ObjectInputStream.close();
			    
			    System.out.format("Object %s has been downloaded.\n", objectName);
	    		
	    	} catch (AmazonServiceException e) {
	    	    System.err.println(e.getErrorMessage());
	    	    System.exit(1);
	    	} catch (FileNotFoundException e) {
	    	    System.err.println(e.getMessage());
	    	    System.exit(1);
	    	} catch (IOException e) {
	    	    System.err.println(e.getMessage());
	    	    System.exit(1);
	    	}
	}
	
	
	public void deleteObject(String folder_name, String objectName) {
		
		try {
    		s3.deleteObject(bucket_name + "/" +folder_name, objectName);
    		System.err.println("삭제 완료");
    		
    	}catch(AmazonServiceException e) {
    		
	    	System.err.println(e.getErrorMessage());
	    	System.exit(1);
    		
    	}
	}
	
	public void createBucket(String bucket_name) {
		
		try {
    		s3.createBucket(bucket_name);
    		
    		System.out.println("버킷 생성완료");
    		
    	}catch(AmazonS3Exception e) {
    		
    		System.out.println(e.getErrorMessage());
    	}
	}
	
	public void uploadFile1(String folder_name, String key_name, String file_path) {
		
    	try {
    		s3.putObject(bucket_name + "/"+  folder_name, key_name, new File(file_path));
    		System.err.println("업로드 완료");
    		
    	}catch(AmazonServiceException e) {
    		
	    	System.err.println(e.getErrorMessage());
	    	System.exit(1);
    	}
	}
	
	public void uploadFile2(String folder_name, String key_name, String file_path) {
			
		if (s3 != null) {
            try {
            	// 파일 업로드를 위한 request 객체를 생성 하였다.
                PutObjectRequest putObjectRequest =
                        new PutObjectRequest(bucket_name + "/"+  folder_name, key_name ,new File(file_path) );
              //request 객체 안에 BUCKET_NAME + "생성 될 폴더 이름", 파일 원본이름, File 바이너리 데이터 를 설정하였다.ㅏ
                putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead); 
                // Access List 를 설정 하는 부분이다. 공개 조회가 가능 하도록 public Read 로 설정 하였다.
                s3.putObject(putObjectRequest); // upload file
             // 실제로 업로드 할 액션이다.
                System.err.println("업로드 완료");
                
            } catch (AmazonServiceException ase) {
                ase.printStackTrace();
                System.exit(1);
                
            } finally {
            	s3 = null;
            }
        }
	}
	
	public void getObjectsList(String folder_name) {
		
		ObjectListing ObjectList = s3.listObjects(bucket_name);
    	
    	List<S3ObjectSummary> objects =  ObjectList.getObjectSummaries();
    	
    	for(S3ObjectSummary os : objects) {
    		System.out.println(os.getKey());
    	}
	}
}

/*	
try {

	Map<String, Object> params = ReqUtil.getParameterMap(request);



	String id = Util.nullToStr(params.get("id"));



	FileVO fileVo = fileService.getFile(id);



	byte fileByte[] = FileUtils.readFileToByteArray(new File(SystemConstants.FILE_PATH + fileVo.getStoredFileName()));



	response.setContentType("application/octet-stream");

	response.setContentLength(fileByte.length);

	response.setHeader("Content-Disposition",

			"attachment; fileName=\"" + URLEncoder.encode(fileVo.getOriginalFileName(), "UTF-8") + "\";");

	response.setHeader("Content-Transfer-Encoding", "binary");

	response.getOutputStream().write(fileByte);



	response.getOutputStream().flush();

	response.getOutputStream().close();



} catch (Exception e) {

	// TODO: handle exception

	e.printStackTrace();

}*/

/*	package org.my.s3;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.SdkClientException;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ResponseHeaderOverrides;
import com.amazonaws.services.s3.model.S3Object;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class downloadObject3 {

public static void main(String[] args) throws IOException {
	
    String bucketName = "picksell-bucket/upload";
    String key = "dokky.png";

    S3Object fullObject = null, 
    		objectPortion = null, 
    		headerOverrideObject = null;
    
    try {
    	
    	final AmazonS3 s3Client = AmazonS3ClientBuilder.
									   standard().
				withRegion(Regions.AP_NORTHEAST_2).
										  build();
	
        // Get an object and print its contents.
        System.out.println("Downloading an object");
        
        fullObject = s3Client.getObject(new GetObjectRequest(bucketName, key));
        System.out.println("Content-Type: " + fullObject.getObjectMetadata().getContentType());
        System.out.println("Content: ");
        
        displayTextInputStream(fullObject.getObjectContent());

        // Get a range of bytes from an object and print the bytes.
        GetObjectRequest rangeObjectRequest = new GetObjectRequest(bucketName, key)
                .withRange(0, 9);
        objectPortion = s3Client.getObject(rangeObjectRequest);
        System.out.println("Printing bytes retrieved.");
        displayTextInputStream(objectPortion.getObjectContent());

        // Get an entire object, overriding the specified response headers, and print the object's content.
        ResponseHeaderOverrides headerOverrides = new ResponseHeaderOverrides()
                .withCacheControl("No-cache")
                .withContentDisposition("attachment; filename=example.txt");
        
        GetObjectRequest getObjectRequestHeaderOverride = new GetObjectRequest(bucketName, key)
                .withResponseHeaders(headerOverrides);
        
        headerOverrideObject = s3Client.getObject(getObjectRequestHeaderOverride);
        displayTextInputStream(headerOverrideObject.getObjectContent());
        
    } catch (AmazonServiceException e) {
        // The call was transmitted successfully, but Amazon S3 couldn't process 
        // it, so it returned an error response.
        e.printStackTrace();
    } catch (SdkClientException e) {
        // Amazon S3 couldn't be contacted for a response, or the client
        // couldn't parse the response from Amazon S3.
        e.printStackTrace();
    } finally {
        // To ensure that the network connection doesn't remain open, close any open input streams.
        if (fullObject != null) {
            fullObject.close();
        }
        if (objectPortion != null) {
            objectPortion.close();
        }
        if (headerOverrideObject != null) {
            headerOverrideObject.close();
        }
    }
}

private static void displayTextInputStream(InputStream input) throws IOException {
    // Read the text input stream one line at a time and display each line.
    BufferedReader reader = new BufferedReader(new InputStreamReader(input));
    String line = null;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
    System.out.println();
}
}*/
