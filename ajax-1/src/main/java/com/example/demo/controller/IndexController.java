package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// 스프링 경유하지 않음 - HttpServlet 타게됨
// http://localhost:9000/index.jsp

// ComponentScan 어노테이션 디폴트로 잡힌 패키지 모두 읽기 - 언제 - 서버기동할 때
@Controller
// http://localhost:9000/ 엔터치면
// 스프링을 경유함 - DispatcherServlet 경유
@RequestMapping("/*")
public class IndexController {
	Logger logger = LoggerFactory.getLogger(IndexController.class);
	//http://localhost:9000 엔터치면 
	@GetMapping({"","/"})
	public String index() {
		logger.info("index 요청");
		return "redirect:index.jsp";
	}
	
}
