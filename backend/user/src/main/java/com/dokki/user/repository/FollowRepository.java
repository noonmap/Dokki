package com.dokki.user.repository;


import com.dokki.user.entity.FollowEntity;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface FollowRepository extends JpaRepository<FollowEntity, Long> {

	// 팔로잉 조회
	Slice<FollowEntity> findByFromUserIdOrderByIdDesc(Long userId);

	// 팔로워 조회
	Slice<FollowEntity> findByToUserIdOrderByIdDesc(Long userId);

	boolean existsByFromUserIdAndToUserId(Long fromUserId, Long toUserId);

	Optional<FollowEntity> findByFromUserIdAndToUserId(Long fromUserId, Long toUserId);

}
