package com.dokki.util.common.utils;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;


@Component
public class FileUtils {

	@Value("${file.upload.uri}")
	private static String hostUri;


	static public String getAbsoluteFilePath(String filePath) {
		if (filePath.startsWith("http")) {
			return filePath;
		}
		if (filePath.startsWith("/resources")) { // resources 없애줌
			filePath = filePath.replaceFirst("/resources", "");
		}
		return hostUri + File.pathSeparator + filePath;
	}

}
