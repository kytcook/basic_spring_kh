<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>    
<%
	Map<String,Object> rMap = (Map)request.getAttribute("rMap");
	String memo_content = null;
	memo_content = (String)rMap.get("MEMO_CONTENT");
	//out.print(memo_content);
%>    
<!--  html영역  -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../common/easyui_common.jsp" %>
</head>
<body>
	<script>
		$(document).ready(function(){
			//console.log(name);
			$("#memo_content").textbox('setValue', '<%=memo_content%>')
		});
	</script>
	<label for="memo_content">내용</label>
	<input id="memo_content" name="memo_content" class="easyui-textbox" multiline="true" style="width:300px;height:70px"/>
	<br />
	<a href="javascript:memoContentClose()" class="easyui-linkbutton" iconCls="icon-ok">확인</a>
</body>
</html>