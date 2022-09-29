package com.basic.step1.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.vo.Board;

// @Repository 지원 배경은 외부의 리소스를 객체주입 받아서 처리하는 경우
// 인터페이스방식이나 @Select * from 테이블
@Repository
public class Board2Dao {
	Logger logger = LoggerFactory.getLogger(Board2Dao.class);
	protected static final String NAMESPACE = "com.basic.step1.";
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate = null;

	public Board boardDetail(Map<String, Object> pMap) {
		logger.info("boardList 호출 성공");
		Board board = null;
		try {
			board = sqlSessionTemplate.selectOne(NAMESPACE+"boardDetail", pMap);
			// insert here
			if(board !=null) logger.info(board.getTitle());
		} catch (DataAccessException e) {
			logger.info("Exception : "+e.toString());
		} 
		return board;
	}
}
