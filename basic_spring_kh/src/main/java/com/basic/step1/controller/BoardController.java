package com.basic.step1.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.basic.step1.logic.BoardLogic;
import com.util.HashMapBinder;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	Logger logger = LoggerFactory.getLogger(BoardController.class);
	@Autowired(required = false)
	private BoardLogic boardLogic = null;

	/*
	 * Board3Controller.boardList 에서 발췌 / dev_web과 basic 비용 계산 해보기
	 * Map선언만함 - @RequestParam
	 * - @RequestParam HashMapBinder가 필요없어짐
	 * ModelAndView도 필요없음 - Model
	 * 리턴타입 : ModelAndView -> String
	 * 
	 */
	@GetMapping("boardDelete.sp4")
	public Object boardDelete(@RequestParam Map<String, Object> pMap) {
		logger.info("boardDelete 호출 성공");
		int result = 0;
		result = boardLogic.boardDelete(pMap);
		String path = "redirect:boardList.sp4 ";
		return "redirect:boardList.sp4";
	}
	@GetMapping("boardUpdate.sp4")
	public Object boardUpdate(@RequestParam Map<String, Object> pMap) {
		logger.info("boardUpdate 호출 성공");
		int result = 0;
		result = boardLogic.boardUpdate(pMap);
		// jsp-> action(update) -> action(select) --(forward)--> boardList.jsp
		String path = "redirect:boardList.sp4";
		return path;
	}	
	@GetMapping("boardDetail.sp4")
	public String boardDetail(Model model, @RequestParam Map<String, Object> pMap) {
		logger.info("boardList 호출 성공");
		List<Map<String, Object>> boardList = null;
		boardList = boardLogic.boardDetail(pMap);
		model.addAttribute("boardList", boardList);
		return "forward:read.jsp";
	}
	@GetMapping("boardList.sp4")
	public String boardList(Model model, @RequestParam Map<String, Object> pMap) {
		logger.info("boardList 호출 성공");
		List<Map<String, Object>> boardList = null;
		// 여기여기....필요할 때 인스턴스화 해서 -> 게으른 인스턴스화 - 스프링에서 대단히 중요한 위치의 문제.
//		boardLogic = new Board3Logic(); // 전변인데 주소번지는 다르다..
		boardList = boardLogic.boardList(pMap);
		model.addAttribute("boardList", boardList);
		return "forward:boardList.jsp";
	}

	@GetMapping("boardInsert.sp4")
	public Object boardInsert(@RequestParam Map<String, Object> pMap, @RequestParam(value="bs_file", required=false) MultipartFile bs_file) {
		logger.info("boardInsert 호출 성공 : " + pMap);
		int result = 0;
		result = boardLogic.boardInsert(pMap);
		return "redirect:boardList.sp4";
	}
	
//	@GetMapping("boardInsert.sp4")
	@PostMapping("boardInsert.sp4")
	public String boardInsert(MultipartHttpServletRequest mpRequest, @RequestParam(value="bs_file", required=false) MultipartFile bs_file) {
		logger.info("boardInsert 호출 성공");
		int result = 0;
		Map<String,Object> pMap = new HashMap<>();
		HashMapBinder hmb = new HashMapBinder(mpRequest);
		hmb.mbind(pMap);
		if(!bs_file.isEmpty()) {
			String filename = HangulConversion.toKor(bs_file.getOriginalFilename())
			String savePath = "D:\\workspace_spring\\basic\\src\\main\\webapp\\pds";
			String fullPath = savePath+"\\"+filename;
			try {
				File file = new File(fullPath);
				byte[] bytes = bs_file.getBytes();
				BufferedOutputStream bos = 
						new BufferedOutputStream(
								new FileOutputStream(file));
				bos.write(bytes);
				bos.close();
				long size = file.length();
				double d_size = Math.floor(size/1024.0);//kb
				logger.info("size:"+d_size);
				pMap.put("bs_file", filename);
				pMap.put("bs_size", d_size);
			} catch (Exception e) {
				e.printStackTrace();
						
			}
		}
		
		result = boardLogic.boardInsert(pMap);
		return "redirect:boardList.sp4";
	}
}
