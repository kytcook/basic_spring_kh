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
	// spring에서 제공하는 SQLException대신 사용하는 클래스
	// 예외가 발생했을 때, 여기서 직접 처리하지 않고 나를 호출한 곳에서 처리해주세요~
	public void empInsert(Map<String, Object> emap) throws DataAccessException {
		logger.info(emap);
		sqlSessionTemplate.update("empInsert", emap);
	}
	
}
