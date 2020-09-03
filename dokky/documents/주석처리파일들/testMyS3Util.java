/*
package org.my.s3;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;

public class S3Util {

	private String accessKey = "엑세스키"; // 엑세스 키
	private String secretKey = "보안 엑세스키"; // 보안 엑세스 키

	private AmazonS3 conn;

	public S3Util() {
		AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
		ClientConfiguration clientConfig = new ClientConfiguration();
		clientConfig.setProtocol(Protocol.HTTP);
		this.conn = new AmazonS3Client(credentials, clientConfig);
		conn.setEndpoint("s3.ap-northeast-2.amazonaws.com"); // 엔드포인트 설정 [ 아시아 태평양 서울 ]
	}

	// 버킷 리스트를 가져오는 메서드이다.
	public List<Bucket> getBucketList() {
		return conn.listBuckets();
	}

	// 버킷을 생성하는 메서드이다.
	public Bucket createBucket(String bucketName) {
		return conn.createBucket(bucketName);
	}

	// 폴더 생성 (폴더는 파일명 뒤에 "/"를 붙여야한다.)
	public void createFolder(String bucketName, String folderName) {
		conn.putObject(bucketName, folderName + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());
	}

	// 파일 업로드
	public void fileUpload(String bucketName, String fileName, byte[] fileData) throws FileNotFoundException {

		String filePath = (fileName).replace(File.separatorChar, '/'); // 파일 구별자를 `/`로 설정(\->/) 이게 기존에 / 였어도 넘어오면서 \로 바뀌는 거같다.
		ObjectMetadata metaData = new ObjectMetadata();

		metaData.setContentLength(fileData.length);   //메타데이터 설정 -->원래는 128kB까지 업로드 가능했으나 파일크기만큼 버퍼를 설정시켰다.
	    ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(fileData); //파일 넣음

		conn.putObject(bucketName, filePath, byteArrayInputStream, metaData);
		
	}

	// 파일 삭제
	public void fileDelete(String bucketName, String fileName) {
		String imgName = (fileName).replace(File.separatorChar, '/');
		conn.deleteObject(bucketName, imgName);
		System.out.println("삭제성공");
	}

	// 파일 URL
	public String getFileURL(String bucketName, String fileName) {
		System.out.println("넘어오는 파일명 : "+fileName);
		String imgName = (fileName).replace(File.separatorChar, '/');
		return conn.generatePresignedUrl(new GeneratePresignedUrlRequest(bucketName, imgName)).toString();
	}

}

package org.my.s3;

import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UploadFileUtils {

private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);


public static String uploadFile(String uploadPath, String originalName, byte[] byteData) throws Exception {
	S3Util s3 = new S3Util();
	String bucketName = "almombucket";
	//랜덤의 uid 를 만들어준다.
	UUID uid = UUID.randomUUID();

	//savedName : 570d570a-7af1-4afe-8ed5-391d660084b7_g.JPG 같은 형식으로 만들어준다.
	String savedName = "/"+uid.toString() + "_" + originalName;

	logger.info("업로드 경로 : "+uploadPath);
	//\2017\12\27 같은 형태로 저장해준다.
	String savedPath = calcPath(uploadPath);

	String uploadedFileName = null;

	uploadedFileName = (savedPath + savedName).replace(File.separatorChar, '/');
	//S3Util 의 fileUpload 메서드로 파일을 업로드한다.
	s3.fileUpload(bucketName, uploadPath+uploadedFileName, byteData);


	logger.info(uploadedFileName);
//s3.fileUpload(bucketName, new File(fileName))

	return uploadedFileName;

}

private static String calcPath(String uploadPath) {

	Calendar cal = Calendar.getInstance();

	String yearPath = File.separator + cal.get(Calendar.YEAR);

	String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);

	String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));

	makeDir(uploadPath, yearPath, monthPath, datePath);

	logger.info(datePath);

	return datePath;
}

private static void makeDir(String uploadPath, String... paths) {

	if (new File(paths[paths.length - 1]).exists()) {
		return;
	}

	for (String path : paths) {

		File dirPath = new File(uploadPath + path);

		if (!dirPath.exists()) {
			dirPath.mkdir();
		}
	}
}
}*/



