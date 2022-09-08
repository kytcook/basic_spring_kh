package com.di;

public class Sonata {
	String carColor = null;
	int speed = 0;
	int wheelNum = 0;
	public void init() {
		System.out.println("init호출 성공");
	}
	public Sonata() {
		
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
