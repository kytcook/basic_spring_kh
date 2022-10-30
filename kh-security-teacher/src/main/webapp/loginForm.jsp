<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>로그인 페이지</title>
</head>
<body>
	<h1>로그인</h1>
	<hr />
	<form action="./loginAction" method="post">
		<input type="text" name="username" placeholder="enter username" /><br />
		<input type="password" name="password" placeholder="enter password" /><br />
		<button>로그인</button>
	</form>
	<br />
	<a href="/memberForm.jsp">회원가입</a>
</body>
</html>
