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
import org.springframework.stereotype.Service;

import com.kh.test.board.model.vo.Board;
import com.vo.BoardMasterVO;

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
