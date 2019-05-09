package org.zerock.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class UploadController {
	
	private static final String UPLOAD_FOLDER = "C:\\Temp";

	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@PostMapping("/uploadForm")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		for (MultipartFile multipartFile : uploadFile) {
			log.info("-------------------------------------------");
			log.info("originalFileName: " + multipartFile.getOriginalFilename());
			log.info("size: " + multipartFile.getSize());
			log.info("contentType: " + multipartFile.getContentType());
			
			File saveFile = new File(UPLOAD_FOLDER, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("uploadAjax");
	}
	
	@PostMapping("/uploadAjax")
	public void uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("uploadAjax post...");
		
		// make yyyy/MM/dd folder
		File uploadPath = new File(UPLOAD_FOLDER, getFolder());
		log.info("uploadPath: " + uploadPath);
		
		if (!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE의 경우에는 전체 파일 경로가 전송되므로, 마지막 '\'를 기준으로 잘라낸 문자열이 실제 파일 이름이 됩니다.
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			
			log.info("-------------------------------------------");
			log.info("originalFileName: " + uploadFileName);
			log.info("size: " + multipartFile.getSize());
			log.info("contentType: " + multipartFile.getContentType());

			// 파일 이름의 중복 방지
			UUID uid = UUID.randomUUID();
			uploadFileName = uid.toString() + "_" + uploadFileName;
			
			File saveFile = new File(uploadPath, uploadFileName);
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
			 
		}
		
	}

	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
	}
}
