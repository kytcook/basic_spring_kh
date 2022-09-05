package com.spring4.mvc;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
// ApplicationContext 대 BeanFactory -> 컨테이너의 종류
// 빈을 관기해준다.
// 이른 인스턴스화, 게으른 인스턴스화
// 빈의 정의는 xml문서에서 한다.(선언)
public class SonataSimulation {
	// 게으른 인스턴스화 - 시점
//	Sonata myCar = null;// 언제 초기화가 되나?
	
	// 이른 인스턴스화
//	Sonata herCar = new Sonata();
	void methodA() {
//		System.out.println(myCar.spped);
//		myCar = new Sonata();
//		System.out.println(herCar.speed);
	}
	public static void main(String[] args) {
		SonataSimulation ss = new SonataSimulation();
		/*
		 * id는 인스턴스변수명으로 생각하자 선언은 xml문서에서 선언된 클래스 정보를 얻어와서 자바코드에 쓸 수 있도록 제공하는 클랙스가 있다. 
		 */
		ss.methodA();
		ApplicationContext context 
		= new ClassPathXmlApplicationContext("com\\spring4\\mvc\\sonataBean.xml");
		Sonata myCar = (Sonata)context.getBean("myCar");
		Sonata herCar = (Sonata)context.getBean("herCar");//인스턴스화
		// 어 그런데 생성자가 여러개 이자나??
		// 이런 경우 그 중에 누가 호출되나요??
		System.out.println(herCar.speed);// 0
		System.out.println(herCar.carName);// null
		System.out.println(herCar.carColor);// null
		System.out.println(myCar);
		System.out.println(myCar.speed);
		System.out.println(myCar.carName);
		System.out.println("객체관리 책임이 개발자에게 있는 경우.");
		myCar = new Sonata();
		System.out.println(myCar);
		System.out.println(myCar.speed);
		System.out.println(myCar.carName);
		myCar = null;//30번에서 31번으로 갈 때 Candidate상태에 빠진다.
		// 26번에 생성된 객체는 쓰레기값으로 인식되어 자원을 회수당한다.
		// 
		myCar = new Sonata();
		System.out.println("null 초기화 후에 비교");
		System.out.println(myCar.speed);
		System.out.println(myCar.carName);
		
	}
}
