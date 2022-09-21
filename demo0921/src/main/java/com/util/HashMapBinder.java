package com.util;

import java.io.File;
import java.util.Enumeration;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public class HashMapBinder {
	Logger logger = LogManager.getLogger(HashMapBinder.class);
	HttpServletRequest req = null;
	MultipartHttpServletRequest mreq = null;
	public HashMapBinder(MultipartHttpServletRequest mreq) {
		this.mreq = mreq;
	}
	public void mbind(Map<String, Object> pMap) {
		// 사용자가 입력한 값을 담을 맵이 외부 클래스에서 인스턴스화 되어 넘어오니까 초기화 처리 후 사용함
		logger.info(pMap);// pMap은 이 공통 코드를 사용하는 곳에서 주입됩니다
		pMap.clear(); // 초기화를 해줌
		// html화면에 정의된 input name값들을 모두 담아줌
		Enumeration<String> em = mreq.getParameterNames();
		while (em.hasMoreElements()) {
			// key값 꺼내기
			String key = em.nextElement(); // b_title, b_writer, b_content, b_pw 등
			pMap.put(key, HangulConversion.toUTF(mreq.getParameter(key)));
		} 
		logger.info("pMap ===> " + pMap);
	}////////// end of bind
}
