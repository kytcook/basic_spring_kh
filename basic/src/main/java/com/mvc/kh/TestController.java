package com.mvc.kh;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/test")
public class TestController {//localhost:9000/step1/test/testList.sp4
	Logger logger = LoggerFactory.getLogger(TestController.class);
	@GetMapping("testList.sp4")
	public String testList() {
		logger.info("testList 호출");
//		return "forward:testList.jsp";
		return "test/testList";
	}
}
