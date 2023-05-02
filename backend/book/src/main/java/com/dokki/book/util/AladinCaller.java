package com.dokki.book.util;//import org.json.JSONObject;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.AladinSearchResponseDto;
import com.dokki.book.enums.SearchType;
import com.dokki.util.common.error.ErrorCode;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;


@Slf4j
public class AladinCaller {

	private static final String ALADIN_API_KEY = "ttbtjrghks961722001";
	private static final String ALADIN_SEARCH_API_URL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?SearchTarget=Book&output=JS&Version=20131101&";
	private static final String ALADIN_DETAIL_API_URL = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?output=JS&Version=20131101&";


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


	public static AladinSearchResponseDto searchBook(String search, SearchType queryType, Pageable pageable) throws IOException, RuntimeException {
		// set parameter
		Map<String, String> params = new HashMap<>();
		params.put("ttbkey", ALADIN_API_KEY);
		params.put("Cover", "midbig");
		params.put("QueryType", queryType.getName());
		params.put("MaxResults", Integer.toString(pageable.getPageSize()));
		params.put("start", Integer.toString(pageable.getPageNumber()));
		params.put("Query", search);

		URL url = new URL(ALADIN_SEARCH_API_URL + getParamsString(params));
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");

		if (conn.getResponseCode() != 200) {
			throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
		}

		// api 응답 읽기
		BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

		String output;
		StringBuilder sb = new StringBuilder();
		while ((output = br.readLine()) != null) {
			sb.append(output);
		}
		conn.disconnect();

		// string -> json
		String jsonString = sb.toString();
		GsonBuilder gsonBuilder = new GsonBuilder()
			.registerTypeAdapter(LocalDate.class, new LocalDateSerializer())
			.registerTypeAdapter(LocalDate.class, new LocalDateDeserializer());
		Gson gson = gsonBuilder.setPrettyPrinting().create();

		AladinSearchResponseDto result = gson.fromJson(jsonString, AladinSearchResponseDto.class);

		// aladin api error handle
		if (result.getErrorCode() != null) {
			throw new RuntimeException(result.getErrorMessage());
		}

		return result;
	}


	public static AladinItemResponseDto getBook(String bookId) throws IOException, RuntimeException {
		// set parameter
		Map<String, String> params = new HashMap<>();
		params.put("ttbkey", ALADIN_API_KEY);
		params.put("Cover", "big");
		params.put("ItemIdType", "ISBN13");
		params.put("ItemId", bookId);

		URL url = new URL(ALADIN_DETAIL_API_URL + getParamsString(params));
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");

		if (conn.getResponseCode() != 200) {
			throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
		}

		// api 응답 읽기
		BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

		String output;
		StringBuilder sb = new StringBuilder();
		while ((output = br.readLine()) != null) {
			sb.append(output);
		}
		conn.disconnect();

		// string -> json
		String jsonString = sb.toString();
		GsonBuilder gsonBuilder = new GsonBuilder()
			.registerTypeAdapter(LocalDate.class, new LocalDateSerializer())
			.registerTypeAdapter(LocalDate.class, new LocalDateDeserializer());
		Gson gson = gsonBuilder.setPrettyPrinting().create();

		AladinSearchResponseDto searchResult = gson.fromJson(jsonString, AladinSearchResponseDto.class);

		// aladin api error handle
		if (searchResult.getErrorCode() != null) {
			if (searchResult.getErrorCode() == 8) { // aladin errorcode about item not exist
				throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
			} else {
				throw new RuntimeException(searchResult.getErrorMessage());
			}
		}

		// api detail search provide only 1 item
		return searchResult.getItem().get(0);
	}


	private static String getParamsString(Map<String, String> params) {
		StringBuilder result = new StringBuilder();
		for (Map.Entry<String, String> entry : params.entrySet()) {
			result.append(entry.getKey());
			result.append("=");
			result.append(entry.getValue());
			result.append("&");
		}
		String resultString = result.toString();
		return resultString.length() > 0 ? resultString.substring(0, resultString.length() - 1) : resultString;
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