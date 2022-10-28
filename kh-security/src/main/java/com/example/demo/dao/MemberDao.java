package com.example.demo.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberDao {
	Logger logger = LoggerFactory.getLogger(MemberDao.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate = null;
	
	public int memberInsert(Map<String, Object> pMap) {
		int result = 0;
		result = sqlSessionTemplate.update("memberInsert", pMap);
		return result;
	}
}
