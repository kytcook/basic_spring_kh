package com.spring4.mvc;

import org.apache.log4j.Logger;

import com.vo.MemberVO;

public class AuthLogic {
	Logger logger = Logger.getLogger(AuthLogic.class);
	// AuthLogic 클래스는 AuthDao클래스와 의존관계가 있다
	private AuthDao authDao = null;
	public void setAuthDao(AuthDao authDao) {
		this.authDao = authDao;
	}
	public MemberVO login() {
		logger.info("login 호출 성공");
		MemberVO mVO = null;
		mVO = authDao.login();
		return mVO;
	}
	
}