/*public AttachFileDTO fileUpload2(String fileName, byte[] fileData, String uploadKind) throws FileNotFoundException {
		
		createFolder();
		
		AttachFileDTO attachDTO = new AttachFileDTO();
		
		fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);//ie의경우 짤라줌
		
		attachDTO.setFileName(fileName);//오리지날 이름 저장
		
		UUID uuid = UUID.randomUUID();
		
		fileName = uuid.toString() + "_" + fileName;
		
		attachDTO.setUuid(uuid.toString());//uuid저장
		
		attachDTO.setUploadPath(folder_name);//폴더 경로저장
		
		if(uploadKind.equals("photo")) {
			
			attachDTO.setImage(true);//타입이 포토라고 저장 //1은 true 0은 false
		}
		
		ObjectMetadata metaData = new ObjectMetadata();
		
		//metaData.setContentLength(fileData.length);   //메타데이터 설정 -->원래는 128kB까지 업로드 가능했으나 파일크기만큼 버퍼를 설정시켰다.
	   
		ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(fileData); //파일 넣음
		
	    //s3.putObject(bucket_name + "/" + folder_name, fileName, byteArrayInputStream, metaData);//퍼블릭 없이 디폴트로 설정해서 업로드
	    
	    PutObjectRequest putObjectRequest = new PutObjectRequest(bucket_name + "/" + folder_name, fileName, byteArrayInputStream, metaData);
	    
	    //putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead); // 파일의 권한 퍼블릭으로 설정
	    
	    s3.putObject(putObjectRequest); //업로드
	    
	    //String encodedName = StringUtil.encodeAsUTF8(fileName);
	    
	    byte ptext[] = null;
	    String encodedName = null;
	    
		try {
			ptext = fileName.getBytes("ISO_8859_1");
			encodedName = new String(ptext, "UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		
		try {
			fileName = URLEncoder.encode(fileName, "UTF8").replaceAll("\\+", " ");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		try {
			fileName = new String(fileName.getBytes("UTF-8"),"iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	    
	    ResponseHeaderOverrides header = new ResponseHeaderOverrides();
		
	    header.setContentDisposition("response-content-disposition=attachment; filename=\"" + fileName + "\"");
	    header.setContentEncoding("utf-8");
	    
	    GeneratePresignedUrlRequest request = new GeneratePresignedUrlRequest(bucket_name + "/" + folder_name, fileName);
	    request.setMethod(HttpMethod.GET);
	    request.setResponseHeaders(header);
	    
	    Date today = new Date();
	    
	    request.setExpiration(new Date(today.getTime() + (long)(3000)));//3초후 다운로드 못하게 막음
	    
	    String url = s3.generatePresignedUrl(request).toString();
	   // String url = s3.getUrl(bucket_name + "/" + folder_name, fileName).toString();
	    
	    //attachDTO.setDownUrl(url);
	    
	    //attachDTO.setDownUrl(s3.generatePresignedUrl(new GeneratePresignedUrlRequest(bucket_name + "/" + folder_name, fileName)).toString());
	    
	    return attachDTO;
	}*/

	
	/*public AttachFileDTO fileUpload2(String fileName, MultipartFile multipartFile, String uploadKind) throws FileNotFoundException {
	
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
	}*/

	/*public String getPresignedUrl(String folder_path, String fileName) {
	
	return s3.generatePresignedUrl(new GeneratePresignedUrlRequest(bucket_name + "/" + folder_path, fileName)).toString();
	}*/

	/*public void downloadObject(String folder_name, String objectName) {
		
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
	}*/
	
	/*public void uploadFile1(String folder_name, String key_name, String file_path) {
		
		try {
			s3.putObject(bucket_name + "/"+  folder_name, key_name, new File(file_path));
			log.info("업로드 완료");
			
		}catch(AmazonServiceException e) {
			
			log.info(e.getErrorMessage());
	    	System.exit(1);
		}
	}*/

	/*public void uploadFile2(String folder_name, String key_name, String file_path) {
			
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
	            log.info("업로드 완료");
	            
	        } catch (AmazonServiceException ase) {
	            ase.printStackTrace();
	            System.exit(1);
	            
	        } finally {
	        	s3 = null;
	        }
	    }
	}*/
	
	/*public void createBucket(String bucket_name) {
		
		try {
    		s3.createBucket(bucket_name);
    		
    		log.info("버킷 생성완료");
    		
    	}catch(AmazonS3Exception e) {
    		
    		log.info(e.getErrorMessage());
    	}
	}*/

/*	
try {

	Map<String, Object> params = ReqUtil.getParameterMap(request);



	String id = Util.nullToStr(params.get("id"));



	FileVO fileVo = fileService.getFile(id);



	byte fileByte[] = FileUtils.readFileToByteArray(new File(.temConstants.FILE_PATH + fileVo.getStoredFileName()));



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