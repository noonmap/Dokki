package com.dokki.review.service;


import com.dokki.review.config.exception.CustomException;
import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.response.ChatGPTResponseDto;
import com.dokki.review.dto.response.DallE2ResponseDto;
import com.dokki.review.redis.DiaryImageRedis;
import com.dokki.review.redis.DiaryImageRedisService;
import com.dokki.util.common.enums.DefaultEnum;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.utils.FileUtils;
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
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
public class DiaryImageService {

	private final String CHATGPT_URL = "https://api.openai.com/v1/chat/completions";
	private final String IMAGE_GENERATION_URL = "https://api.openai.com/v1/images/generations";
	private final RestTemplate restTemplate;
	private final DiaryImageRedisService diaryImageRedisService;
	private final FileUtils fileUtils;
	private final Integer AI_IMAGE_COUNT_MAX = Integer.valueOf(DefaultEnum.AI_IMAGE_COUNT_MAX.getValue());
	@Value("${OPENAI_API_TOKEN}")
	private String OPENAI_API_TOKEN;


	private static void loggingStackTrace(Exception e) {
		StringBuilder errMsg = new StringBuilder();
		for (StackTraceElement stackTrace : e.getStackTrace())
			errMsg.append(stackTrace.toString()).append('\n');
		log.error(errMsg.toString());
	}


	private String requestOpenAPI(String requestBody, String requestURL) {
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add("Authorization", "Bearer " + OPENAI_API_TOKEN);
		httpHeaders.add("Content-Type", "application/json");
		HttpEntity<String> httpEntity = new HttpEntity<>(requestBody, httpHeaders);
		String response = "";
		try {
			response = restTemplate.postForObject(requestURL, httpEntity, String.class);
		} catch (HttpClientErrorException e) {
			//			e.printStackTrace();
			//			loggingStackTrace(e);
			log.error("restTemplate API 호출 과정에서 에러가 발생하였습니다.", e.getMessage());
			if (e.getStatusCode().value() == 429) {
				throw new CustomException(ErrorCode.AI_API_TOO_MANY_REQUESTS);
			} else {
				throw new CustomException(ErrorCode.AI_API_CLIENT_ERROR);
			}
		}
		return response;
	}


