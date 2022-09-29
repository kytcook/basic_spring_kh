package com.example.demo.logic;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.BookDao;

@Service
public class BookLogic {
	Logger logger = LoggerFactory.getLogger(BookLogic.class);
	@Autowired
	private BookDao bookDao = null;
	public List<Map<String, Object>> bookList(Map<String, Object> pMap) {
		List<Map<String,Object>> bookList = null;
		bookList = bookDao.bookList(pMap);
		return bookList;
	}
	 
}
