package com.di;

import java.io.FileInputStream;

import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.InputStreamResource;
/*
 * spring-core.jar -> XXX.class -> main()있나?
 * 스프링 컨테이너 종류 2가지
 * spring-context.jar -  ApplicationContext
 * spring-beans.jar -  BeanFactory
 * 생성해야 하는 클래스명 결정은 누가?
 */
public class SonataSimulation {

	public static void main(String[] args) throws Exception {
		//객체 생성
		//개발자가 라이프 사이클 관리하기 - 왜냐하면 직접 new를 사용해서 인스턴스화를 함
		//스프링으로 부터 빈(bean:클래스임)을 관리받지 않는 코드임
		//스프링으로 객체의 라이프사이클을 관리 받으려면 xml문서에 등록하거나
		// 최근에는 어노테이션을 지원하고 있습니다. - spring boot
		// 어노테이션은 자바 코드에 작성하고
		// 그렇지 않은 경우이거나 이종간의 주입에 대해서는 xml로 처리할 수 있다.
		// 이종간 언어에는 myBatis와 오라클
		// 누가 연계에 필요한 자바 코드를 지원해야 하는 걸까요?
		// myBatis와 오라클 쪽에서 지원해야 하나?
		// 자신들의 속내용이나 코드가 노출되지 않도록...
		// myBatis는 프레임워크 인가? 아님 라이브러리인가?
		Sonata yourCar = new Sonata();//여기의 주소번지와
		System.out.println(yourCar);
		//객체 소멸
		yourCar = null;//candidate상태로 전환되는코드임. null로 초기화 한 후
		yourCar = new Sonata();//다시 인스턴스화 - 새로 주소번지 채번이 된다
		System.out.println(yourCar);
		// yourCar == yourCar => false
		ApplicationContext context = 
				new ClassPathXmlApplicationContext("com\\di\\sonataBean.xml");
		//scope를 생략한 경우임
		//<bean id="myCar" class="com.di.Sonata"/>
		Sonata myCar = (Sonata)context.getBean("myCar");
		System.out.println(myCar);
		myCar = null;//역할이 없다????? 왜지??
		myCar = (Sonata)context.getBean("myCar");
		System.out.println(myCar);
		
		Sonata myCar2 = (Sonata)context.getBean("myCar");
		System.out.println(myCar == myCar2);//t:싱글톤
		//scope를 prototyp으로 한 경우임
		Sonata himCar = (Sonata)context.getBean("himCar");
		Sonata himCar2 = (Sonata)context.getBean("himCar");	
		System.out.println(himCar == himCar2);//f:prototype
		BeanFactory factory = 
				new XmlBeanFactory(new ClassPathResource("com\\di\\sonataBean.xml"));
		Sonata meCar = (Sonata)factory.getBean("myCar");
		System.out.println(myCar == meCar);//f
	}

}
