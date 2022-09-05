package com.spring4.mvc;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class HelloController extends AbstractController {
	Logger logger = Logger.getLogger(HelloController.class);
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
		Logger logger = Logger.getLogger("handleRequestInternal 호출 성공");
		ModelAndView mav = new ModelAndView();
		// -> /di/hello.sp 이 요청에 대한 응답페이지 이름
		// -> /WEB-INF/views/di/hello.jsp
		mav.setViewName("hello");
		return mav;
	}

}
