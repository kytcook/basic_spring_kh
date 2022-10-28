package com.example.demo.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.logic.MemberLogic;

@Controller
public class MemberController {
	Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	private MemberLogic memberLogic = null;
	
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder = null;
	
	@GetMapping("/memberInsert")
	public String memberInsert(@RequestParam Map<String,Object> pMap) {
		logger.info("memberInsert호출");
		int result = 0;
		pMap.put("role","ROLE_USER");
		String originalPW = pMap.get("password").toString();
		String encPW = bCryptPasswordEncoder.encode(originalPW);
		pMap.put("password", encPW);
		result = memberLogic.memberInsert(pMap);
		return "redirect:/loginForm.jsp";
	}
}
