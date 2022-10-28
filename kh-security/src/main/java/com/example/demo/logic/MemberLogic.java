package com.example.demo.logic;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.example.demo.dao.MemberDao;

public class MemberLogic {
	Logger logger = LoggerFactory.getLogger(MemberLogic.class);
	
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder = null;
	
	@Autowired
	private MemberDao memberDao = null;
	
	public int memberInsert(Map<String, Object> pMap) {
		int result = 0;
		pMap.put("role","ROLE_USER");
		String originalPW = pMap.get("password").toString();
		String encPW = bCryptPasswordEncoder.encode(originalPW);
		pMap.put("password", encPW);
		result = memberDao.memberInsert(pMap);
		return result;
	}
}
