package com.example.demo.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.example.demo.logic.MemberLogic;
import com.example.demo.vo.MemberVO;

@Controller
@RequestMapping("/member/*")
@SessionAttributes({"smem_id","smem_name"})
public class MemberController {
   Logger logger = LoggerFactory.getLogger(MemberController.class);
   @Autowired(required=false)
   private MemberLogic memberLogic = null;
   
   @GetMapping("login")
   public String login(HttpSession session, @RequestParam Map<String,Object> pMap) {
      logger.info("login호출 성공 : "+pMap);
      MemberVO mVO = null;
      mVO = memberLogic.login(pMap);
      logger.info("logic-dao 거쳐온 pMap : "+mVO);
      if(mVO != null) {
         session.setAttribute("smem_id", mVO.getMem_id());
         session.setAttribute("smem_name", mVO.getMem_name());
      }
      return "redirect:/auth/index.jsp";
   }
   
   @GetMapping("memberInsert")
   public String memberInsert(@RequestParam Map<String,Object> pMap) {
      logger.info("컨트롤러의 memberInsert호출 성공! 넘어온 pMap: "+pMap);
      int result = 0;
      result = memberLogic.memberInsert(pMap);
      return "redirect:/auth/index.jsp";
   }
}