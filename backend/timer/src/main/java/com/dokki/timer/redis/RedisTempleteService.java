package com.dokki.timer.redis;


import com.google.common.base.Charsets;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.redis.core.Cursor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ScanOptions;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


@Log4j2
@Service
@RequiredArgsConstructor
public class RedisTempleteService {

	private final RedisTemplate<String, Object> redisTemplate;
	

	public List<String> getTodayDailyStatisticsIdListByUserId(Long userId) {
		// keys "daily:{userId}:{LocalDate.now()}:*"
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		String todayStr = zonedDateTime.toLocalDate().toString();

		String patternStr = String.format("daily:%d:%s:*", userId, todayStr);
		return getIdListPattern(patternStr, "daily");
	}


	public List<String> getTimerIdListPastData(int minusDay) {
		// keys "timer:*:{date}:*"
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		LocalDate localDate = zonedDateTime.toLocalDate();

		String patternStr = String.format("timer:*:%s:*", localDate.minusDays(minusDay));
		return getIdListPattern(patternStr, "timer");
	}


	public List<String> getDailyStatisticsIdListPastData(int minusDay) {
		// keys "daily:*:{date}:*"
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		LocalDate localDate = zonedDateTime.toLocalDate();

		String patternStr = String.format("daily:*:%s:*", localDate.minusDays(minusDay));
		return getIdListPattern(patternStr, "daily");
	}


	private List<String> getIdListPattern(String pattern, String hashValue) {
		Set<String> idSet = new HashSet<>();
		ScanOptions scanOptions = ScanOptions.scanOptions().match(pattern).count(10).build();
		Cursor<byte[]> cursor = redisTemplate.getConnectionFactory().getConnection().scan(scanOptions);

		while (cursor.hasNext()) {
			byte[] next = cursor.next();
			String matchedKey = new String(next, Charsets.UTF_8);
			idSet.add(matchedKey);
		}
		return convertToRepositoryId(List.copyOf(idSet), hashValue);
	}


	private List<String> convertToRepositoryId(List<String> templeteIdList, String hashValue) {
		return templeteIdList.stream().map(o -> o.replaceFirst(hashValue + ":", "")).collect(Collectors.toList());   // 키에서 RedisHash value 제거
	}

}
