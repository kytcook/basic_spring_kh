package com.basic.step1;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
// con.mvc.step3의 AuthController와 비교해보세요.
@Controller
public class AuthController {// 스크립트 안해도 되고, if문 깔때기 안해도 되고 등등등
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public Object clogin(HttpServletRequest req, HttpServletResponse res) {
		System.out.println("login 호출 성공");
		String path = "redirect:index.jsp";
		return path;
	}
}
