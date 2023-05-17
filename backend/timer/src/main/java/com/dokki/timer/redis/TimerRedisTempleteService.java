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
public class TimerRedisTempleteService {

	private final RedisTemplate<String, Object> redisTemplate;


	public List<String> getIdListByUserId(Long userId) {
		// keys "timer:{userId}:{LocalDate.now()}:*"
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		String todayStr = zonedDateTime.toLocalDate().toString();

		String patternStr = String.format("timer:%d:%s:*", userId, todayStr);
		return getIdListPattern(patternStr);
	}


	public List<String> getIdListPastData(int minusDay) {
		// keys "timer:*:{date}:*"
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		LocalDate localDate = zonedDateTime.toLocalDate();

		String patternStr = String.format("timer:*:%s:*", localDate.minusDays(minusDay));
		return getIdListPattern(patternStr);
	}


	private List<String> getIdListPattern(String pattern) {
		Set<String> idSet = new HashSet<>();
		ScanOptions scanOptions = ScanOptions.scanOptions().match(pattern).count(10).build();
		Cursor<byte[]> cursor = redisTemplate.getConnectionFactory().getConnection().scan(scanOptions);

		while (cursor.hasNext()) {
			byte[] next = cursor.next();
			String matchedKey = new String(next, Charsets.UTF_8);
			idSet.add(matchedKey);
		}
		return convertToRepositoryId(List.copyOf(idSet));
	}


	private List<String> convertToRepositoryId(List<String> templeteIdList) {
		return templeteIdList.stream().map(o -> o.replaceFirst("timer:", "")).collect(Collectors.toList());   // 키에서 RedisHash value 제거
	}

}
