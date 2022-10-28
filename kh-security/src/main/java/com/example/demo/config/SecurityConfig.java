package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
	
	    @Bean
	    public BCryptPasswordEncoder passwordEncoder() {
	        return new BCryptPasswordEncoder();
	    }
	 
	    @Bean
	    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
	     
	        http.authorizeRequests().antMatchers("/login").permitAll()
	                .anyRequest().authenticated()
	                .and().formLogin()
	                .loginPage("/login")
	                .and()
	                .logout().permitAll();
	 
	        http.headers().frameOptions().sameOrigin();
	 
	        return http.build();
	}
}
