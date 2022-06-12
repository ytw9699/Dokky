/*
- 마지막 업데이트 2022-06-12
*/
package org.my.controller;
	import java.io.IOException;
	import java.util.ArrayList;
	import java.util.List;
	import javax.servlet.http.HttpServletRequest;
	import org.my.domain.AttachFileDTO;
	import org.my.s3.myS3Util;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.multipart.MultipartFile;
	import org.springframework.web.servlet.ModelAndView;
	import lombok.RequiredArgsConstructor;
	import lombok.extern.log4j.Log4j;
	
@RequiredArgsConstructor
@Controller
@Log4j
public class UpDownController {
	
	private final myS3Util myS3Util;
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/s3upload", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> s3Upload(MultipartFile[] uploadFile, 
					String uploadKind, HttpServletRequest request) throws IOException {//파일,사진 s3업로드
		
		log.info("/s3upload");
		
		AttachFileDTO result;
		
		List<AttachFileDTO> list = new ArrayList<>();
		
		try {
			
			for (MultipartFile multipartFile : uploadFile) {
				
				result = myS3Util.upload(multipartFile.getInputStream(), multipartFile, multipartFile.getOriginalFilename(), uploadKind);
				
				list.add(result);
			}
			
		}catch (Exception e) { 
			
			e.printStackTrace();
		} 
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	} 
	
	@GetMapping("/s3Image")
	@ResponseBody
	public ResponseEntity<byte[]> downloadS3Image(String path, String filename, HttpServletRequest request) {
		
		log.info("/s3Image");
		
		ResponseEntity<byte[]> result = new ResponseEntity<>(myS3Util.downloadImage(path, filename), HttpStatus.OK);
		
		return result;
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/downloadS3File")		
	public ModelAndView downloadS3File(HttpServletRequest request) throws Exception {
		
		return new ModelAndView("DownloadView", "temp", "temp");//servlet-context.xml
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/deleteS3Data", produces = { MediaType.TEXT_PLAIN_VALUE })
	@ResponseBody //s3 사진 및 파일 지우기
	public ResponseEntity<String> deleteS3Data(String path, String filename, String type, HttpServletRequest request) {
		
		log.info("/s3File: " + path+filename);
		
		if(myS3Util.deleteObject(path, filename)) {
			
			if (type.equals("image")) {//만약 이미지파일이었다면

				myS3Util.deleteObject(path, "s_"+filename);//썸네일도 삭제
			}
			
			return new ResponseEntity<String>("success", HttpStatus.OK);
		
		}else{
			
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}
}