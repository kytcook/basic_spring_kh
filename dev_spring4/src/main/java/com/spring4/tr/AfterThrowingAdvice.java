package com.spring4.tr;

public class AfterThrowingAdvice {
	public AfterThrowingAdvice() {}
	public void exceptionMsg() {
		System.out.println("[예외 처리] 비즈니스 로직 수행 중 예외 발생하였습니다.");
	}
}
