package com.spring4.tr;

import java.util.Map;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.dao.DataAccessException;

public class EmpDao {
	Logger logger = Logger.getLogger(EmpDao.class);
	private SqlSessionTemplate sqlSessionTemplate = null;
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}
	//spring에서 제공하는 SQLException 대신 사용하는 클래스
	public void empInsert(Map<String, Object> emap) throws DataAccessException {
		logger.info(emap);
		sqlSessionTemplate.update("empInsert", emap);
	}
}
