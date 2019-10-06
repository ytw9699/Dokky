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
    	
    	String BUCKET_NAME = "picksell-bucket";
        String ACCESS_KEY = "AKIA47S6HNIPMDWY3OGR";
        String SECRET_KEY = "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";
        
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
                new PutObjectRequest(BUCKET_NAME + "/test", key_name, new File(file_path));
        //request 객체 안에 BUCKET_NAME + "생성 될 폴더 이름", 파일 원본이름, File 바이너리 데이터 를 설정하였다.ㅏ
        
        // Access List 를 설정 하는 부분이다. 공개 조회가 가능 하도록 public Read 로 설정 하였다.
        //putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead);
        // 실제로 업로드 할 액션이다.
        amazonS3.putObject(putObjectRequest);
    }
}

/*
package org.my.service;
import java.io.File;
import org.springframework.stereotype.Service;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class AwsServiceImpl implements AwsService {

private static final String BUCKET_NAME = "picksell-bucket";
private static final String ACCESS_KEY = "AKIA47S6HNIPMDWY3OGR";
private static final String SECRET_KEY = "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";


private AmazonS3 amazonS3; // 인스턴스를 초기화한다.

public AwsServiceImpl() { // Constructor

    // 인증 객체를 생성한다.
    AWSCredentials awsCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);

    // 인스턴스에 버킷의 정보를들 설정한다.
    // Region 의 경우 버킷의 url 에서 확인 할 수 있다.
    // ex) https://s3.console.aws.amazon.com/s3/buckets/static.preeplus.com/?region=ap-northeast-2&tab=overview
    amazonS3 = AmazonS3ClientBuilder
            .standard()
            .withRegion(Regions.AP_NORTHEAST_2)
            .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
            .build();
}

@Override
public void s3FileUpload(File file) {
	

    // 파일 업로드를 위한 request 객체를 생성 하였다.
    PutObjectRequest putObjectRequest =

            // request 객체 안에 BUCKET_NAME + "생성 될 폴더 이름", 파일 원본이름, File 바이너리 데이터 를 설정하였다.ㅏ
            new PutObjectRequest(BUCKET_NAME + "/test", file.getName(), file);
    
    // Access List 를 설정 하는 부분이다. 공개 조회가 가능 하도록 public Read 로 설정 하였다.
    putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead);
    // 실제로 업로드 할 액션이다.
    amazonS3.putObject(putObjectRequest);
}
}*/

/*
package org.my.service;

import java.io.File;

public interface AwsService {
	
	 public void s3FileUpload(File file);
	
}

*/

/*
package org.my.service;

import java.io.File;
import org.my.service.AwsServiceImpl;
import lombok.extern.log4j.Log4j;

@Log4j
public class test {

	public static void main(String[] args) {
		
    File file = new File("c:\\upload\\test.txt");
    
    AwsServiceImpl AwsService = new AwsServiceImpl();
    
    AwsService.s3FileUpload(file);
}
}


*/