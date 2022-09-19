<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>    
<%
	List<Map<String,Object>> boardList = (List)request.getAttribute("boardList");
	out.print(boardList);// 리액트 조합 -> JSON포맷으로 받아낸다
	//@Controller -  페이지처리
	//@RestController - 직접 바로 JSON으로 받아낼 수 있다.
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Spring이관작업</title>
</head>
<body>
게시글 목록
</body>
</html>