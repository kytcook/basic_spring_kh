package com.spring4.tr;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class EmpController extends MultiActionController {
	Logger logger = Logger.getLogger(EmpController.class);
	private EmpLogic empLogic = null;
	public void setEmpLogic(EmpLogic empLogic) {
		this.empLogic = empLogic;
	}

	public String doEmp() {
		int result = 0;
		result = empLogic.doEmp();
		return "redirect:deptList.sp";
	}
	
}