package com.example.demo.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.logic.MemberLogic;

@Controller
@RequestMapping("/member/*")
public class MemberController {
	Logger logger = LoggerFactory.getLogger(MemberController.class);	
	@Autowired(required=false)
	private MemberLogic memberLogic = null;
	@GetMapping("memberInsert")
	public String memberInsert(@RequestParam Map<String,Object> pMap) {
		logger.info("memberInsert호출 성공 : "+pMap);
		int result = 0;
		result = memberLogic.memberInsert(pMap);
		return "redirect:/auth/index.jsp";
	}
}
