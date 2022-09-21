<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.google.gson.Gson" %>
<%	
	// forward다 forward다 request는 forward 다 - 유지 
	// 요청 url이 바뀌지 않는다. - 요청이 계속 유지되는 것으로 판단 하니까. 뉴가? 똥캣이
	List<Map<String, Object>> boardList =
	(List<Map<String, Object>>)request.getAttribute("boardList");
	Gson g = new Gson();
	String imsi = g.toJson(boardList);
	out.print(imsi);
	%>
