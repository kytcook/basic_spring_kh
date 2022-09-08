package com.di;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class ListController extends AbstractController {
	Logger logger = Logger.getLogger(ListController.class);
	//객체 주입받는 클래스의 변수명은 마음대로 바꿀 수 있다|없다(setter객체주입법) 
	List<String> insaBean = null;
	public void setInsaBean(List<String> insaBean) {
		this.insaBean = insaBean;
	}
	// url -> /di/insaList
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
		logger.info("insaBean===>"+insaBean);
		ModelAndView mav = new ModelAndView();
		mav.addObject("insaBean",insaBean);
		mav.setViewName("di/insaList");
		return mav;
	}

}
