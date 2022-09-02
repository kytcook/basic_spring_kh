package com.spring4.mvc;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class AuthController extends MultiActionController {
	public Object clogin(HttpServletRequest req, HttpServletResponse res) {
		System.out.println("dev_spring4 login 호출 성공");
		String path = "redirect:index.jsp";
		return path;
	}
}
