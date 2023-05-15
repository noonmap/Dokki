package com.dokki.book.util;//import org.json.JSONObject;


import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;


@Slf4j
public class AladinUtil {

	public static boolean isValidUrl(String imgPath) {
		try {
			URL url = new URL(imgPath);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			if (conn.getResponseCode() != 200) {    // 없는 이미지 경로일 경우
				return false;
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		return true;
	}


	/**
	 * 책 표지 사진으로 옆면, 뒷면 사진 경로 가져오기
	 *
	 * @return
	 */
	public static String[] getOtherCoverPath(String coverImageFullPath) {
		String basePath = "https://image.aladin.co.kr/product/";
		String[] splitImagePath = coverImageFullPath.replaceFirst(basePath, "").split("/");
		String imagePath = "";
		String fileName = "";

		if (splitImagePath.length == 4) {
			imagePath = splitImagePath[0]
				+ '/'
				+ splitImagePath[1];
			fileName = splitImagePath[3];
			fileName = fileName.split("_")[0];
		}

		String coverBackImagePath = basePath + imagePath + '/' + "letslook" + '/' + fileName + "_b.jpg";
		String coverSideImagePath = basePath + imagePath + '/' + "spineflip" + '/' + fileName + "_d.jpg";
		return new String[] { coverBackImagePath, coverSideImagePath };
	}

}