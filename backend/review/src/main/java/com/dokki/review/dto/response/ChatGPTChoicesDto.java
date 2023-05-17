package com.dokki.review.dto.response;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;


@NoArgsConstructor
@AllArgsConstructor
@Data
public class ChatGPTChoicesDto {

	private Map<String, String> message;
	private String finish_reason;
	private String index;

}


