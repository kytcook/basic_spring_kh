package com.example.demo.logic;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.MemoDao;

@Service
public class MemoLogic {
	Logger logger = LoggerFactory.getLogger(MemoLogic.class);
	@Autowired(required=false)
	private MemoDao memoDao = null;

	public int memoInsert(Map<String, Object> pMap) {
		int result = 0;
		result = memoDao.memoinsert(pMap);
		return result;
	}

	public List<Map<String, Object>> sendMemoList(Map<String, Object> pMap) {
		List<Map<String, Object>> sendMemoList = null;
		sendMemoList = memoDao.sendMemoList(pMap);
		return sendMemoList;
	}

	public List<Map<String, Object>> receiveMemoList(Map<String, Object> pMap) {
		List<Map<String, Object>> receiveMemoList = null;
		receiveMemoList = memoDao.receiveMemoList(pMap);
		return receiveMemoList;
	}
	
}
