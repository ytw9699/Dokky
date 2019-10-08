package org.my.s3;

	import java.io.BufferedOutputStream;
	import java.io.FileOutputStream;
	import java.io.IOException;
	import java.io.OutputStream;
	
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
	import com.amazonaws.services.s3.model.S3Object;
	import com.amazonaws.services.s3.model.S3ObjectInputStream;


public class downloadObject1 {

    public static void main(String[] args) {
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
    	
    	String bucket_name = "picksell-bucket";
    	String folder_name = "/upload";
    	String objectName = "dokky.png";
    	String downloadPath = "C:\\Users\\champ\\Downloads\\";
    	
    	try {
    		
    		
    		S3Object s3Object = s3.getObject(bucket_name + folder_name, objectName);
			
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
		    
    		
    	} catch (IOException e) {
    	    e.printStackTrace();
    	}
    }
}




