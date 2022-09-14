package com.basic.step1.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.basic.step1.logic.TestLogic;

//테스트 URL은 무엇입니까?
// localhost:9000/step1/test/testList.sp4
//localhost:9000/step1/test/testList.sp4?test_title=test_title&keyword=게시글
//localhost:9000/step1/test/testList.sp4?test_content=test_content&keyword=내용

@Controller
@RequestMapping("/test/*")
public class TestController {
	Logger logger = LoggerFactory.getLogger(TestController.class);
	@Autowired(required=true)
	private TestLogic testLogic = null;
	//com.util.HashMapBinder -> @RequestParam Map<String,Object>
	//메소드의 파라미터에도 어노테이션이 올 수 있다.
	@GetMapping("testList")
	public String testList(@RequestParam Map<String,Object> pmap, Model model) {
		logger.info(pmap.toString());
		List<Map<String,Object>> testList = null;
		testList = testLogic.testList(pmap);
		logger.info(testList.toString());
		return "forward:testList.jsp";
		//return "test/testList";
	}
	//localhost:9000/step1/test/testDeleteAll.sp4?deptnos=1/2/3
	@GetMapping("testDeleteAll")
	public String testDeleteAll(@RequestParam String testnos) {
		logger.info(testnos);
		String atestnos[] = null;
		atestnos = testnos.split("/");
		testLogic.testDeleteAll(atestnos);
		return "redirect:testList.sp4";
		//return "test/testList";
	}	
	//localhost:9000/step1/test/testInsertAll.sp4
	@GetMapping("testInsertAll")
	public String testInsertAll() {
		logger.info("testInsertAll");
		testLogic.testInsertAll();
		return "redirect:testList.sp4";
		//return "test/testList";
	}	
}
