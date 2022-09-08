package com.di;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class HelloMain {

	public static void main(String[] args) {
		ApplicationContext context = 
				new ClassPathXmlApplicationContext("com\\di\\helloBean.xml");
		HelloBean helloBean = (HelloBean)context.getBean("helloBean");
		System.out.println(helloBean.getGreeting("잘 지내?"));
	}

}
