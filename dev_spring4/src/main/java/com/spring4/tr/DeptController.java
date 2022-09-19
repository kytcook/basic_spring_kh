package com.spring4.tr;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.spring4.mvc.AuthController;

public class DeptController extends MultiActionController {
	Logger logger = Logger.getLogger(DeptController.class);
	private DeptLogic deptLogic = null;
	public void setDeptLogic(DeptLogic deptLogic) {
		this.deptLogic = deptLogic;
	}
	public String deptInsert(@RequestParam Map<String,Object> pMap) {
		int result = 0;
		result = deptLogic.deptInsert(pMap);
		return "redirect:deptList.sp";
	}
}
