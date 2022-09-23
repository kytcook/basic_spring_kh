package com.example.demo.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.example.demo.logic.BoardLogic;
import com.google.gson.Gson;
import com.util.HangulConversion;
import com.util.HashMapBinder;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	Logger logger = LoggerFactory.getLogger(BoardController.class);	
	@Autowired(required=false)
	private BoardLogic boardLogic = null;
	private final String filePath = "D:\\workspace_spring\\basic\\src\\main\\webapp\\pds\\"; // 파일이 저장될 위치
	@ResponseBody
	@GetMapping(value="helloworld", produces="text/plain;charset=UTF-8")
	public String helloWorld() {
	    return "한글처리";
	}
	@ResponseBody
	@GetMapping(value="jsonFormat", produces="application/json;charset=UTF-8")
	public String jsonFormat() {
		List<Map<String,Object>> names = new ArrayList<>();
		Map<String,Object> rmap = new HashMap<>();
		rmap.put("mem_id", "tomato");
		rmap.put("mem_name", "토마토");
		names.add(rmap);
		rmap = new HashMap<>();
		rmap.put("mem_id", "apple");
		rmap.put("mem_name", "사과");
		names.add(rmap);
		Gson g = new Gson();
		String temp = g.toJson(names);
		return temp;
	}
	//사이드 관전포인트 - 파라미터에 req, res가 없다
	@GetMapping("testParam")
	public String testParam(@RequestParam String mem_id) {
		logger.info("testParam 호출 성공"+mem_id);
		return "redirect:/test/testList.jsp";
	}	
	/*
	 * dev_web과 basic 비용 계산 해보기
	 * Map선언만함 - @RequestParam
	 * HashMapBinder가 필요없어짐
	 * ModelAndView도 필요없음 - Model
	 * 리턴타입 : ModelAndView -> String
	 */
	@GetMapping("boardDelete")
	public Object boardDelete(@RequestParam Map<String,Object> pMap) {
		logger.info("boardDelete 호출 성공");
		int result = 0;
		result = boardLogic.boardDelete(pMap);
		return "redirect:boardList";
	}
	@GetMapping("boardUpdate")
	public Object boardUpdate(@RequestParam Map<String,Object> pMap) {
		logger.info("boardUpdate 호출 성공");
		int result = 0;
		result = boardLogic.boardUpdate(pMap);
		// jsp-> action(update) -> action(select) --(forward)--> boardList.jsp
		String path = "redirect:boardList";
		return path;
	}
	@GetMapping("boardDetail")
	public String boardDetail(Model model, @RequestParam Map<String,Object> pMap) {
		logger.info("boardDetail 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = boardLogic.boardDetail(pMap);
		model.addAttribute("boardList",boardList);
		return "forward:read.jsp";
	}	
	//메소드의 파라미터로 객체주입이 되고 있다. - 의존성 주입관계에 있다.
	//스프링에서 제공[인스턴스화를 대신해주고 그 시점도 관리해줌- 라이프사이클 관리]하는 클래스 이다.
	//이런걸 해주니까 개발자는 로직에만 집중할 수 있다. -인스턴스화를 안해도 되고 , 자원반납을 안해도 안전하고
	@GetMapping("boardList")
	public String boardList(Model model, @RequestParam Map<String,Object> pMap) {
		logger.info("boardList 호출 성공--> "+pMap);//cb_search:b_title컬럼 b_writer b_content , tb_search:title
		List<Map<String,Object>> boardList = null;
		//여기 여기....필요할 때 인스턴스화 해서 호출한다 - 게으른 인스턴스화 - 스프링 위치
		//boardLogic = new Board3Logic();//주소번지 다르다
		boardList = boardLogic.boardList(pMap);
		model.addAttribute("boardList",boardList);
//		return "forward:boardList.jsp";//webapp/board/
		//pojo 1-3 ModelAndView경우와 동일
		return "board/boardList";//WEB-INF/views/board/
	}	
	//@GetMapping("boardInsert")
	@PostMapping("boardInsert")
	public String boardInsert(MultipartHttpServletRequest mpRequest, @RequestParam(value="bs_file", required=false) MultipartFile bs_file) {
		int result = 0;
		Map<String,Object> pMap = new HashMap<>();
		HashMapBinder hmb = new HashMapBinder(mpRequest);
		hmb.mbind(pMap);
		logger.info("boardInsert 호출 성공 ==> "+pMap);
		if(!bs_file.isEmpty()) {//
			String filename = bs_file.getOriginalFilename();
			logger.info("한글 처리 테스트 : "+filename);
			String savePath = "D:\\workspace_spring\\demo0921\\src\\main\\webapp\\pds";
			//파일에 대한 풀 네임 담기
			String fullPath = savePath+"\\"+filename;			
			try {
				//File객체는 파일명을 객체화 해줌
				File file = new File(fullPath);
				//board_sub_t에 파일크기를 담기 위해 계삭
				byte[] bytes = bs_file.getBytes();
				BufferedOutputStream bos =
						new BufferedOutputStream(
								new FileOutputStream(file));
				//실제로 파일 내용이 채워짐
				bos.write(bytes);
				bos.close();
				long size = file.length();
				double d_size = Math.floor(size/1024.0);//kb
				logger.info("size:"+d_size);
				pMap.put("bs_file", filename);
				pMap.put("bs_size", d_size);
				logger.info("파일 정보 : "+pMap.get("bs_file")+", "+pMap.get("bs_size"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		result = boardLogic.boardInsert(pMap);
		return "redirect:boardList";
	}	
}
