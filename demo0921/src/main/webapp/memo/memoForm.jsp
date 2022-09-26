<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String smem_id = (String)session.getAttribute("smem_id");
	String smem_name = (String)session.getAttribute("smem_name");	
	String to_id = request.getParameter("to_id");
	String to_name = request.getParameter("to_name");	
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쪽지쓰기</title>
<%@ include file="../common/easyui_common.jsp" %>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#from_id").textbox('setValue', '<%=smem_id%>');
			$("#from_name").textbox('setValue', '<%=smem_name%>');
			$("#to_id").textbox('setValue', '<%=to_id%>');
			$("#to_name").textbox('setValue', '<%=to_name%>');
		})
	</script>
	<div>
   		<form id="f_memo" method="get" action="/memo/memoInsert">
		<label for="to_id">받는사람</label>
		<input id="to_name" name="to_name" class="easyui-textbox" style="width:100px"/>
		(<input id="to_id" name="to_id" class="easyui-textbox" style="width:100px"/>)
		<br>
		<label for="from_id">보내는사람</label>
		<input id="from_name" name="from_name" class="easyui-textbox" style="width:100px"/>
		(<input id="from_id" name="from_id" class="easyui-textbox" style="width:100px"/>)
		<br>
		<label for="memo_content">내   용</label>
		<input id="memo_content" name="memo_content" multiline="true" class="easyui-textbox" style="width:300px;height:70px"/>
		<br>
		</form>
		<a href="javascript:memoSend()" class="easyui-linkbutton">가입</a>	
	</div>
</body>
</html>