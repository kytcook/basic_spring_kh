package com.example.demo;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.example.demo.controller.TestController;

import config.ControllerConfig;
import config.ControllerConfig2;

public class MainForSpring {

	public static void main(String[] args) {
		ApplicationContext ctx = 
				new AnnotationConfigApplicationContext(ControllerConfig.class, ControllerConfig2.class);
		TestController testController =
				ctx.getBean("testController", TestController.class);
		  
		testController.testList();
	}

}
