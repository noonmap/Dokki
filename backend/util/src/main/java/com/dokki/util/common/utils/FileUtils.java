package com.dokki.util.common.utils;


import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.File;


@Component
@Slf4j
public class FileUtils {

	public static final String hostUri = "https://dokki.kr";
	// FIXME: Property는 호출하는 서비스 쪽과 같은 패키지 내에 있는 파일 (application.yml)만 참고함.
	//	static {
	//		log.info("[static] get props");
	//		Properties props = new Properties();
	//		try {
	//			props.load(FileUtils.class.getResourceAsStream("/application.yml"));
	//			hostUri = props.getProperty("file.upload.uri");
	//		} catch (IOException e) {
	//			e.printStackTrace();
	//		}
	//	}


	public static String getAbsoluteFilePath(String filePath) {
		//		if (hostUri == null) {
		//			log.info("[getAbsoluteFilePath] hostUri is null");
		//			Properties props = new Properties();
		//			try {
		//				props.load(FileUtils.class.getResourceAsStream("/application.yml"));
		//				hostUri = props.getProperty("file.upload.uri");
		//			} catch (IOException e) {
		//				e.printStackTrace();
		//			}
		//		}
		//		log.info("[getAbsoluteFilePath] {}", hostUri);

		if (filePath.startsWith("http")) {
			return filePath;
		}
		if (filePath.startsWith("/resources")) { // resources 없애줌
			filePath = filePath.replaceFirst("/resources", "");
		}
		if (filePath.startsWith("/"))
			return hostUri + filePath;
		return hostUri + File.separator + filePath;
	}

}
