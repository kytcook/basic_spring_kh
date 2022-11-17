package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.vo.AjaxResponseVO;
import com.example.demo.vo.MemberVO;

@Controller
// http://localhost:9000/ 엔터치면
// 클래스 앞에 업무명으로 공통이름을 작성하기
@RequestMapping("/home/*")
public class HomeController {
	Logger logger = LoggerFactory.getLogger(HomeController.class);
	//	//http://localhost:9000/home/5 엔터치면 
	@GetMapping("{id}")
	public String main(@PathVariable int id) {// 해시값 - 라우터 - @PathVariable
		logger.info("id : "+id);
		return "home/main";//ViewResolver 관여 - application.yml -> WEB-INF/views/home/main.jsp(접미어)
	}
	//http://localhost:9000/home/news?date=5 엔터하면 news.jsp페이지 열림
	//http://localhost:9000/news?date=5엔터하면 http://localhost:9000/index.jsp페이지 열림
	//http://localhost:9000/home/news?date=5&name=1&age=33
	@GetMapping("news")
	public String news( String date, String name, int age) {
		logger.info("date : "+date+", name:"+name+", age:"+age);
		return "home/news";
	}
	@ResponseBody
	@PostMapping("ajaxPost")
	public AjaxResponseVO<Integer> ajaxPost(@RequestBody MemberVO mVO) {// RequestParam -> form전송
		logger.info(HttpStatus.OK+"");
		logger.info("아이디 : "+mVO.getMem_id());
		logger.info("이름: "+mVO.getMem_name());
		logger.info("ajaxPost 호출");
		//return "1";
		return new AjaxResponseVO<Integer>(HttpStatus.OK.value(), 1);
	}	
	@ResponseBody
	@GetMapping("ajaxPost2")
	public AjaxResponseVO<Integer> ajaxPost2(MemberVO mVO) {
		logger.info("ajaxPost2 호출");
		logger.info(HttpStatus.OK+"");
		logger.info("아이디 : "+mVO.getMem_id());
		logger.info("이름: "+mVO.getMem_name());
		//return "1";
		return new AjaxResponseVO<Integer>(HttpStatus.OK.value(), 1);
	}	
}
