package com.vo;

public class Main {

	public static void main(String[] args) {
		DeptVO dvo = new DeptVO();
		dvo.setDeptno(10);
		dvo.setDname("총무부");
		dvo.setLoc("인천");
		System.out.println(dvo.getDname());
	}

}
