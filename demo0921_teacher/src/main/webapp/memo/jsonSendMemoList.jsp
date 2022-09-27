<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map"%>
<%@ page import="com.google.gson.Gson"%>
<%
//요청이 URL이 바뀌지 않아요 - forward
	List<Map<String,Object>> sendMemoList = 
	(List<Map<String,Object>>)request.getAttribute("sendMemoList");
	Gson g = new Gson();
	String imsi = g.toJson(sendMemoList);
	out.print(imsi);
%>    
