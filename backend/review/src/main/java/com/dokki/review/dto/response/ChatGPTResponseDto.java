package com.dokki.review.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;


//@Getter
//@Setter
//@Builder
//@ToString
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatGPTResponseDto {

	private String id;
	private String object;
	private Integer created;
	private String model;
	private Map<String, Integer> usage;
	private ChatGPTChoicesDto[] choices;

}
