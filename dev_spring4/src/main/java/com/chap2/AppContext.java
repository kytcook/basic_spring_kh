package com.chap2;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
// 스프링 컨테이너가 관리를 하는 클래스 임
// 객체주입을 위한 사전 조치, 추가해야 할 코드
@Configuration
public class AppContext {
	//메소드 이름 앞에 @Bean 어노테이션을 붙이면 메소드이름이 빈네임이 되는 것이다.
	// XXX.getBean(빈네임);
	//빈생성 객체를 인스턴스화 하면서 @Bean이 정의된 클래스를 생성자의 파라미터로 
	//추가하는 것 만으로도 @Bean이 붙은 메소드를 호출할 수 있다.
	//@Configuration 과 @Bean은 직접적인 의존관계는 아님
	@Bean
	public DeptVO getDeptVO() {
		DeptVO dVO = new DeptVO();
		dVO.setDeptno(10);
		dVO.setDname("총무부");
		dVO.setLoc("대전");
		return dVO;
	}
}
