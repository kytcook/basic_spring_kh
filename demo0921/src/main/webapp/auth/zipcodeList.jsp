<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>    
<%
	List<Map<String,Object>> zipList = 
	(List<Map<String,Object>>)request.getAttribute("zipList");
%>    
<table width="500px" border="1">
	<tr>
		<th>우편번호</th>
		<th>우편주소</th>	
	</tr>
<%
	if(zipList == null || zipList.size()==0){
%>	
	<tr>
		<td colspan="2">조회결과가 없습니다.</td>
	</tr>
<%
	}else{
		for(int i=0;i<zipList.size();i++){	
			Map<String,Object> rmap = zipList.get(i);
%>
	<tr>
<!-- memberShip or zipcodeForm or zipcodeList -->	
		<td><a href="javascript:choice('<%=rmap.get("ZIPCODE")%>','<%=rmap.get("ADDRESS")%>')"><%=rmap.get("ZIPCODE")%></a></td>
		<td><%=rmap.get("ADDRESS")%></td>
	</tr>
<%
		}
	}
%>	
</table>