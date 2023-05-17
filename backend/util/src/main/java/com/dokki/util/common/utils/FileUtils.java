package com.dokki.util.common.utils;


import com.dokki.util.common.enums.DefaultEnum;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.util.UUID;


@Component
@Slf4j
@RequiredArgsConstructor
public class FileUtils {

	public static final String NGINX_PATH = "/resources/";
	// FIXME: Property는 호출하는 서비스 쪽과 같은 패키지 내에 있는 파일 (application.yml)만 참고함.
	//        예) Review 서비스를 실행한 경우, Util 쪽 application.yml이 아니라 REVIEW의 application.yml을 실행해야 함
	//	@Value("${file.upload.uri}")
	private static final String hostUri = "https://dokki.kr";
	@Value("${UPLOAD_PATH}")
	private String uploadPath;
	@Value("${UPLOAD_DIR}")
	private String uploadDir;
	// 지원하는 이미지 확장자 종류
	private String[] imageExtensions = { ".jpg", ".jpeg", ".jfif", ".gif", ".png" };


	static public String getAbsoluteFilePath(String filePath) {
		if (filePath == null || filePath.isBlank()) return filePath; // filePath가 비어있는 경우도 있다.
		if (filePath.startsWith("http")) {
			return filePath;
		}
		// uploadPath 부분 없애고 상대 경로 남김
		String uploadPath = System.getenv("UPLOAD_PATH"); // static에서는 @Value로 값을 가져올 수 없어서 환경변수를 읽어옴
		if (filePath.startsWith(uploadPath)) {
			filePath = filePath.substring(uploadPath.length());
		} else if (filePath.startsWith("/" + uploadPath)) {
			filePath = filePath.substring(("/" + uploadPath).length());
		}
		if (filePath.startsWith("/")) {
			return hostUri + filePath;
		}
		return hostUri + "/" + filePath;
	}


	/**
	 * fileUrl에 있는 이미지 파일을 dirPath 경로에 저장
	 *
	 * @param externalFileUrl
	 * @return 저장된 이미지 경로를 반환
	 */
	public String storeFileFromExternalUrl(String externalFileUrl) {
		if (externalFileUrl == null || externalFileUrl.isBlank()) {
			return "";
		}
		String filePath = "";
		UUID uuid = UUID.randomUUID();

		// uri query param에서 확장자 가져옴
		MultiValueMap<String, String> queryParams = UriComponentsBuilder.fromUri(URI.create(externalFileUrl)).build().getQueryParams();
		String extension = queryParams.getFirst("rsct");
		extension = extension.substring("image/".length());

		String savingFileName = uuid + "." + extension;
		filePath = "/" + uploadPath + "/" + uploadDir + "/" + savingFileName;
		try {
			org.apache.commons.io.FileUtils.copyURLToFile(new URL(externalFileUrl), new File(filePath));
		} catch (IOException e) {
			log.error(e.toString());
			throw new RuntimeException(e.getMessage());
		}
		return filePath;
	}


	private Boolean isImageFile(String extension) {
		if (extension.isEmpty()) return false;
		// 소문자로 바꿔서 테스트
		String lowerExtension = extension.toLowerCase();
		for (String test : imageExtensions) {
			if (lowerExtension.equals(test)) return true;
		}
		return false;
	}


	/**
	 * 이미지 파일을 물리 서버에 저장
	 *
	 * @param file 저장할 이미지 파일
	 * @return (file.dir 경로를 생략한) 파일 저장 경로
	 * @throws IOException
	 */
	public String storeImageFile(MultipartFile file) {
		// 파일 저장 경로 디렉토리 확인, 없으면 생성
		File fileDirFile = new File(uploadPath);
		if (!fileDirFile.exists()) {
			fileDirFile.mkdir();
		}
		File fileSubDirFile = new File(uploadPath + '/' + uploadDir);
		if (!fileSubDirFile.exists()) {
			fileSubDirFile.mkdir();
		}

		// 파일이 비어있는지 확인
		if (file == null || file.isEmpty()) {
			//			return subFileDir + '/' + DEFAULT_IMAGE_NAME;
			throw new RuntimeException(ErrorCode.FILE_IS_EMPTY.getDescription());
		}

		// 원래 파일 이름 추출
		String origName = file.getOriginalFilename();

		// 파일 이름으로 쓸 uuid 생성
		String uuid = UUID.randomUUID().toString();

		// 확장자 추출(ex : .png)
		String extension = origName.substring(origName.lastIndexOf("."));

		// 이미지 파일인지 확인 (확장자만 체크)
		if (isImageFile(extension) == false) throw new RuntimeException(ErrorCode.FILE_IS_NOT_IMAGE.getDescription());

		// uuid와 확장자 결합
		String savedName = uploadDir + '/' + uuid + extension;

		// 파일을 저장할 때 사용할 파일 경로
		String savedPath = uploadPath + '/' + savedName;
		log.info(savedPath);

		try {
			// 실제로 로컬에 uuid를 파일명으로 저장
			file.transferTo(new File(savedPath));
		} catch (IOException e) {
			//			e.printStackTrace();
			throw new RuntimeException(ErrorCode.FILE_UPLOAD_FAIL.getDescription());
		}

		return savedName;
	}


	// TODO : update할 때 삭제하고 추가하도록 수정
	public void deleteImageFile(String savedName) {
		String[] savedFileName = savedName.split("/");
		if (savedFileName[savedFileName.length - 1].equals(DefaultEnum.USER_PROFILE_IMAGE_PATH)) return; // 기본 이미지는 삭제하지 않음
		String savedPath = uploadPath + '/' + savedName;
		File savedFile = new File(savedPath);
		if (savedFile.exists()) {
			savedFile.delete();
		}
	}

}

