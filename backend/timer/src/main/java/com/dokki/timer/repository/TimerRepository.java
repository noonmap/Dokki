package com.dokki.timer.repository;


import com.dokki.timer.entity.TimerEntity;
import org.springframework.data.jpa.repository.JpaRepository;


public interface TimerRepository extends JpaRepository<TimerEntity, Long> {

	boolean existsByBookStatusId(Long bookStatusId);
	TimerEntity findByBookStatusId(Long bookStatusId);

}
