package org.my.s3;

import java.util.List;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.S3ObjectSummary;


public class readFile {

    public static void main(String[] args) {
    	
    	String bucket_name = "picksell-bucket";
    	
    	final AmazonS3 s3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
    	
    	ObjectListing ObjectList = s3.listObjects(bucket_name);
    	
    	List<S3ObjectSummary> objects =  ObjectList.getObjectSummaries();
    	
    	for(S3ObjectSummary os : objects) {
    		System.out.println(os.getKey());
    	}
    }
 }