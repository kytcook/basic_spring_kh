package com.vo;

public class TestMain {
	public static void main(String args[]) {
		TestVO tvo = new TestVO();
		tvo.setTest_no(2);
		tvo.setTest_title("글제목");
		tvo.setTest_content("글내용");
		System.out.println(tvo.getTest_content());
	}
}
