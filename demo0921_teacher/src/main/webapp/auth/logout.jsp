<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//세션에 담긴 정보 모두 비우기
//session에 담긴 정보는 sendRedirect와 forward와 전혀 상관없다
	session.invalidate();
	response.sendRedirect("./index.jsp");
%>