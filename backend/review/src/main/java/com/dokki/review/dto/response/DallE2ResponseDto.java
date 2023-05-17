package com.dokki.review.dto.response;


import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;


@Data
@NoArgsConstructor
public class DallE2ResponseDto {

	/**
	 * Image ResponseBody
	 * {
	 * "created": 1589478378,
	 * "data": [
	 * {
	 * "url": "https://..."
	 * },
	 * {
	 * "url": "https://..."
	 * }
	 * ]
	 * }
	 */
	private Integer created;
	private List<Map<String, String>> data; // [ {url} ]

}
