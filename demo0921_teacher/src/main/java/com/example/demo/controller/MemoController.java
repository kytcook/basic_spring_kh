package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.logic.MemoLogic;
import com.google.gson.Gson;

@Controller
@RequestMapping("/memo/*")
public class MemoController {
	Logger logger = LoggerFactory.getLogger(MemoController.class);	
	@Autowired(required=false)
	private MemoLogic memoLogic = null;
	//컨트롤계층에서는 Model과 @RequestParam 지원받고 있다. - 컨트롤클래스는 필요한가?
	//역할은 무엇을 주어야 하나?
	//스프링에서는 객체주입으로 지원하고 있으니까 개발자가 따로 고민하지 않아도 괜찮아.
	//POJO 대 스프링(획일적인 구조를 가져간다-추가기능생김, 업무에대한 depth가 달라서 다른팀 지원을 나간다.)
	//xml방식으로의 설정과 - 메소드의 파라미터로 주입을 받는 대신 xml문서의 정의된 객체 주입받는 방식
	//어노테이션 방식으로 설정 차이점에 대해서 말 할 수 있다. - 자바코드, 파라미터에도 어노테이션을 지원함
	//인스턴스화 없이 사용할 수 있다.
	//직접 new A()하지 않는다. 
	//생성자를 직접 호출하지 않는다
	//자원반납을 직접 하지 않아도 된다.
	//초기화도 직접 할 필요 없다.
	//메모리 관리 - 동시접속자 수가 많은 경우라면??
	//컨트롤 클래스부터 구현한다
	//로직 클래스부터 구현한다
	//Dao클래스 부터 구현다.
	//화면이 다르게 되면 로직과 Dao는 재사용하더라도 컨트롤은 분리하는 것이 유지보수에 유리함
	@GetMapping("memoContent")
	public String memoContent(Model model, @RequestParam Map<String,Object> pMap) {
		Map<String,Object> rMap = null;
		rMap = memoLogic.memoContent(pMap);
		model.addAttribute("rMap", rMap);
		//@RestController, @ResponseBody
		return "forward:/memo/memoContent.jsp";
	}
	@GetMapping("memoInsert")
	public String memoInsert(@RequestParam Map<String,Object> pMap) {
		logger.info("memoInsert호출 성공 : "+pMap);
		int result = 0;
		result = memoLogic.memoInsert(pMap);
		return "redirect:/auth/index.jsp";
	}
	@GetMapping("sendMemoList")
	public String sendMemoList(Model model, @RequestParam Map<String,Object> pMap) {
		List<Map<String,Object>> sendMemoList = null;
		sendMemoList = memoLogic.sendMemoList(pMap);
		model.addAttribute("sendMemoList", sendMemoList);
		//@RestController, @ResponseBody
		return "forward:/memo/jsonSendMemoList.jsp";
	}	
	@GetMapping("receiveMemoList")
	public String receiveMemoList(HttpSession session,Model model, @RequestParam Map<String,Object> pMap) {
		List<Map<String,Object>> receiveMemoList = null;
		receiveMemoList = memoLogic.receiveMemoList(pMap, session);
		model.addAttribute("receiveMemoList", receiveMemoList);
		return "forward:/memo/jsonReceiveMemoList.jsp";
	}	
}
