package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
//@Repository로 정하면 인터페이스 코드전개 - sql 문도 어노테이션 사용하게됨
@Service
public class CommonDao {
	Logger logger = LogManager.getLogger(CommonDao.class);
	@Autowired(required=false)
	private SqlSessionTemplate sqlSessionTemplate = null;
	public List<Map<String, Object>> zipcodeList(String dong) {
		logger.info("zipcodeList 호출 성공 : "+dong);
		List<Map<String, Object>> zipList = null;
		Map<String, Object> pMap = new HashMap<>();
		pMap.put("dong", dong);
		try {
			sqlSessionTemplate.selectOne("proc_zipcode", pMap);
			zipList = (List<Map<String, Object>>)pMap.get("key");
			// insert here
			logger.info(zipList.toString());
		} catch (DataAccessException e) {
			logger.info("Exception : "+e.toString());
		} 
		return zipList;
	}
}
