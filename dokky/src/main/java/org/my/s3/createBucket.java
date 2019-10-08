package org.my.s3;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.AmazonS3Exception;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.regions.Regions;


public class createBucket {

    public static void main(String[] args) {
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
			    			standard().
			    			withRegion(Regions.AP_NORTHEAST_2).
			    			build(); 
    	    
    	String bucket_name = "new-bucket";
    	
    	try {
    		s3.createBucket(bucket_name);
    		
    	System.out.println("버킷 생성완료");
    		
    	}catch(AmazonS3Exception e) {
    		
    		System.out.println(e.getErrorMessage());
    	}
    }
 }