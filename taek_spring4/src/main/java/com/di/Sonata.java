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
