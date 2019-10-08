package org.my.s3;
	import com.amazonaws.AmazonServiceException;
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.S3Object;
	import com.amazonaws.services.s3.model.S3ObjectInputStream;
	import java.io.File;
	import java.io.FileNotFoundException;
	import java.io.FileOutputStream;
	import java.io.IOException;

public class downloadObject2 {

    public static void main(String[] args) {
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
    	
    	String bucket_name = "picksell-bucket/upload";
    	String objectName = "dokky.png";
    	String downloadPath = "C:\\Users\\champ\\dokky.png"; 
    	
    	System.out.format("Downloading %s from S3 bucket %s...\n", objectName, bucket_name);
    	
    	s3.generatePresignedUrl(new GeneratePresignedUrlRequest(bucket_name, objectName)).toString();
    	
    	/*s3.download();
    	
    	PresignedUrlDownloadResult	download(PresignedUrlDownloadRequest presignedUrlDownloadRequest)
    	Gets the object stored in Amazon S3 using a presigned url.*/
    	
    	try {
    		
    	    S3Object Object = s3.getObject(bucket_name, objectName);
    	    
    	    S3ObjectInputStream s3is = Object.getObjectContent();
    	    
    	    FileOutputStream fos = new FileOutputStream(new File(downloadPath));
    	    
    	    byte[] read_buf = new byte[1024];
    	    
    	    int read_len = 0;
    	    
    	    while ((read_len = s3is.read(read_buf)) > 0) {
    	        fos.write(read_buf, 0, read_len);
    	    }
    	    
    	    s3is.close();
    	    fos.close();
    	    
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

}
*/