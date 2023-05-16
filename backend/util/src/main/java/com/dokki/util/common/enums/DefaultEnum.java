package com.dokki.util.common.enums;


import lombok.Getter;


@Getter
public enum DefaultEnum {
	/* FIXME : enum 필드 컨벤션
	    - name : {MSA SERVICE 이름}_{필드 이름}, 또는 특정 SERVICE에 구애되지 않는 경우 {임의로 정한 필드 이름}
	    - value : default value (String으로 저장, 가져다 쓸 때 필요한 타입으로 변환해서 사용. ex: Integer.parseInt(value))
	 */
	USER_NICKNAME(""),
	USER_PROFILE_IMAGE_PATH("/images/default.png"),
	BOOK_BOOK_STATUS_ID("-1"),
	BOOK_BOOK_TITLE(""),
	REVIEW_DIARY_IMAGE_PATH("/images/default.png"),
	AI_IMAGE_COUNT_MAX("5");

	private String value;


	DefaultEnum(String _value) {
		this.value = _value;
	}
}