	/**
	 * AI 이미지 생성
	 *
	 * @return 생성한 이미지 경로 반환
	 */
	public String createAIImage(Long userId, AIImageRequestDto aiImageRequestDto) {
		if (isEnableCreateImage(userId) == false) throw new CustomException(ErrorCode.AI_IMAGE_COUNT_LIMIT_REACHED);

		ObjectMapper objectMapper = new ObjectMapper();

		// Chat GPT 요청
		log.info("Call ChatGPT");
		String diaryContent = aiImageRequestDto.getContent();
		String chatGPTPrompt = String.format("내가 작성한 감상평이야. %s. 이 감상평을 그림으로 그릴 수 있게 100글자 이내의 영어 문장으로 설명해줘.", diaryContent);
		String chatGPTRequestBody = String.format("{\"model\": \"gpt-3.5-turbo\", \"messages\": [{\"role\": \"user\", \"content\": \"%s\"}] }", chatGPTPrompt);
		String chatGPTResponse = requestOpenAPI(chatGPTRequestBody, CHATGPT_URL);
		ChatGPTResponseDto chatGPTResponseDto = null;
		try {
			chatGPTResponseDto = objectMapper.readValue(chatGPTResponse, ChatGPTResponseDto.class);
		} catch (JsonProcessingException e) {
			//			loggingStackTrace(e);
			log.error("ChatGPT의 결과를 json mapping 하는 중 에러가 발생하였습니다.", e.getMessage());
			throw new CustomException(ErrorCode.JSON_MAPPING_ERROR);
		}

		// DALL-E2 요청
		log.info("Call DALL-E2");
		String imageGenPrompt = chatGPTResponseDto.getChoices()[0].getMessage().get("content");
		// content에 쌍따옴표로 감싸여져있는 경우가 있음. API 요청 에러를 발생시킴 -> 제거해주기
		imageGenPrompt = imageGenPrompt.replaceAll("\"", "");

		String imageGenRequestBody = String.format("{\"prompt\": \"%s\", \"size\": \"256x256\"}", imageGenPrompt);
		String imageGenResponse = requestOpenAPI(imageGenRequestBody, IMAGE_GENERATION_URL);
		DallE2ResponseDto dallE2ResponseDto = null;
		try {
			dallE2ResponseDto = objectMapper.readValue(imageGenResponse, DallE2ResponseDto.class);
		} catch (JsonProcessingException e) {
			//			loggingStackTrace(e);
			log.error("DALLE-2의 결과를 json mapping 중 에러가 발생하였습니다.", e.getMessage());
			throw new CustomException(ErrorCode.JSON_MAPPING_ERROR);
		}

		increaseImageCreationRequestCount(userId); // 생성한 카운트 증가
		List<String> imageUrlList = dallE2ResponseDto.getData().stream().map(url -> url.get("url")).collect(Collectors.toList());

		// 생성한 이미지를 저장
		String savedImagePath = fileUtils.storeFileFromExternalUrl(imageUrlList.get(0));
		return savedImagePath;
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


	/**
	 * 오늘 요청한 AI Image 생성 횟수 조회
	 *
	 * @param userId
	 * @return
	 */
	private Integer getImageCreationRequestCount(Long userId) {
		// redis에서 userId로 저장된 값이 있으면 가져옴
		//      LocalDate를 비교 -> 오늘 날짜이면 return / 이전 날짜이면 0으로 초기화 & return
		// 없으면 0 return
		// -> 최대 횟수 - requestCount 한 걸 return
		Optional<DiaryImageRedis> diaryImageRedis = diaryImageRedisService.getDiaryImageRedis(userId);
		if (diaryImageRedis.isEmpty()) {
			diaryImageRedisService.setDiaryImageRedis(userId, 0);
			return 0;
		}
		LocalDate requestDate = diaryImageRedis.get().getRequestDate();
		if (requestDate.isBefore(LocalDate.now())) { // 저장된 날짜가 오늘 이전이면
			diaryImageRedisService.setDiaryImageRedis(userId, 0);
			return 0;
		}
		return diaryImageRedis.get().getRequestCount();
	}


	/**
	 * 해당 유저가 오늘 AI Image 생성 횟수가 남았는지 확인
	 *
	 * @param userId
	 * @return 남았으면 true, 아니면 false
	 */
	private boolean isEnableCreateImage(Long userId) {
		Integer requestCount = getImageCreationRequestCount(userId);
		if (requestCount < AI_IMAGE_COUNT_MAX) return true;
		return false;
	}


	/**
	 * AI Image 생성 횟수를 증가
	 *
	 * @param userId
	 */
	private void increaseImageCreationRequestCount(Long userId) {
		if (false == isEnableCreateImage(userId)) throw new CustomException(ErrorCode.AI_IMAGE_COUNT_LIMIT_REACHED);
		Integer requestCount = getImageCreationRequestCount(userId);
		diaryImageRedisService.setDiaryImageRedis(userId, requestCount + 1);
	}


	/**
	 * 오늘 AI 이미지 생성 요청 가능한 남은 횟수를 조회
	 *
	 * @param userId
	 * @return
	 */
	public Integer getImageCreationRemainCount(Long userId) {
		Integer requestCount = getImageCreationRequestCount(userId);
		return AI_IMAGE_COUNT_MAX - requestCount;
	}


	public String uploadUserSelectedImage(MultipartFile image) {
		if (image == null || image.isEmpty()) {
			throw new CustomException(ErrorCode.FILE_IS_EMPTY);
		}
		String savedPath = "";
		try {
			savedPath = fileUtils.storeImageFile(image);
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.FILE_UPLOAD_FAIL);
		}
		return savedPath;
	}

}
