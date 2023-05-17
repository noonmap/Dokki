package com.dokki.user.repository;


import com.dokki.user.entity.UserEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findByEmail(String email);
    Slice<UserEntity> findSliceByNicknameContains(String nickname, Pageable pageable);
    Optional<UserEntity> findById(Long id);
    List<UserEntity> findByIdIn(List<Long> id);
}
