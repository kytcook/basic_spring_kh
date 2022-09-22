package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.logic.CommonLogic;
import com.google.gson.Gson;

@RestController
public class CommonController {
	Logger logger = LogManager.getLogger(CommonController.class);
	@Autowired(required=true)
	private CommonLogic commonLogic = null;
	@GetMapping("/zipcode/zipcodeList")
	public String zipcodeList(@RequestParam String dong) {
		logger.info("zipcodeList호출 성공: input ==> "+dong);
		List<Map<String,Object>> zipList = null;
		zipList = commonLogic.zipcodeList(dong);
		Gson g = new Gson();
		String imsi = g.toJson(zipList);
		return imsi;
	}
}
