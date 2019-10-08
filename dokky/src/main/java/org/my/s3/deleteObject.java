package org.my.s3;
	import com.amazonaws.AmazonServiceException;
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;

public class deleteObject {

    public static void main(String[] args) {
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
    	
    	String bucket_name = "picksell-bucket";
    	String key_name = "test1";
    	
    	try {
    		s3.deleteObject(bucket_name, key_name);
    		System.err.println("삭제 완료");
    		
    	}catch(AmazonServiceException e) {
    		
	    	System.err.println(e.getErrorMessage());
	    	System.exit(1);
    		
    	}
    }
 }