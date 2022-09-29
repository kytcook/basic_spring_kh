<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>    
<%
	List<Map<String,Object>> bookList = 
	(List<Map<String,Object>>)request.getAttribute("bookList"); 
%>
<table>
<%
	if(bookList == null){
%>
	<tr>
		<td>조회 결과가 없습니다.</td>
	</tr>
<%
	}else{
		for(int i=0;i<bookList.size();i++){
			Map<String,Object> rmap = bookList.get(i);
%>
	<tr>
		<td><%=rmap.get("BK_TITLE") %></td>
	</tr>	
<%
		}///// end of for
	}///////// end of else
%>
</table>