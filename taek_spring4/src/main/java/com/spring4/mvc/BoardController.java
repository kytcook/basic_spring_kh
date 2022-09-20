package com.spring4.mvc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.google.gson.Gson;
import com.util.HashMapBinder;

// 여기선 어노테이션 사용하지 않는다.
//req, res를 주입받기 위해서는 MultiActionController를 사용한다.
//@RestController
public class BoardController extends MultiActionController {
	Logger logger = Logger.getLogger(BoardController.class);

	private BoardLogic boardLogic = null;
	public void setBoardLogic(BoardLogic boardLogic) {
		this.boardLogic = boardLogic;
	}

	public String jsonBoardList(HttpServletRequest req, HttpServletResponse res) {
		logger.info("boardList호출 성공");
		Map<String,Object> pMap = new HashMap<>();//@RequestParam Map<String,Object> pMap
		List<Map<String,Object>> boardList = null;
		boardList = boardLogic.boardList(pMap);
//		model.addAttribute("boardList", boardList);// scope:request
		req.setAttribute("boardList", boardList);
		logger.info(boardList);
		return "forward:jsonBoardList.jsp";
	}
	
	public String boardList(HttpServletRequest req, HttpServletResponse res) {
		logger.info("boardList호출 성공");
		Map<String,Object> pMap = new HashMap<>();//@RequestParam Map<String,Object> pMap
		List<Map<String,Object>> boardList = null;
		boardList = boardLogic.boardList(pMap);
//		model.addAttribute("boardList", boardList);// scope:request
		req.setAttribute("boardList", boardList);
		logger.info(boardList);
		return "foward:boardList.jsp";
	}

	public String boardDetail(HttpServletRequest req, HttpServletResponse res) {
		logger.info("boardDetail호출 성공");
		Map<String,Object> pMap = new HashMap<>();
		HashMapBinder hmb = new HashMapBinder(req);
		hmb.bind(pMap);
		List<Map<String,Object>> boardList = null;
		boardLogic.boardDetail(pMap);
		boardList = boardLogic.boardDetail(pMap);
		req.setAttribute("boardList", boardList);
		return "foward:read.jsp";
	}

	public String boardInsert(HttpServletRequest req, HttpServletResponse res) {
		Map<String,Object> pMap = new HashMap<>();
		logger.info("boardInsert호출 성공 : "+pMap);
		HashMapBinder hmb = new HashMapBinder(req);
		hmb.bind(pMap);
		boardLogic.boardInsert(pMap);
		// redirect-forward, forward -> forward(에러)
		return "redirect:boardList.sp";
	}

	public String boardUpdate(HttpServletRequest req, HttpServletResponse res) {
		logger.info("boardUpdate호출 성공");
		Map<String,Object> pMap = new HashMap<>();
		boardLogic.boardUpdate(pMap);
		// redirect-forward, forward -> forward(에러)
		return "redirect:boardList.sp";
	}

	public String boardDelete(HttpServletRequest req, HttpServletResponse res) {
		logger.info("boardDelete호출 성공");
		Map<String,Object> pMap = new HashMap<>();
		boardLogic.boardDelete(pMap);
		// redirect-forward, forward -> forward(에러)
		return "redirect:boardList.sp";
	}

}
