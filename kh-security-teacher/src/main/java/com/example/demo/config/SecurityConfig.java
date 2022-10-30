package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
//스프링 시큐리티가 인터셉트 하는 것을 방어해서 사용자 정의 로그인 페이지로
//링크하는데 아래 클래스가 역할이 있다.
//프레임워크 관련 설정을 자바만으로 처리할 때 @Configuration 사용됨

@Configuration
@EnableWebSecurity//스프링 시큐리티 필터가 스프링 필터체인에 등록
public class SecurityConfig {
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {//사용자 비번 암호처리
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    	http.csrf().disable();
        http.authorizeRequests()
            .antMatchers("/").authenticated()
            .antMatchers("/user/**").hasRole("USER")//user 이면 들어감
            .antMatchers("/admin/**").hasRole("ADMIN")//admin 이면 들어감
            .anyRequest().permitAll()
            .and()
            .formLogin()
            .loginPage("/loginForm")
            //loginForm에서 로그인클릭하면 loginAction요청을 듣고
            //시큐리티가 인터셉트하여 대신 로그인 진행을 한다
            .loginProcessingUrl("/loginAction")
            .defaultSuccessUrl("/");
        return http.build();
    }
 
}