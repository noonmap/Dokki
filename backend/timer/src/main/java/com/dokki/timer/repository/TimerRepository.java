package com.dokki.timer.repository;


import com.dokki.timer.entity.TimerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;


public interface TimerRepository extends JpaRepository<TimerEntity, Long> {

	Optional<TimerEntity> findTopByBookStatusId(Long bookStatusId);
	List<TimerEntity> findByBookStatusIdIn(List<Long> idList);

	@Transactional
	void deleteByBookStatusId(Long bookStatusId);

	@Transactional
	@Modifying
	@Query(value = "update dokki.timer set accum_time = accum_time + :accumTime, end_time = :endTime where id = :id", nativeQuery = true)
	int updateAccumTime(@Param("accumTime") int accumTime, @Param("endTime") LocalDate endTime, @Param("id") Long id);

}
