package com.dokki.util.common.error;


import java.util.HashMap;
import java.util.Map;


//@Component
public class ErrorUtils {

	private final Map<String, ErrorCode> errorCodeMap; // <ErrorCode.code, ErrorCode>


	public ErrorUtils() {
		this.errorCodeMap = new HashMap<>();
		parsingErrorCode();
	}


	private void parsingErrorCode() {
		for (ErrorCode errorCode : ErrorCode.values()) {
			errorCodeMap.put(errorCode.getCode(), errorCode);
		}
	}


	/**
	 * ErrorCode.code로 ErrorCode를 검색 및 반환.
	 * 해당하는 code가 존재하지 않거나 code가 빈 문자열인 경우 ErrorCode.UNKNOWN_ERROR를 반환
	 *
	 * @param code
	 * @return
	 */
	public ErrorCode getErrorCodeByCode(String code) {
		if (code.isBlank() || errorCodeMap.containsKey(code)) return errorCodeMap.get(code);
		return ErrorCode.UNKNOWN_ERROR;
	}

}
