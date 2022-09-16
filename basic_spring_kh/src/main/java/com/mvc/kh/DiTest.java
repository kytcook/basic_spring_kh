package com.mvc.kh;

public class DiTest {
	Service service = new Service();
//	View view = new View(); // Service쪽에서 NullPoniterException 을 발생시킨다.
	View view = new View(service);
	
	public void testRun() {
		view.methodA();
	}
	
	public static void main(String[] args) {
		DiTest dt = new DiTest();
		dt.testRun();
		
	}

}
