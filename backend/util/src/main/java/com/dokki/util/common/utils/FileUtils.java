package com.dokki.util.common.utils;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;


@Component
@Slf4j
@RequiredArgsConstructor
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
			filePath = filePath.substring("/resources".length());
		}
		if (filePath.startsWith("/")) {
			return hostUri + filePath;
		}
		return hostUri + File.separator + filePath;
	}


	/**
	 * fileUrl에 있는 이미지 파일을 dirPath 경로에 저장
	 *
	 * @param saveDirPath
	 * @param externalFileUrl
	 * @return 저장된 이미지 경로를 반환
	 */
	public String saveFile(String saveDirPath, String externalFileUrl) {
		if (externalFileUrl == null || externalFileUrl.isBlank()) {
			return "";
		}
		String filePath = "";
		try (
			BufferedInputStream in = new BufferedInputStream(new URL(externalFileUrl).openStream());
		) {
			UUID uuid = UUID.randomUUID();

			MultiValueMap<String, String> queryParams = UriComponentsBuilder.fromUri(URI.create(externalFileUrl)).build().getQueryParams();
			String extension = queryParams.getFirst("rsct");
			if (extension == null || !extension.startsWith("image/")) {

			}
			extension = extension.substring("image/".length());

			String savingFileName = uuid + "." + extension;
			filePath = saveDirPath + File.separator + savingFileName;
			Files.copy(in, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			log.error(e.getMessage());
		}
		return "";
	}

}
