package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;

import com.example.demo.logic.TestLogic;

//@Controller
public class TestController {
	Logger logger = LoggerFactory.getLogger(TestController.class);
	//@Autowired
	private TestLogic testLogic = null;
	//setter 객체주입법 코드
	public void setTestLogic(TestLogic testLogic) {
		this.testLogic = testLogic;
	}
	public String testList() {
		logger.info("testList호출 성공"+testLogic);
		testLogic.testList();
		return "test/testList";
	}
}
