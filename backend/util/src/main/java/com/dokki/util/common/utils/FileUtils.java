package com.dokki.util.common.utils;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;
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

	// FIXME: Property는 호출하는 서비스 쪽과 같은 패키지 내에 있는 파일 (application.yml)만 참고함.
	//        예) Review 서비스를 실행한 경우, Util 쪽 application.yml이 아니라 REVIEW의 application.yml을 실행해야 함
	//	@Value("${file.upload.uri}")
	private static final String hostUri = "https://dokki.kr";
	@Value("${UPLOAD_PATH}")
	private String uploadPath;
	@Value("${UPLOAD_DIR}")
	private String uploadDir;


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
	public String saveFile(String externalFileUrl) {
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

}
