package com.basic.step1.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class TestDao {
	Logger logger = LoggerFactory.getLogger(TestDao.class);
	@Autowired(required=false)
	private SqlSessionTemplate sqlSessionTemplate = null;

	public List<Map<String, Object>> testList(Map<String, Object> pmap) {
		logger.info("testList 호출 성공");
		List<Map<String, Object>> testList = null;
		testList = sqlSessionTemplate.selectList("testList", pmap);
		return testList;
	}

	public void testDeleteAll(String[] atestnos) {
		logger.info("testDeleteAll 호출 성공");
		List<String> list = new ArrayList<>();
		for(int i=0;i<atestnos.length;i++) {
			list.add(i, atestnos[i]);
		}
		sqlSessionTemplate.delete("testDeleteAll", atestnos);
	}

	public void testInsertAll() {
		logger.info("testInsertAll 호출 성공");
		List<Map<String,Object>> list = new ArrayList<>();
		Map<String,Object> pMap = new HashMap<>();
		pMap.put("test_no", 10);
		pMap.put("test_title", "다중테스트1");
		pMap.put("test_content", "멀티추가1");
		list.add(pMap);
		pMap = new HashMap<>();
		pMap.put("test_no", 20);
		pMap.put("test_title", "다중테스트2");
		pMap.put("test_content", "멀티추가2");
		list.add(pMap);
		pMap = new HashMap<>();
		pMap.put("test_no", 30);
		pMap.put("test_title", "다중테스트3");
		pMap.put("test_content", "멀티추가3");
		list.add(pMap);
		sqlSessionTemplate.update("testInsertAll", list);
	}
}
