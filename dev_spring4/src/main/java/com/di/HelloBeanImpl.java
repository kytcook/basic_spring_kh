package com.di;
//통일감 - 팀장마다 설계가 다르다
public class HelloBeanImpl implements HelloBean {
	String msg = null;
	public void setMsg(String msg) {
		this.msg = msg;
	}
	@Override
	public String getGreeting(String msg) {
		return "Spring!!! "+this.msg;
	}

}
