package com.dokki.book.util;


import com.dokki.book.config.exception.CustomException;
import com.dokki.util.common.error.ErrorCode;

import java.util.Objects;


public class ServiceUtil {

	public static void isSameUser(Long userIdFromHeader, Long userIdFromDB) {
		if (!Objects.equals(userIdFromDB, userIdFromHeader)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
	}

}
