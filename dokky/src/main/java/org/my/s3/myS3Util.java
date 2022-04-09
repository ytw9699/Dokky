package org.my.s3;
	import java.awt.Graphics2D;
	import java.awt.image.BufferedImage;
	import java.io.BufferedInputStream;
	import java.io.ByteArrayInputStream;
	import java.io.File;
	import java.io.FileNotFoundException;
	import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
	import java.net.URLEncoder;
	import java.text.SimpleDateFormat;
	import java.util.Calendar;
	import java.util.Date;
	import java.util.List;
	import java.util.UUID;
	import javax.imageio.ImageIO;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.my.domain.AttachFileDTO;
	import org.my.service.CommonService;
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
	import com.amazonaws.services.s3.model.ObjectListing;
	import com.amazonaws.services.s3.model.ObjectMetadata;
	import com.amazonaws.services.s3.model.S3Object;
	import com.amazonaws.services.s3.model.S3ObjectInputStream;
	import com.amazonaws.services.s3.model.S3ObjectSummary;
	import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class myS3Util { 
	
	private static final String bucket_name = "dokky2-bucket";//자신의 S3 버킷 이름을 입력하세요
	private static final String ACCESS_KEY = "";//자신의 S3 ACCESS_KEY를 입력하세요
	private static final String SECRET_KEY = "";//자신의 S3 SECRET_KEY를 입력하세요
	
	String folder_name;
	AmazonS3 s3;
	
    //private AmazonS3 amazonS3;
	 
	public myS3Util() {
		
				 s3 = AmazonS3ClientBuilder.
						 		 standard().
		 withRegion(Regions.AP_NORTHEAST_2).
									build();
	}
	    
    public myS3Util(CommonService commonService) {
    	
    	AWSCredentials awsCredentials;
    	
    	String accessKey = commonService.getAccessKey();
		
		String secretKey = commonService.getSecretKey();
    	
    	if(accessKey == null || secretKey == null) {
    		
    		 awsCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);//직접 입력한 키로 인증 객체를 생성한다.
    		 
    	}else {
    		
    		 awsCredentials = new BasicAWSCredentials(accessKey, secretKey);//디비에서 가져온 키로 인증 객체를 생성한다.
    	}
		 
		s3  = AmazonS3ClientBuilder.standard().
	                withRegion(Regions.AP_NORTHEAST_2).
	                withCredentials(new AWSStaticCredentialsProvider(awsCredentials)).
				    build();
    }
	
	public AttachFileDTO upload(InputStream inputStream, MultipartFile multipartFile,
						String fileName, String uploadKind) throws FileNotFoundException {//사진 및 파일 업로드
			
			createFolder();
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);//ie의경우 짤라줌
			
			attachDTO.setFileName(fileName);//오리지날 이름 저장
			
			UUID uuid = UUID.randomUUID();
			
			fileName = uuid.toString() + "_" + fileName;
			
			attachDTO.setUuid(uuid.toString());//uuid저장
			
			attachDTO.setUploadPath(folder_name);//업로드 폴더 경로저장
			
			ObjectMetadata metaData = new ObjectMetadata();
			
			//metaData.setContentLength(fileData.length);//원래는 128kB, 파일크기만큼 버퍼를 설정시켰다.
		   
		    s3.putObject(bucket_name + "/" + folder_name, fileName, inputStream, metaData);//s3 권한 퍼블릭 없이 디폴트로 설정해서 업로드
		    
	    	if(uploadKind.equals("photo")) {//이미지라면 썸네일 만들자 
				
				attachDTO.setImage(true);//타입이 이미지면 1 //1은 true 0은 false
				
				File thumbnailFile = null;
				
				try {
					
					thumbnailFile = new File(System.getProperty("java.io.tmpdir")+"/s_"+fileName); //임시파일 생성
				
					BufferedImage originalImg = ImageIO.read(multipartFile.getInputStream()); 
					
					int width = originalImg.getWidth();
					 
					int height = originalImg.getHeight();
					
					BufferedImage thumbnailImg = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR); 
					
					Graphics2D g = thumbnailImg.createGraphics(); 
					
					g.drawImage(originalImg, 0, 0, width, height, null);
					
					ImageIO.write(thumbnailImg, "jpg", thumbnailFile);
				} 
				
				catch (Exception e) { 
					e.printStackTrace();  
				} 
				
				s3.putObject(bucket_name + "/" + folder_name, "s_"+fileName, thumbnailFile);
				
				thumbnailFile.delete();//임시파일 삭제
			}

		    return attachDTO;
	}
	
	public byte[] downloadImage(String path, String filename) {
		
		byte[] bytesArray = null;
		
		try {
    		
    		S3Object s3Object = s3.getObject(bucket_name + "/" + path, filename);
    		
    		ObjectMetadata metaData = s3Object.getObjectMetadata();
		    
		    bytesArray = new byte[(int)metaData.getContentLength()];//겍체 크기를 구해서 바이트배열의 크기를 지정하고
		    
		    S3ObjectInputStream s3ObjectInputStream = s3Object.getObjectContent();
		    
		    BufferedInputStream bin = new BufferedInputStream(s3ObjectInputStream);
		    
		    while ((bin.read(bytesArray)) != -1) {
		    }

		    s3ObjectInputStream.close();
    	
    	} catch (IOException e) {
    	    System.err.println(e.getMessage());
    	    System.exit(1);
    	}
		
		return bytesArray;
	}
	
	
	public void fileDownload(HttpServletRequest request, HttpServletResponse response, String ContentType) {
		
		String path = request.getParameter("path");
		String filename = request.getParameter("filename");
		String uuid = request.getParameter("uuid");
		
		try {
		
			S3Object s3Object = s3.getObject(bucket_name + "/" + path, uuid+"_"+filename);
			
			response.setContentType(ContentType);//리스폰스에 설정//다운로드타입이어야하니까
			
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
	
	public List<S3ObjectSummary> getObjectsList() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		
		Calendar cal = Calendar.getInstance();

		cal.add(Calendar.DATE, -1);//-1은 어제날짜
		
		String str = sdf.format(cal.getTime());
		
		String folder_name = "upload/" + str;
	
		ObjectListing ObjectList = s3.listObjects(bucket_name , folder_name);
		
    	List<S3ObjectSummary> objects =  ObjectList.getObjectSummaries();
    	
    	return objects;
	}
	
	public boolean deleteObject(String path, String filename) {
		
		try {
			
			log.info("deleted"+path+filename); 
			
    		s3.deleteObject(bucket_name + "/" +path, filename);
    		
    		return true;
    		
    	}catch(AmazonServiceException e) {
    		
    		log.info(e.getErrorMessage());
    		System.exit(1);
    		return false;
    	}
	}
	
	public void createFolder() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

		Date date = new Date();

		String str = sdf.format(date);
		
		folder_name = "upload/" + str;
		
		try {
				if (s3.doesBucketExist(bucket_name + "/" + folder_name)) {
			        
					log.info("폴더가 이미 있음");  
					
			    }else {
			    	
		    		s3.putObject(bucket_name, folder_name + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());
		    		
		    		log.info("폴더 생성 완료");  
		    	}
			    
		}catch(AmazonS3Exception e) {
    		
			
			log.info(e.getErrorMessage());  
    	}
	}
}
