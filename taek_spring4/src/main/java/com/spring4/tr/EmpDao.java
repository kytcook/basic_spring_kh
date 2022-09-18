package com.spring4.tr;

import java.util.Map;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;

public class EmpDao {
	Logger logger = Logger.getLogger(EmpDao.class);
	private SqlSessionTemplate sqlSessionTemplate = null;
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}
	public void empInsert(Map<String, Object> emap) {
		logger.info(emap);
		sqlSessionTemplate.update("empInsert", emap);
	}
	
}
