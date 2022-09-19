package com.spring4.tr;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
	//@Transactional(propagation=Propagation.REQUIRES_NEW, rollbackFor= {DataAccessException.class})
	//public int doEmp() {//한번에 커밋하시오.
	public int cudEmp() {//건건이 커밋해라..
		logger.info("doEmp 호출");
		Map<String,Object> emap = new HashMap<>();
		emap.put("empno", 9005);
		emap.put("ename", "김유신");
		emap.put("deptno", 89);
		try {
			Map<String,Object> dmap = new HashMap<>();
			dmap.put("deptno",89);
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
