package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
/**********************************************************
 * 스프링 시큐리티가 인터셉트 하는 것을 방어해서 사용자 정의 로그인 페이지로
 * 링크하는데 아래 클래스가 역할이 있다.
 * 프레임워크 관련 설정을 자바만으로 처리할 때 @Configuration 사용됨.
 *  
 * 스프링 시큐리티를 추가하게 되면, 기본적인 로그인 필터기능이 내장되게 된다.
 * 따로 지정하지 않아도 내부적인 콜백에 의해 별도로 준비된 로그인 화면이 열린다.
 * -> 이 기본 화면을 열지 않기 위해서, 환경설정을 해준다.
 * 
 * 시큐리티필터체인 : 
 **********************************************************/

@Configuration
@EnableWebSecurity//스프링 시큐리티 필터가 스프링 필터체인에 등록
public class SecurityConfig {
	
	    @Bean
	    public BCryptPasswordEncoder passwordEncoder() {// 사용자 비번 암호처리
	        return new BCryptPasswordEncoder();
	    }
	 
	    @Bean
	    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	    	http.csrf().disable();
	        http.authorizeRequests()
	        	.antMatchers("/").authenticated()//인증이 되면 들어갈 수 있는 주소가 된다.
	        	.antMatchers("/user/**").hasRole("USER")//user 이면 들어감
	        	.antMatchers("/admin/**").hasRole("ADMIN")//admin 이면 들어감
	        	.anyRequest().permitAll()//나머지는 제낀다
	        	.and()
	        	.formLogin()
	        	.loginPage("/loginForm")
	        	.loginProcessingUrl("/loginAction")// loginForm에서 로그인 클릭하면 loginAction요청을 듣고 -> 시큐리티가 인터셉트하여 대신 로그인 진행을 한다.
	        	.defaultSuccessUrl("/");
	        return http.build();
	}
}
