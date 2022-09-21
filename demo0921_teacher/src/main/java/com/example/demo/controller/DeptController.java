package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.example.demo.logic.DeptLogic;
import com.example.demo.vo.DeptVO;

@Controller
@RequestMapping("/dept/*")
@SessionAttributes({"s_id","s_name"})
public class DeptController {
	Logger logger = LogManager.getLogger(DeptController.class);
	@Autowired
	private DeptLogic deptLogic = null;
	@GetMapping("deptList")
	public String deptList(Model model, @RequestParam Map<String,Object> pMap) {
		logger.info("deptList 호출 성공");
		List<DeptVO> deptList = null;
		pMap.put("deptno", 20);
		deptList = deptLogic.deptList(pMap);
		model.addAttribute("deptList", deptList);
		return "dept/deptList";
//		return "forward:deptList.jsp";
	}
	
}
