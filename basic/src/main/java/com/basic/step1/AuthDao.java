package com.basic.step1;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.vo.MemberVO;
// DAO뒤에서는 오라클서버와 연동하기
// myBatis 레이어대한 설정 필요함.
@Service
public class AuthDao {
	// SqlSessionTemplate는 mybatis-spring.jar에서 제공하는 클래스로
	// SqlSession의 역할임
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate = null;
	
	public MemberVO login() {
		//logger.info("login 호출 성공");
		MemberVO memVO = null;
		Map<String,Object> pMap = new HashMap<>();
		pMap.put("mem_id", "tomato");
		pMap.put("mem_pw", "123");
		// selectOne(One은 Object이다.-오직 1건)은 조회건 수가 반드시 한건이어야 한다.
		// Too Many....
		// 혹시 아래부분에 컴파일 에러이면 ibatis관련 모듈 의존관계에 있어서
		// mybatis-3.5.10.jar도 빌드패스에 추가할것 mybatis-spring-1.3.3의존관계
		memVO = sqlSessionTemplate.selectOne("login", pMap);
		if(memVO!=null) {
			//logger.info(memVO.getMem_name());			
		}
		return memVO;
	}
}
