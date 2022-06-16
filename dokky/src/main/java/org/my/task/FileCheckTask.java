/*
- 마지막 업데이트 2022-06-16
*/
package org.my.task;
	import java.util.ArrayList;
	import java.util.List;
	import org.my.domain.board.BoardAttachVO;
	import org.my.mapper.BoardAttachMapper;
	import org.my.s3.myS3Util;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.scheduling.annotation.Scheduled;
	import org.springframework.stereotype.Component;
	import com.amazonaws.services.s3.model.S3ObjectSummary;
	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {//task 작업 처리 ,스케쥴러 
	
	@Setter(onMethod_ = { @Autowired })
	private BoardAttachMapper attachMapper;
	
	@Setter(onMethod_ = @Autowired)
	private myS3Util myS3Util;
	
	@Scheduled(cron = "0 0 9 * * *")//매일 9시 동작
	public void checkFiles() throws Exception {
		
		log.info("checkFiles"); 
		
		boolean type;//파일의 타입
		
		ArrayList<String> dbUploadList = new ArrayList<String>();//어제 날짜 최종 디비의 업로드 목록
		
		List<BoardAttachVO> fileList = attachMapper.getYesterdayFiles();//어제 날짜 db 모든 업로드 목록 일단 가져오기
		
        for(int j = 0; j < fileList.size(); j++){
            	
        	BoardAttachVO boardAttachVO = fileList.get(j);
        	
        	String uploadKey = boardAttachVO.getUploadPath()+"/"+boardAttachVO.getUuid()+"_"+boardAttachVO.getFileName();
        	
        	dbUploadList.add(uploadKey);
            	
        	type = boardAttachVO.isFileType();
        	
        	if(type) {//이미지라면
    			dbUploadList.add(boardAttachVO.getUploadPath()+"/s_"+boardAttachVO.getUuid()+"_"+boardAttachVO.getFileName());//썸네일 목록 추가
        	}
            	
        }
            	
    	List<S3ObjectSummary> objects = myS3Util.getObjectsList();//s3의 업로드 목록
            	
    	for (int i = 1; i < objects.size(); i++) {
    		
    		String S3key = objects.get(i).getKey();
    		
    		if(!dbUploadList.contains(S3key)){// s3의 업로드 목록 파일이 디비의 업로드 목록에 없다면
    			
    			log.info("S3key "+S3key); 
    			
    			String filename = S3key.substring(S3key.lastIndexOf("/")+1);
            	String path = S3key.substring(0, S3key.lastIndexOf("/"));
            
            	myS3Util.deleteObject(path, filename);//삭제를 해준다//즉 디비와 S3의 업로드파일을 동기화시키는것
    		}
        }
    	
    }
}
