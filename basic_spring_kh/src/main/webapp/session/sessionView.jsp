<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>세션값 출력하기</title>
</head>
<body>
<%
	String smem_id = (String)session.getAttribute("mem_id");
	String smem_name = (String)session.getAttribute("mem_name");
	out.print(smem_id+","+smem_name);
%>
</body>
</html>