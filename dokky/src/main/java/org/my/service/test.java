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
