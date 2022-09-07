package com.di;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;

public class Sonata extends Object {
	Logger logger = Logger.getLogger(Sonata.class);
	String carColor = null;
	int speed = 0;
	int wheelNum = 0;
	public void init() {
		System.out.println("init호출 성공");
	}
	public Sonata() {
		logger.info("Sonata 디폴트 생성자 호출");
	}
	
	// 문법적인 문제는 해결했지만 호출(URL-웹)은 불가하다.
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
		Logger logger = Logger.getLogger("handleRequestInternal 호출 성공");
		ModelAndView mav = new ModelAndView();
		// -> /di/hello.sp 이 요청에 대한 응답페이지 이름
		// -> /WEB-INF/views/di/hello.jsp
		mav.setViewName("hello");
		return mav;
	}

	public Sonata(String carColor, int speed) {
		this.carColor = carColor;
		this.speed = speed;
	}
	public Sonata(String carColor, int speed, int wheelNum) {
		this.carColor = carColor;
		this.speed = speed;
		this.wheelNum = wheelNum;
	}
	/*
	public String toString() {
		return "그녀의 자동차는 "+this.carColor
			  +"이고, 현재 속도는 "+this.speed
			  +" 바퀴수는 "+this.wheelNum;
	}
	*/
}
