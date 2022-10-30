package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {
	Logger logger = LoggerFactory.getLogger(HomeController.class);
	@GetMapping({"", "/"})
	public String home() {
		logger.info("home호출");
		return "redirect:home.jsp";
	}
	@GetMapping("/user")
	public @ResponseBody String user() {
		return "유저페이지 입니다.";
	}
	@GetMapping("/admin")
	public @ResponseBody String admin() {
		return "관리자페이지 입니다.";
	}
	@GetMapping("/loginForm")
	public String loginForm() {
		return "redirect:loginForm.jsp";
	}
	@GetMapping("/memberForm")
	public String memberForm() {
		return "redirect:memberForm.jsp";
	}
}
