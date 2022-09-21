package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.vo.DeptVO;


@Service
public class DeptDao {
	Logger logger = LogManager.getLogger(DeptDao.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate = null;
	public List<DeptVO> deptList(Map<String, Object> pMap) {
		logger.info(pMap.get("deptno"));
		List<DeptVO> deptList = null;
		sqlSessionTemplate.selectOne("deptList",pMap);
		logger.info("pMap : "+pMap);
		deptList = (List<DeptVO>)pMap.get("key");
		for(int i=0;i<deptList.size();i++) {
			DeptVO dvo = deptList.get(i);
			logger.info(dvo.getDeptno());
		}
		return deptList;
	}
	
}
