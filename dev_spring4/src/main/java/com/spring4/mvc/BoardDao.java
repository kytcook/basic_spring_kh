package com.spring4.mvc;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;


public class BoardDao {

	Logger logger = Logger.getLogger(BoardDao.class);	
	private SqlSessionTemplate sqlSessionTemplate = null;
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}

	public List<Map<String, Object>> boardList(Map<String, Object> pMap) {
		logger.info("boardList 호출 성공");
		List<Map<String, Object>> boardList = null;
		try {
			boardList = sqlSessionTemplate.selectList("boardList", pMap);
			// insert here
			//logger.info(boardList.toString());
		} catch (DataAccessException e) {
			logger.info("Exception : "+e.toString());
		} 
		return boardList;
	}

	public int getBNo() {
		logger.info("getBNo 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.selectOne("getBNo");
			// insert here
			logger.info(result+"");
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		} 
		return result;
	}

	public void bStepUpdate(Map<String, Object> pMap) {
		logger.info("bStepUpdate 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.update("bStepUpdate",pMap);
			logger.info("result : "+result);
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		} 	
	}

	public int getBGroup() {
		logger.info("getBGroup 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.selectOne("getBGroup");
			// insert here
			logger.info(result+"");
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		} 
		return result;
	}

	public int boardMInsert(Map<String, Object> pMap) {
		logger.info("boardMInsert 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.update("boardMInsert",pMap);
			logger.info("result : "+result);
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		} 	
		return result;
	}

	public int boardMUpdate(Map<String, Object> pMap) {
		logger.info("boardMUpdate 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.update("boardMUpdate",pMap);
			logger.info("result : "+result);
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		} 	
		return result;
	}

	public int boardMDelete(Map<String, Object> pMap) {
		logger.info("boardMDelete 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.delete("boardMDelete",pMap);
			logger.info("result : "+result);
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		}	
		return result;
	}

	public int hitCount(Map<String, Object> pMap) {
		logger.info("hitCount 호출 성공");
		int result = 0;
		try {
			//result = sqlSessionTemplate.update("hitCount",pMap);
			logger.info("result : "+result);
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		}	
		return result;
	}

	public int boardSInsert(Map<String, Object> pMap) {
		logger.info("boardSInsert 호출 성공");
		int result = 0;
		try {
			//현재는 첨부파일이 한개인 경우라서 상수처리함
			//TODO - 멀티처리를 위해서는 무엇을 해야 할까?
			pMap.put("bs_seq", 1);
			//result = sqlSessionTemplate.update("boardSInsert",pMap);
			logger.info("result : "+result);
		} catch (Exception e) {
			logger.info("Exception : "+e.toString());
		} 	
		return result;
	}
	
}
