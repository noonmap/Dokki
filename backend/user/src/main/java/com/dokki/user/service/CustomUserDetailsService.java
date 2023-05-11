package com.dokki.user.service;

import com.dokki.user.entity.UserEntity;
import com.dokki.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Component("userDetailsService")
@RequiredArgsConstructor
@Slf4j
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
        log.info(String.valueOf(id));
        UserDetails userDetails = userRepository.findById(Long.valueOf(id))
                .map(user -> createUser(user))
                .orElseThrow(() -> new UsernameNotFoundException(id + "->데이터베이스에서 찾을 수 없습니다."));
        return userDetails;
    }

    private User createUser(UserEntity userEntity) {

        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));

        User user = new User(String.valueOf(userEntity.getId()),
                userEntity.getPassword(),
                authorities);
        return user;
    }
}
