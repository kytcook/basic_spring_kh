<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.List, java.util.ArrayList, java.util.HashMap" %>
<%@ page import="com.google.gson.Gson" %>
<%
	//http://localhost:9000/book/pictureInfo.jsp?p_no=1
	String p_no = request.getParameter("p_no");
	//out.print(p_no);
	List<Map<String, Object>> picList = new ArrayList<>();
	Map<String,Object> rmap = new HashMap<>();
	rmap.put("p_no", 1);
	rmap.put("p_img", "picture1.jpg");
	rmap.put("p_info","그림설명1");
	picList.add(rmap);
	rmap = new HashMap<>();
	rmap.put("p_no", 2);
	rmap.put("p_img", "picture2.jpg");
	rmap.put("p_info","그림설명2");
	picList.add(rmap);
	rmap = new HashMap<>();
	rmap.put("p_no", 3);
	rmap.put("p_img", "picture3.jpg");
	rmap.put("p_info","그림설명3");
	picList.add(rmap);
	rmap = new HashMap<>();
	rmap.put("p_no", 4);
	rmap.put("p_img", "picture4.jpg");
	rmap.put("p_info","그림설명4");
	picList.add(rmap);
	
	List<Map<String, Object>> picDetail = new ArrayList<>();
	Map<String, Object> pmap = null;
	for(int i=0; i<picList.size(); i++){
		Map<String,Object> rdmap = picList.get(i);
		if(p_no.equals(rdmap.get("p_no").toString())){
			pmap = rdmap;
			picDetail.add(pmap);
		}
	}
	Gson g = new Gson();
	String result = g.toJson(picDetail);
	out.print(result);
%>
