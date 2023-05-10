package com.dokki.review.service;


import com.dokki.review.config.exception.CustomException;
import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.response.ChatGPTResponseDto;
import com.dokki.review.dto.response.DallE2ResponseDto;
import com.dokki.util.common.error.ErrorCode;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
public class DiaryImageService {

	private final String CHATGPT_URL = "https://api.openai.com/v1/chat/completions";
	private final String IMAGE_GENERATION_URL = "https://api.openai.com/v1/images/generations";
	private final RestTemplate restTemplate;
	@Value("${OPENAI_API_TOKEN}")
	private String OPENAI_API_TOKEN;


	private String requestOpenAPI(String requestBody, String requestURL) {
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add("Authorization", "Bearer " + OPENAI_API_TOKEN);
		httpHeaders.add("Content-Type", "application/json");
		HttpEntity<String> httpEntity = new HttpEntity<>(requestBody, httpHeaders);
		String response = "";
		try {
			response = restTemplate.postForObject(requestURL, httpEntity, String.class);
		} catch (HttpClientErrorException e) {
			throw new CustomException(e.getStatusCode().value(), e.getMessage());
		}
		return response;
	}


	/**
	 * AI 이미지 생성
	 *
	 * @return 생성한 이미지 경로 반환
	 */
	public List<String> createAIImage(Long userId, AIImageRequestDto aiImageRequestDto) {
		ObjectMapper objectMapper = new ObjectMapper();

		// TODO : redis에 이미지 생성 횟수 제한 걸어야 한다.
		// Chat GPT 요청
		String diaryContent = aiImageRequestDto.getContent();
		String chatGPTPrompt = String.format("내가 작성한 감상평이야. %s. 이 감상평을 그림으로 그릴 수 있게 100글자 이내의 영어 문장으로 설명해줘.", diaryContent);
		String chatGPTRequestBody = String.format("{\"model\": \"gpt-3.5-turbo\", \"messages\": [{\"role\": \"user\", \"content\": \"%s\"}] }", chatGPTPrompt);
		String chatGPTResponse = requestOpenAPI(chatGPTRequestBody, CHATGPT_URL);
		ChatGPTResponseDto chatGPTResponseDto = null;
		try {
			chatGPTResponseDto = objectMapper.readValue(chatGPTResponse, ChatGPTResponseDto.class);
		} catch (JsonProcessingException e) {
			log.error("json mapping 중 에러가 발생하였습니다.", e.getMessage());
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}

		// DALL-E2 요청
		String imageGenPrompt = chatGPTResponseDto.getChoices()[0].getMessage().get("content");
		String imageGenRequestBody = String.format("{\"prompt\": \"%s\", \"size\": \"256x256\"}", imageGenPrompt);
		String imageGenResponse = requestOpenAPI(imageGenRequestBody, IMAGE_GENERATION_URL);
		DallE2ResponseDto dallE2ResponseDto = null;
		try {
			dallE2ResponseDto = objectMapper.readValue(imageGenResponse, DallE2ResponseDto.class);
		} catch (JsonProcessingException e) {
			log.error("json mapping 중 에러가 발생하였습니다.", e.getMessage());
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}

		return dallE2ResponseDto.getData().stream().map(url -> url.get("url")).collect(Collectors.toList());
		/**
		 * ChatGPT Response Format
		 * {
		 *  'id': 'chatcmpl-6p9XYPYSTTRi0xEviKjjilqrWU2Ve',
		 *  'object': 'chat.completion',
		 *  'created': 1677649420,
		 *  'model': 'gpt-3.5-turbo',
		 *  'usage': {'prompt_tokens': 56, 'completion_tokens': 31, 'total_tokens': 87},
		 *  'choices': [
		 *    {
		 *     'message': {
		 *       'role': 'assistant',
		 *       'content': 'The 2020 World Series was played in Arlington, Texas at the Globe Life Field, which was the new home stadium for the Texas Rangers.'},
		 *     'finish_reason': 'stop',
		 *     'index': 0
		 *    }
		 *   ]
		 * }
		 *
		 * Image ResponseBody
		 * {
		 *   "created": 1589478378,
		 *   "data": [
		 *     {
		 *       "url": "https://..."
		 *     },
		 *     {
		 *       "url": "https://..."
		 *     }
		 *   ]
		 * }
		 */
	}


	public Integer getImageCreationRemainCount(Long userId) {
		return 1;
	}

}
