package com.spring4.mvc;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class AuthController extends MultiActionController {
	Logger logger = Logger.getLogger(AuthController.class);
	public String login(HttpServletRequest req, HttpServletResponse res) {
		System.out.println("dev_spring4 login 호출 성공");
		logger.info("dev_spring4 login 호출 성공");
		String path = "redirect:index.jsp";
		return path;
	}
}
