package com.basic.step1.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.basic.step1.logic.BoardLogic;
import com.util.HangulConversion;
import com.util.HashMapBinder;
import com.vo.BoardMasterVO;
import com.vo.MemberVO;

@Controller
@RequestMapping(value="/board/*")
public class BoardController {
	@Autowired
	private BoardLogic boardLogic = null;
	private Logger logger = LoggerFactory.getLogger(BoardController.class);	
	private final String filePath = "C:\\kh_git2022\\dev_java20220415\\basic\\src\\main\\webapp\\pds\\"; // 파일이 저장될 위치
	
	/*
	 * dev_web과 basic 비용 계산 해보기
	 * Map선언만함 - @RequestParam
	 * HashMapBinder가 필요없어짐
	 * ModelAndView도 필요없음 - Model
	 * 리턴타입 : ModelAndView -> String
	 */
	@GetMapping("boardDelete.sp4")
	public Object boardDelete(@RequestParam Map<String,Object> pMap) {
		logger.info("boardDelete 호출 성공");
		int result = 0;
		result = boardLogic.boardDelete(pMap);
		return "redirect:boardList.sp4";
	}
	@GetMapping("boardUpdate.sp4")
	public Object boardUpdate(@RequestParam Map<String,Object> pMap) {
		logger.info("boardUpdate 호출 성공");
		int result = 0;
		result = boardLogic.boardUpdate(pMap);
		// jsp-> action(update) -> action(select) --(forward)--> boardList.jsp
		String path = "redirect:boardList.sp4";
		return path;
	}
	@GetMapping("boardDetail.sp4")
	public String boardDetail(Model model, @RequestParam Map<String,Object> pMap) {
		logger.info("boardDetail 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = boardLogic.boardDetail(pMap);
		model.addAttribute("boardList",boardList);
		return "forward:read.jsp";
	}	
	@GetMapping("boardList.sp4")
	public String boardList(Model model, @RequestParam Map<String,Object> pMap) {
		logger.info("boardList 호출 성공");
		List<Map<String,Object>> boardList = null;
		//여기 여기....필요할 때 인스턴스화 해서 호출한다 - 게으른 인스턴스화 - 스프링 위치
		//boardLogic = new Board3Logic();//주소번지 다르다
		boardList = boardLogic.boardList(pMap);
		model.addAttribute("boardList",boardList);
		return "forward:boardList.jsp";
	}	
	//@GetMapping("boardInsert.sp4")
	@PostMapping("boardInsert.sp4")
	public String boardInsert(MultipartHttpServletRequest mpRequest, @RequestParam(value="bs_file", required=false) MultipartFile bs_file) {
		logger.info("boardInsert 호출 성공");
		int result = 0;
		Map<String,Object> pMap = new HashMap<>();
		HashMapBinder hmb = new HashMapBinder(mpRequest);
		hmb.mbind(pMap);
		logger.info(pMap.toString());
		if(!bs_file.isEmpty()) {//
			String filename = HangulConversion.toKor(bs_file.getOriginalFilename());
			String savePath = "C:\\kh_git2022\\dev_java20220415\\basic\\src\\main\\webapp\\pds";
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
