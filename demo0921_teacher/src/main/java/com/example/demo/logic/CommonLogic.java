package com.example.demo.logic;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.CommonDao;


@Service
public class CommonLogic {
	Logger logger = LogManager.getLogger(CommonLogic.class);
	@Autowired
	private CommonDao commonDao = null;
	public List<Map<String, Object>> zipcodeList(String dong) {
		List<Map<String,Object>> zipList = null;
		zipList = commonDao.zipcodeList(dong);
		return zipList;
	}
}
