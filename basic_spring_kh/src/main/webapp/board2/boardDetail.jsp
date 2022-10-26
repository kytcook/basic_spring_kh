<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.kh.test.board.model.vo.Board" %>    
<%
//http://localhost:8000/step1/board2/selectBoard.sp4?bid=1
	Board board = (Board)request.getAttribute("board");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글상세 보기</title>
</head>
<body>
<%
	out.print(board.getTitle());
	out.print("<br/>");
	out.print(board.getWriter());
	out.print("<br/>");
	out.print(board.getContent());
	out.print("<br/>");
%>
</body>
</html>