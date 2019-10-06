/*package org.my.s3;

import java.io.File;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.logging.Logger;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.util.IOUtils;

import software.amazon.awssdk.services.apigatewayv2.model.Model;

@Controller
public class UploadController {

	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

	@Inject
	private ImageService service;

	S3Util s3 = new S3Util();
	String bucketName = "almombucket";

	@Inject
	private UserService userService;

	//자격증 & 신분증 이미지 업로드
	@ResponseBody
	@RequestMapping(value = "/uploadAjaxCert", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	public String uploadAjaxCertificate(MultipartFile file) throws Exception {

		logger.info("자격증");
		logger.info("originalName: " + file.getOriginalFilename());
		String uploadpath = "almom/certificate";

		ResponseEntity<String> img_path = new ResponseEntity<>(
				UploadFileUtils.uploadFile(uploadpath, file.getOriginalFilename(), file.getBytes()),
				HttpStatus.CREATED);
		String certificatePath = (String) img_path.getBody();

		return certificatePath;
	}

	//커버이미지 업로드
	@ResponseBody
	@RequestMapping(value = "/uploadAjaxCover", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	public String uploadAjaxCoverImg(MultipartFile file) throws Exception {

		logger.info("커버이미지");
		logger.info("originalName: " + file.getOriginalFilename());
		String uploadpath = "almom/coverImage";

		ResponseEntity<String> img_path = new ResponseEntity<>(
				UploadFileUtils.uploadFile(uploadpath, file.getOriginalFilename(), file.getBytes()),
				HttpStatus.CREATED);
		String coverImagePath = (String) img_path.getBody();

		return coverImagePath;
	}

	// 프로필 이미지 업로드
	@ResponseBody
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	public String uploadAjax(MultipartFile file, String str, HttpSession session, HttpServletRequest request,
			Model model) throws Exception {

		logger.info("originalName: " + file.getOriginalFilename());
		//프로필 이미지의 추가경로
		String uploadpath = "almom/profileImage";

		ResponseEntity<String> img_path = new ResponseEntity<>(
				UploadFileUtils.uploadFile(uploadpath, file.getOriginalFilename(), file.getBytes()),
				HttpStatus.CREATED);

		String user_imgPath = (String) img_path.getBody();

		logger.info(user_imgPath);

		UserVO vo = new UserVO();
		vo.setUser_profileImagePath(user_imgPath);
		UserVO userSession = (UserVO) session.getAttribute("login");
		vo.setUser_id(userSession.getUser_id());
		logger.info("file name : " + user_imgPath);

		userService.uploadImg(vo);

		userSession.setUser_profileImagePath(user_imgPath);
		session.setAttribute("login", userSession);
		logger.info(user_imgPath);
		return user_imgPath;
	}


	//프로필 이미지
	@SuppressWarnings("resource")
	@ResponseBody
	@RequestMapping("/displayFile")
	public ResponseEntity<byte[]> displayFile(String fileName, String directory) throws Exception {
		logger.info(directory);
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		HttpURLConnection uCon = null;
		logger.info("FILE NAME: " + fileName);

		String inputDirectory = null;
		if(directory.equals("profile")) {
			inputDirectory = "almom/profileImage";
		}
		else if(directory.equals("certificate")) {
			inputDirectory = "almom/certificate";
		}else {
			inputDirectory = "almom/coverImage";
		}



		try {
			HttpHeaders headers = new HttpHeaders();
			URL url;
			try {
				url = new URL(s3.getFileURL(bucketName, inputDirectory+fileName));
				uCon = (HttpURLConnection) url.openConnection();
				in = uCon.getInputStream(); // 이미지를 불러옴
			} catch (Exception e) {
				url = new URL(s3.getFileURL(bucketName, "default.jpg"));
				uCon = (HttpURLConnection) url.openConnection();
				in = uCon.getInputStream();
			}

			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}
		return entity;
	}

	@ResponseBody
	@RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
	public ResponseEntity<String> deleteFile(String fileName, String directory)throws Exception {

		logger.info("delete file: " + fileName);
		logger.info("delete foloder:"+directory);
		String inputDirectory = null;
		if(directory.equals("profile")) {
			inputDirectory = "almom/profileImage";
		}
		else if(directory.equals("certificate")) {
			inputDirectory = "almom/certificate";
		}else {
			inputDirectory = "almom/coverImage";
		}
		URL url;
		HttpURLConnection uCon = null;

		try {
			s3.fileDelete(bucketName, inputDirectory+fileName);
		} catch (Exception e) {
// s3.fileDelete(bucketName, "s_user.jpg");
			e.printStackTrace();
		}

		new File(inputDirectory + fileName.replace('/', File.separatorChar)).delete();

		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	@ResponseBody
	@RequestMapping(value = "/deleteFileDB", method = RequestMethod.POST)
	public ResponseEntity<String> deleteFileDB(String fileName, String directory)throws Exception {

		logger.info("delete file: " + fileName);
		logger.info("delete foloder:"+directory);
		String inputDirectory = null;
		if(directory.equals("profile")) {
			inputDirectory = "almom/profileImage";
		}
		else if(directory.equals("certificate")) {
			inputDirectory = "almom/certificate";
		}else {
			inputDirectory = "almom/coverImage";
		}
		URL url;
		HttpURLConnection uCon = null;

		try {
			s3.fileDelete(bucketName, inputDirectory+fileName);
		} catch (Exception e) {
// s3.fileDelete(bucketName, "s_user.jpg");
			e.printStackTrace();
		}
		service.deleteImage(fileName);
		new File(inputDirectory + fileName.replace('/', File.separatorChar)).delete();

		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}


}*/