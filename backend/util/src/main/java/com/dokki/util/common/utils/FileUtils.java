package com.dokki.util.common.utils;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;


@Component
@Slf4j
//@ConfigurationProperties(prefix = "file")
public class FileUtils {

	public static String hostUri;

	//	public FileUtils(@Value("${file.upload.uri}") String uri) {
	//		this.hostUri = uri;
	//	}


	public static String getAbsoluteFilePath(String filePath) {

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


	@Value("${file.upload.uri}")
	public void setHostUri(String uri) {
		log.info("[HostUri] {}", uri);
		log.info("[HostUri] {}", hostUri);
		this.hostUri = uri;
	}

}
