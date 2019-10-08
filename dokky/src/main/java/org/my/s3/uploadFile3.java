package org.my.s3;
	import java.io.File;
	import com.amazonaws.auth.AWSCredentials;
	import com.amazonaws.auth.AWSStaticCredentialsProvider;
	import com.amazonaws.auth.BasicAWSCredentials;
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3ClientBuilder;
	import com.amazonaws.services.s3.model.CannedAccessControlList;
	import com.amazonaws.services.s3.model.PutObjectRequest;
	import lombok.extern.log4j.Log4j;

public class uploadFile3 {

    public static void main(String[] args) {
    	
    	String BUCKET_NAME = "picksell-bucket/upload";
        String ACCESS_KEY = "";
        String SECRET_KEY = "";
        
        AmazonS3 amazonS3; // 인스턴스를 초기화한다.
        String file_path = "C:\\upload\\test.txt";
        String key_name = "test";
        
        AWSCredentials awsCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);// 인증 객체를 생성한다.

        // 인스턴스에 버킷의 정보를들 설정한다.
        amazonS3 = AmazonS3ClientBuilder
	                .standard()
	                .withRegion(Regions.AP_NORTHEAST_2)
	                .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
	                .build();
        
        // 파일 업로드를 위한 request 객체를 생성 하였다.
        PutObjectRequest putObjectRequest =
                new PutObjectRequest(BUCKET_NAME, key_name, new File(file_path));
        //request 객체 안에 BUCKET_NAME + "생성 될 폴더 이름", 파일 원본이름, File 바이너리 데이터 를 설정하였다.ㅏ

        putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead);
        // Access List 를 설정 하는 부분이다. 공개 조회가 가능 하도록 public Read 로 설정 하였다.
        
        amazonS3.putObject(putObjectRequest);
        // 실제로 업로드 할 액션이다.
        System.err.println("업로드 완료");
    }
}
