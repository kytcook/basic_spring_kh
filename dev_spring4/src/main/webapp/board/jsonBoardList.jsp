<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>    
<%@ page import="com.google.gson.Gson" %>    
<%
	List<Map<String,Object>> boardList = (List)request.getAttribute("boardList");
	Gson g = new Gson();
	String temp = g.toJson(boardList);
	out.print(temp);
	//out.print(boardList);// 리액트 조합 -> JSON포맷으로 받아낸다
	//@Controller -  페이지처리
	//@RestController - 직접 바로 JSON으로 받아낼 수 있다.
%>    
