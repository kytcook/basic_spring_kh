package com.spring4.tr;

import java.util.Map;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;

public class DeptDao {
	Logger logger = Logger.getLogger(DeptDao.class);
	private SqlSessionTemplate sqlSessionTemplate = null;
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}
	public int deptInsert(Map<String, Object> pMap) {
		logger.info(pMap);
		int result = 0;
		result = sqlSessionTemplate.update("deptInsert", pMap);
		return result;
	}
}
