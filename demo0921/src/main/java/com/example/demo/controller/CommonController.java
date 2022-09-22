package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RestController
public class CommonController {
	
	@GetMapping("/zipcode/zipcodeList")
	public String zipcodeList() {
		Gson g = new Gson();
		String imsi = g.toJson(null);
		return imsi;
	}
}
