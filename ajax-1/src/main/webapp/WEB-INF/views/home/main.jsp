<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp[WEB-INF/views/home]</title>
<%@include file="/common/static-common.jsp"%>
<script type="text/javascript" defer src="/js/main.js"></script>
</head>
<body>
	<br />
	main.jsp페이지 입니다.
	<hr />
	<input id="mem_id" value="tomato"><br />
	<input id="mem_name" value="토마토"><br />
	<button id="btn-send" class="btn btn-primary">POST전송</button>
	<button id="btn-send2" class="btn btn-primary">GET전송</button>
</body>
</html>