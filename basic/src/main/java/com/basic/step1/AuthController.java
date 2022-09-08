package com.basic.step1;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.vo.MemberVO;
// 어노테이션 - 객체주입하는 방법에 사용
@Controller
public class AuthController {
	Logger logger = LoggerFactory.getLogger(AuthController.class);
	@Autowired
	private AuthLogic authLogic = null;
	@RequestMapping(value = "/login.sp4", method = RequestMethod.GET)
	public String login(HttpServletRequest req, HttpServletResponse res) {
		logger.info("login 호출 성공");
		MemberVO mVO = authLogic.login();
		String path = "redirect:index.jsp";
		return path;
	}
}
