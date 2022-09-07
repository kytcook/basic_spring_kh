package com.chap2;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.di.Sonata;

public class Main {
	
	public static void main(String[] args) {
	AnnotationConfigApplicationContext ctx 
		= new AnnotationConfigApplicationContext(AppContext.class);
	DeptVO dVO = ctx.getBean("getDeptVO", DeptVO.class);
	int deptno = dVO.getDeptno();
	String dname = dVO.getDname();
	String loc = dVO.getLoc();
	System.out.println(deptno+", "+dname+", "+loc);
	ctx.close();
	}
	
}
