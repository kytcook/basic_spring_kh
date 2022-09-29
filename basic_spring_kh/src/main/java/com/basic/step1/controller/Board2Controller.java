package com.basic.step1.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.basic.step1.dao.Board2Dao;
import com.vo.Board;

@Controller
@RequestMapping("/board2/*")
public class Board2Controller {
	private Logger logger = LoggerFactory.getLogger(BoardController.class);
	@Autowired
	private Board2Dao board2Dao = null;
	//http://localhost:8000/step1/board2/selectBoard.sp4?bid=1
	@GetMapping("selectBoard.sp4")
	public String selectBoard(@RequestParam Map<String,Object> pMap, Model model) {
		logger.info("selectBoard 호출 성공");
		Board board = null;
		board = board2Dao.boardDetail(pMap);
		model.addAttribute("board", board);
		String path ="";
		if(1==1) {
			path = "forward:boardDetail.jsp";
		}
		else {
			path = "redirect:error.do";
		}
		return "forward:boardDetail.jsp";
	}///end selectBoard
	@GetMapping("error.sp4")
	public String error(){
		return "redirect:errorPage.jsp";
	}
}
