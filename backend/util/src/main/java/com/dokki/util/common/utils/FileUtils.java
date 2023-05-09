package com.dokki.util.common.utils;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.io.File;


@Component
@ConfigurationProperties(prefix = "file")
public class FileUtils {

	public static String hostUri;


	public FileUtils(@Value("${file.upload.uri}") String uri) {
		this.hostUri = uri;
	}


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

	//	@Value("${file.upload.uri}")
	//	public void setHostUri(String uri) {
	//		this.hostUri = uri;
	//	}

}
