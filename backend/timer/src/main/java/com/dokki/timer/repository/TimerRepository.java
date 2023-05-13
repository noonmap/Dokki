package com.dokki.timer.repository;


import com.dokki.timer.entity.TimerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;


public interface TimerRepository extends JpaRepository<TimerEntity, Long> {

	Optional<TimerEntity> findTopByBookStatusId(Long bookStatusId);
	List<TimerEntity> findByBookStatusIdIn(List<Long> idList);

	@Transactional
	void deleteByBookStatusId(Long bookStatusId);

}
