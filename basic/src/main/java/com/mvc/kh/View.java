package com.mvc.kh;
// ApplicationContext- 이른인스턴스화 
// BeanFactory - 게으른 인스턴스화
public class View {
	Service service = null;
	public View() {
	}
	public View(Service service) {
		this.service = service;
	}	
	public void methodA() {
		System.out.println(service);
		//생성자 선택의 문제
		//호출 위치의 문제
		//500번의 문제를 피할 수 있도록 관리를 받자 - spring framework
		//DI
		service.methodB();//생성자의 선택에 따라 NullPointerException발생 할 수 있다.
	}
}
