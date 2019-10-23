package org.my.controller;
	import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
	import java.io.IOException;
	import java.io.UnsupportedEncodingException;
	import java.net.URLDecoder;
	import java.net.URLEncoder;
	import java.nio.file.Files;
	import java.text.SimpleDateFormat;
	import java.util.ArrayList;
	import java.util.Date;
	import java.util.List;
	import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.my.domain.AttachFileDTO;
import org.my.s3.myS3Util;
import org.my.service.CommonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
	import org.springframework.core.io.Resource;
	import org.springframework.http.HttpHeaders;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.security.access.prepost.PreAuthorize;
	import org.springframework.stereotype.Controller;
	import org.springframework.util.FileCopyUtils;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import lombok.Setter;
	import lombok.extern.log4j.Log4j;
	import net.coobird.thumbnailator.Thumbnailator;


@Controller
@Log4j
public class UploadController {
	
	@Setter(onMethod_ = @Autowired)
	private myS3Util s3Util;
	
	private String getFolder() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();

		String str = sdf.format(date);

		return str.replace("-", File.separator);
	}
	
	/*private String getFolder() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

		Date date = new Date();

		String str = sdf.format(date);

		return str;
	}*/

	private boolean checkImageType(File file) {//이미지 파일확인 여부

		try {
			String contentType = Files.probeContentType(file.toPath());

			return contentType.startsWith("image");

		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {

		log.info("fileName: " + fileName);

		File file = new File("c:\\upload\\" + fileName);

		log.info("file: " + file);

		ResponseEntity<byte[]> result = null;

		try {
			HttpHeaders header = new HttpHeaders();

			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping("/displayS3")
	@ResponseBody
	public ResponseEntity<byte[]> getS3File(String path , String filename) {
 
		log.info("path + filename: " + path + filename);

		ResponseEntity<byte[]> result = null;

		result = new ResponseEntity<>(s3Util.downloadImage(path, filename), HttpStatus.OK);
		
		return result;
	}
	
	
	/*@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/s3uploadFile2", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> posts3UploadFile2(MultipartFile[] uploadFile, String uploadKind) throws IOException {
		
		log.info("/s3uploadFile");  
		
		AttachFileDTO result;
		
		List<AttachFileDTO> list = new ArrayList<>();  
		
		for (MultipartFile multipartFile : uploadFile) {
			
			result = s3Util.fileUpload2(multipartFile.getOriginalFilename(), multipartFile , uploadKind);
			
			list.add(result);
		}
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}*/
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/s3upload", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> posts3UploadFile(MultipartFile[] uploadFile, String uploadKind) throws IOException {
		
		log.info("/s3upload");
		
		AttachFileDTO result;
		
		List<AttachFileDTO> list = new ArrayList<>();  
		try {
			
			for (MultipartFile multipartFile : uploadFile) {
				
				result = s3Util.upload(multipartFile.getBytes(), multipartFile, multipartFile.getOriginalFilename(), uploadKind);
				
				list.add(result);
			}
		
		}catch (Exception e) { 
			e.printStackTrace();  
		} 
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	/*@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/upload", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> postUploadFile(MultipartFile[] uploadFile, String uploadKind) {
		
		List<AttachFileDTO> list = new ArrayList<>();  
		
		String uploadFolder = "C:\\upload";

		String uploadFolderPath = getFolder();
		
		File uploadPath = new File(uploadFolder, uploadFolderPath);

		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}

		for (MultipartFile multipartFile : uploadFile) {

			AttachFileDTO attachDTO = new AttachFileDTO();

			String uploadFileName = multipartFile.getOriginalFilename();

			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);//ie의경우 짤라줌
			
			log.info("only file name: " + uploadFileName);
			
			attachDTO.setFileName(uploadFileName);//오리지날 이름 저장

			UUID uuid = UUID.randomUUID();

			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadPath, uploadFileName);
				
				multipartFile.transferTo(saveFile);//파일,사진 업로드

				attachDTO.setUuid(uuid.toString());//uuid저장
				attachDTO.setUploadPath(uploadFolderPath);//폴더 경로저장
				
				if(uploadKind.equals("photo")) {//업로드 종류가 photo가 아닌것은 모두 파일로 취급해서 사진파일이어도 파일종류로 구분
					if (checkImageType(saveFile)) {//photo를 이미 확인해줬지만 한번더 이미지 파일 이라면 확인
						
						attachDTO.setImage(true);
						
						FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));

						Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);//썸네일 이미지 만들고 업로드

						thumbnail.close();
					}
				}

				list.add(attachDTO);

			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end for
		return new ResponseEntity<>(list, HttpStatus.OK);
	}*/
	
	/*@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadFile", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> postUploadFile(MultipartFile[] uploadFile, String uploadKind) {
		
		final AmazonS3 s3 = AmazonS3ClientBuilder.
    			standard().
    			withRegion(Regions.AP_NORTHEAST_2).
    			build(); 
		
		String bucket_name = "picksell-bucket/upload";
		String uploadFolderPath = getFolder();
		//File uploadPath = new File(uploadFolder, uploadFolderPath);
		//String key_name ;
		//List<AttachFileDTO> list = new ArrayList<>();  
		
		try {
			
			if (s3.doesBucketExist(bucket_name + uploadFolderPath) == false) {
				s3.putObject(bucket_name, uploadFolderPath + "/", new ByteArrayInputStream(new byte[0]), new ObjectMetadata());//폴더생성
			}
			
		}catch(AmazonS3Exception e) {
    		
			log.info(e.getErrorMessage());
    	}

		for (MultipartFile multipartFile : uploadFile) {

			AttachFileDTO attachDTO = new AttachFileDTO();

			String uploadFileName = multipartFile.getOriginalFilename();

			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);//ie의경우 짤라줌
			
			log.info("only file name: " + uploadFileName);
			
			attachDTO.setFileName(uploadFileName);//오리지날 이름 저장

			UUID uuid = UUID.randomUUID();

			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadPath, uploadFileName);
				
				multipartFile.transferTo(saveFile);

				attachDTO.setUuid(uuid.toString());//uuid저장
				attachDTO.setUploadPath(uploadFolderPath);//폴더 경로저장
				
				if(uploadKind.equals("photo")) {//업로드 종류가 photo가 아닌것은 모두 파일로 취급해서 사진파일이어도 파일종류로 구분
					if (checkImageType(saveFile)) {//photo를 이미 확인해줬지만 한번더 이미지 파일 이라면 확인
						
						attachDTO.setImage(true);
						
						FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));

						Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);//썸네일 만들기

						thumbnail.close();
					}
				}

				list.add(attachDTO);

			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end for
		return new ResponseEntity<>(list, HttpStatus.OK);
	}*/
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/download")		
	public ModelAndView download2(HttpServletRequest request) throws Exception {
		
		return new ModelAndView("DownloadView", "temp", "temp");
	}
	
	/*@GetMapping(value = "/download2", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {

		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		
		log.info("userAgent"+userAgent);
		log.info("fileName"+fileName);
		log.info("resource"+resource);
		
		if (resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		String resourceName = resource.getFilename();
		log.info("resourceName"+resourceName);
		
		// remove UUID
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);

		log.info("resourceOriginalName"+resourceOriginalName);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {

			boolean checkIE = (userAgent.indexOf("MSIE") > -1 || userAgent.indexOf("Trident") > -1);

			String downloadName = null;

			if (checkIE) {
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF8").replaceAll("\\+", " ");
			} else {
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}

			headers.add("Content-Disposition", "attachment; filename=" + downloadName);

			log.info("downloadName"+downloadName);
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}*/
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteS3File")
	@ResponseBody 
	public ResponseEntity<String> deleteS3File(String path, String filename, String type) {

		log.info("deleteS3File: " + path+filename);  
		
		if(s3Util.deleteObject(path, filename)) {
			
			if (type.equals("image")) {//만약 이미지파일이었다면

				s3Util.deleteObject(path, "s_"+filename);//썸네일도 삭제
			}
			
			return new ResponseEntity<String>("deleted", HttpStatus.OK);
		}
		
		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	}
	
	/*@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileCallPath, String type) {

		log.info("deleteFile: " + fileCallPath);  

		File file;

		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileCallPath, "UTF-8"));

			file.delete();//일반파일 or 썸네일파일 지우는것

			if (type.equals("image")) {//만약 이미지파일이었다면

				String largeFileName = file.getAbsolutePath().replace("s_", "");//오리지날 파일도 지워주기

				log.info("largeFileName: " + largeFileName);

				file = new File(largeFileName);

				file.delete();
			}

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}*/

}//end