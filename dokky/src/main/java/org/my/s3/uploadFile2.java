package org.my.s3;

import java.io.File;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;


public class uploadFile2 {

    public static void main(String[] args) {
    	
		AmazonS3 amazonS3 = AmazonS3ClientBuilder.
									   standard().
			   withRegion(Regions.AP_NORTHEAST_2).
										  build();
    	
    	String bucket_name = "picksell-bucket";
    	String key_name = "test1";
    	String file_path = "C:\\upload\\test.txt";
    	
        if (amazonS3 != null) {
            try {
                PutObjectRequest putObjectRequest =
                        new PutObjectRequest(bucket_name + "/border", key_name ,new File(file_path) );
                //putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead); // file permission // 관리자만 할수있는듯
                amazonS3.putObject(putObjectRequest); // upload file
                System.err.println("업로드 완료");
                
            } catch (AmazonServiceException ase) {
                ase.printStackTrace();
                System.exit(1);
                
            } finally {
            	amazonS3 = null;
            }
        }
    }
}



