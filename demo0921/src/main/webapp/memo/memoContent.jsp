<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
	// 자바영역 - 톰캣서버에서 처리된 결과가 내보내진다.
	// 이미 값들이 결정된 상태이다.
	Map<String, Object> rMap = (Map)request.getAttribute("rMap");
	String memo_content = null;
	memo_content = (String)rMap.get("MEMO_CONTENT");
	//out.print(memo_content);
%>
<!-- html영역입니다~ -->
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
	<label for="mem_content">내용</label>
	<input id="memo_content" name="memo_content" class="easyui-linkbutton" multiline="true" style="width:300px;height:70px"/>
	<br />
	<a href="javascript:memoContentClose()" class="easyui-linkbutton" iconCls="icon-ok">확인</a>
</body>
</html>