package com.spring4.tr;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;

public class EmpLogic {
	Logger logger = Logger.getLogger(EmpLogic.class);
	private DeptDao deptDao = null;
	public void setDeptDao(DeptDao deptDao) {
		this.deptDao = deptDao;
	}
	private EmpDao empDao = null;
	public void setEmpDao(EmpDao empDao) {
		this.empDao = empDao;
	}
	
	//@Transactional(propagation = propagation.REQUIRES_NEW, rollbackFor= {DataAccessExxception.class})
	public int doEmp() {
		logger.info("doEmp 호출");
		Map<String,Object> emap = new HashMap<>();
		emap.put("empno", 9003);
		emap.put("ename", "김유신");
		emap.put("deptno", 89);
		try {
			Map<String,Object> dmap = new HashMap<>();
			dmap.put("deptno", 89);
			dmap.put("dname", "개발부");
			dmap.put("loc", "부산");
			deptDao.deptInsert(dmap);
			empDao.empInsert(emap);
		} catch (DataAccessException de) {
			throw de;
		}
		return 0;
	}
}
