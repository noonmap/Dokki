package com.dokki.util.common.utils;


import org.springframework.stereotype.Component;

import java.io.File;


@Component
public class FileUtils {

	// FIXME: Property는 호출하는 서비스 쪽과 같은 패키지 내에 있는 파일 (application.yml)만 참고함.
	//	@Value("${file.upload.uri}")
	private static final String hostUri = "https://dokki.kr";


	static public String getAbsoluteFilePath(String filePath) {
		if (filePath == null || filePath.isBlank()) return filePath; // filePath가 비어있는 경우도 있다.
		if (filePath.startsWith("http")) {
			return filePath;
		}
		if (filePath.startsWith("/resources")) { // resources 없애줌
			filePath = filePath.replaceFirst("/resources", "");
		}
		if (filePath.startsWith("/")) {
			return hostUri + filePath;
		}
		return hostUri + File.separator + filePath;
	}

}
