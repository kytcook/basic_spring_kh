package com.mvc.kh;

public class DiTest {
	Service service = new Service();
	View view = new View();
	//View view = new View(service);
	public void testRun() {
		view.methodA();
	}
	
	public static void main(String[] args) {
		DiTest dt = new DiTest();
		dt.testRun();
	}

}
