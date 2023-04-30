package com.dokki.user.config;

import com.dokki.user.redis.RedisService;
import com.dokki.user.security.jwt.JwtAccessDeniedHandler;
import com.dokki.user.security.jwt.JwtAuthenticationEntryPoint;
import com.dokki.user.security.jwt.JwtSecurityConfig;
import com.dokki.user.security.jwt.TokenProvider;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;


@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
@RequiredArgsConstructor
public class SecurityConfig {
	private final TokenProvider tokenProvider;
	private final RedisService redisService;
	private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
	private final JwtAccessDeniedHandler jwtAccessDeniedHandler;


	@Bean
	public PasswordEncoder passwordEncoder(){
		return new BCryptPasswordEncoder();
	}
	@Bean
	public WebSecurityCustomizer webSecurityCustomizer(){
		return(web) -> web.ignoring()
				.antMatchers("/favicon.ico");
	}
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http
				.csrf().disable()
				.formLogin().disable()
				.headers().frameOptions().disable()

				.and()
				.cors().configurationSource(corsConfigurationSource())
				/**401, 403 Exception 핸들링 */
				.and()
				.exceptionHandling()
				.authenticationEntryPoint(jwtAuthenticationEntryPoint)
				.accessDeniedHandler(jwtAccessDeniedHandler)

				/**세션 사용하지 않음*/
				.and()
				.logout().disable()
				.sessionManagement()
				.sessionCreationPolicy(SessionCreationPolicy.STATELESS)

				/** HttpServletRequest를 사용하는 요청들에 대한 접근 제한 설정*/
				.and()
				.authorizeRequests()
				.antMatchers(HttpMethod.OPTIONS).permitAll()
				.antMatchers("/login/**").permitAll()
//                .antMatchers("/swagger-ui/**").permitAll()
//                .antMatchers("/boards/**").permitAll()
//                .antMatchers("/protects/**").permitAll()
//                .antMatchers("/user/login/*").permitAll()
//                .antMatchers("/user/refresh").permitAll()
				.anyRequest().authenticated()

				/**JwtSecurityConfig 적용 */
				.and()
				.apply(new JwtSecurityConfig(tokenProvider, redisService));

		return http.build();
	}
	@Bean
	CorsConfigurationSource corsConfigurationSource(){
		CorsConfiguration configuration = new CorsConfiguration();

		configuration.setAllowedOriginPatterns(Arrays.asList("*"));
		configuration.setAllowedMethods(Arrays.asList("HEAD","POST","GET","DELETE","PUT"));
		configuration.setAllowedHeaders(Arrays.asList("*"));
		configuration.setAllowCredentials(true);
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**",configuration);
		return source;
	}
}
