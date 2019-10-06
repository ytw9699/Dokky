package org.my.s3;

import java.io.File;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;


public class uploadFile1 {

    public static void main(String[] args) {
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
    	
    	String bucket_name = "picksell-bucket/upload";
    	String key_name = "test";
    	String file_path = "C:\\upload\\test.txt";
    	
    	try {
    		s3.putObject(bucket_name, key_name, new File(file_path));
    		System.err.println("업로드 완료");
    		
    	}catch(AmazonServiceException e) {
    		
	    	System.err.println(e.getErrorMessage());
	    	System.exit(1);
    		
    	}
    }
}




