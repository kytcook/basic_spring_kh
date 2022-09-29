<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	#d_detail{
		position: abosolute;
	}
</style>
</head>
<body>
	<table>
		<thead>
			<th colspan="2">그림목록</th>
		</thead>
		<tbody>
			<tr>
				<td align="center"><img src="picture1.jpg width="50" height="50"></td>
				<td id="1" onmouseover="startMetohd(this)" onmouseout="clearMethod()">추상화1</td>
			</tr>
			<tr>
				<td align="center"><img src="picture2.jpg width="50" height="50"></td>
				<td id="1" onmouseover="startMetohd(this)" onmouseout="clearMethod()">추상화2</td>
			</tr>
			<tr>
				<td align="center"><img src="picture3.jpg width="50" height="50"></td>
				<td id="1" onmouseover="startMetohd(this)" onmouseout="clearMethod()">추상화3</td>
			</tr>
			<tr>
				<td align="center"><img src="picture4.jpg width="50" height="50"></td>
				<td id="1" onmouseover="startMetohd(this)" onmouseout="clearMethod()">추상화4</td>
			</tr>
		</tbody>
	</table>
	<div id="d_detail"></div>
</body>
</html>