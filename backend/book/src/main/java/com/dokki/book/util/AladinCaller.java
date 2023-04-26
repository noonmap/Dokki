package com.dokki.book.util;//import org.json.JSONObject;


import com.dokki.book.dto.response.AladinSearchResponseDto;
import com.dokki.book.enums.SearchType;
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
	private static final String ALADIN_API_URL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?SearchTarget=Book&Output=JS&Version=20131101&Cover=Big&";


	public static AladinSearchResponseDto searchBook(String search, SearchType queryType, Pageable pageable) throws IOException {
		Map<String, String> params = new HashMap<>();
		params.put("ttbkey", ALADIN_API_KEY);
		params.put("QueryType", queryType.getName());
		params.put("MaxResults", Integer.toString(pageable.getPageSize()));
		params.put("start", Integer.toString(pageable.getPageNumber()));
		params.put("Query", search);

		URL url = new URL(ALADIN_API_URL + getParamsString(params));
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


	public static String getParamsString(Map<String, String> params) {
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

}