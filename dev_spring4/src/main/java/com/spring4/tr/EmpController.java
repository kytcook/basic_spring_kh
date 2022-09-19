package com.spring4.tr;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class EmpController extends MultiActionController {
	Logger logger = Logger.getLogger(EmpController.class);
	private EmpLogic empLogic = null;
	public void setEmpLogic(EmpLogic empLogic) {
		this.empLogic = empLogic;
	}

	public String doEmp(HttpServletRequest req, HttpServletResponse res) {
		int result = 0;
		result = empLogic.cudEmp();
		return "redirect:empList.sp";
	}

}
