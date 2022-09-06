package com.vo;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Main {

	public static void main(String[] args) {
		AnnotationConfigApplicationContext ctx = 
				new AnnotationConfigApplicationContext(AppContext.class);
		DeptVO dVO = ctx.getBean("getDeptVO", DeptVO.class);
		int deptno = dVO.getDeptno();
		System.out.println(deptno);

	}

}
