package org.my.s3;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.model.AmazonS3Exception;
	import com.amazonaws.services.s3.model.ObjectMetadata;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
	import java.io.ByteArrayInputStream;
	import java.text.SimpleDateFormat;
	import java.util.Date;
	import com.amazonaws.regions.Regions;

public class createFolder {

    public static void main(String[] args) {
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
			    			standard().
			    			withRegion(Regions.AP_NORTHEAST_2).
			    			build(); 
			    	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

		Date date = new Date();

		String str = sdf.format(date);

		System.out.println(str);
    		
	    // create bucket if the bucket name does not exist
	    if (s3.doesBucketExist("picksell-bucket/upload/"+str)) {
	        
	    	System.out.format("폴더가 이미 있음");
	    	
	    }else {
	 
	    	try {
	    		s3.putObject("picksell-bucket/upload", str + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());
	    		
	    		System.out.format("폴더 생성 완료");
	    		
	    	}catch(AmazonS3Exception e) {
	    		
	    		System.out.println(e.getErrorMessage());
	    	}
    	}
    }
 }