package org.my.s3;

import java.io.File;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;


public class uploadFile1 {

    public static void main(String[] args) {
    	
    	String ACCESS_KEY = "";
        String SECRET_KEY = "";
         
       AWSCredentials awsCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);// 인증 객체를 생성한다.
       
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
			   withCredentials(new AWSStaticCredentialsProvider(awsCredentials)).
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




