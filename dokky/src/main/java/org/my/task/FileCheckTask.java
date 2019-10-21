package org.my.task;
	import java.io.File;
	import java.nio.file.Path;
	import java.nio.file.Paths;
	import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
	import java.util.Date;
	import java.util.List;
	import java.util.stream.Collectors;
	import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
	import org.springframework.stereotype.Component;

import com.amazonaws.services.s3.model.S3ObjectSummary;

import org.my.domain.BoardAttachVO;
	import org.my.mapper.BoardAttachMapper;
	import org.my.s3.myS3Util;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {//task 작업 처리 ,스케쥴러

	@Setter(onMethod_ = { @Autowired })
	private BoardAttachMapper attachMapper;
	
	@Setter(onMethod_ = @Autowired)
	private myS3Util s3Util;

	@Scheduled(cron = "0 0 9 * * *")//매일 9시 동작
	public void checkFiles() throws Exception {
		
		boolean type;
		
		ArrayList<String> numbers = new ArrayList<String>();//디비의 업로드 목록
		
		List<BoardAttachVO> fileList = attachMapper.getYesterdayFiles();//어제 날짜 database 모든 첨부파일 목록 가져오기
		
        for(int j = 0; j < fileList.size(); j++){
            	
        	BoardAttachVO boardAttachVO = fileList.get(j);
        	
        	String dbkey = boardAttachVO.getUploadPath()+"/"+boardAttachVO.getUuid()+"_"+boardAttachVO.getFileName();
        	//log.info("S3key"+S3key); 
        	//log.info("S3key2"+boardAttachVO.getUploadPath()+"/"+boardAttachVO.getUuid()+"_"+boardAttachVO.getFileName());
        	
        	numbers.add(dbkey);
            	
        	type = boardAttachVO.isFileType();
        	
        	if(type) {//이미지라면
    			numbers.add("s_"+dbkey);//썸네일 추가
        	}
            	
        }
            	
        for (int i = 0; i < numbers.size(); i++) {
            log.info("numbers "+numbers.get(i)); 
        }
        
    	List<S3ObjectSummary> objects = s3Util.getObjectsList();//s3의 업로드 목록
            	
    	for (int i = 1; i < objects.size(); i++) {
    		
    		String S3key = objects.get(i).getKey();
    		
    		if(!numbers.contains(S3key)){// s3의 목록 파일이 디비의 목록파일에 없다면
    			
    			log.info("S3key "+S3key); 
    			
    			String filename = S3key.substring(S3key.lastIndexOf("/")+1);
            	String path = S3key.substring(0, S3key.lastIndexOf("/"));
            	
            	s3Util.deleteObject(path, filename);
    		}
        }
    	
    }
}
    

/*private String getFolderYesterDay() {

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	Calendar cal = Calendar.getInstance();

	cal.add(Calendar.DATE, -1);

	String str = sdf.format(cal.getTime());

	return str.replace("-", File.separator);
}*/

		/*log.warn("File Check Task run.................");
		log.warn(new Date());
		
		List<BoardAttachVO> fileList = attachMapper.getYesterdayFiles();//어제 날짜 database 모든 첨부파일 목록 가져오기

		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList()); //실제 폴더에 잇는 파일들의 목록과 비교를 위해서 java.nio.Paths의 목록으로 변환

		fileList.stream().filter(vo -> vo.isFileType() == true)
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
				.forEach(p -> fileListPaths.add(p));//이미지 파일의 경우에는 섬네일 파일도 목록에 필요하기 때문에 목록에 추가

		log.warn("===========================================");

		fileListPaths.forEach(p -> log.warn(p));

		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();//어제 날짜 폴더에 있는 실제 파일

		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		//실제 폴더에 있는 파일들의 목록에서 데이터베이스에는 없는 파일들을 찾아서 목록으로 준비

		log.warn("-----------------------------------------");
		for (File file : removeFiles) {//최종적으로는 삭제 대상이 되는 파일들을 삭제

			log.warn(file.getAbsolutePath());

			file.delete();

		}*/

