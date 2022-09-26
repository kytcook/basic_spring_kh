<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.example.demo.vo.MemberVO" %>
<%/* 세션타입을 맞춰주고 세션에서 아이디와 이름을 꺼내주자 */
	String smem_id = (String)session.getAttribute("smem_id");
	String smem_name = (String)session.getAttribute("smem_name");
	out.print("사용자아이디 : " + smem_id + ", " + "사용자 이름 : " + smem_name);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>인증처리 - 쿠키와 세션</title>
	<%@ include file="../common/easyui_common.jsp" %>
	<style type="text/css">
		a {
		  text-decoration: none;
		}
	</style>
	<script type="text/javascript">
		let to_id;// 받는사람 아이디 - 사용자가 입력하는 것이 아니라 쪽지쓰기 로우에서 자동으로 담기
		let to_name;// 받는사람 이름
	// 함수선언은 head태그 안에서 한다.
	// easyui_common.jsp
		function memberInsert() {
			//alert("입력")
			
		}
		function memberUpdate() {
			//alert("수정")
			
		}
		function memberDelete() {
			//alert("삭제")
			
		}
		function login(){
			const tb_id = $("#mem_id").val();
			const tb_pw = $("#mem_pw").val();			
			location.href="/member/login?mem_id="+tb_id+"&mem_pw="+tb_pw;
			
		}
		function logout(){
			location.href="./logout.jsp";
			
		}
		// 순서지향적인, 절차지향적인 코딩 -> 모듈화 -> 비동기처럼 처리 하기(연습-await, async)
		function memberList(){
			//alert("회원목록 호출 성공");
			//alert($("#_easyui_textbox_input4").val());
			let type = null;
			let keyword = null;
			if($("#_easyui_textbox_input4").val()!=null && $("#_easyui_textbox_input4").val().length>0) {
				type = "mem_id";
				keyword = $("#_easyui_textbox_input4").val();
			}
			else if($("#_easyui_textbox_input5").val()!=null && $("#_easyui_textbox_input5").val().length>0) {
				type = "mem_name";
				keyword = $("#_easyui_textbox_input5").val();
			}
			// before
			// 아래 코드는 클라이언트 측에 같이 다운로드가 완료된 상태에서 처리가 된다. - 결정이 되었다.
			// 시점의 문제
			// jeasyUI datagrid에서도 get방식과 post방식을 지원함
			// url속성에 xxx.jsp가 오면 포준 서블릿인 HttpServlet이 관여하는 것이고
			// XXX.pj로 요청하면 ActionSupport가 관여하는 것이다.
			$("#dg_member").datagrid({
				//오라클서버에서 요청한 결과를 myBatis를 사용하면 자동으로 컬럼명이 대문자
				//단 List<XXVO>형태라면 그땐 소문자가 맞다				
				method:"get"
				,url:"/member/jsonMemberList?type="+type+"&keyword="+keyword // 응답페이지는 JSON포맷의 파일이어야 함. (html이 아니라)
				,onSelect: function(index, row){
					to_id = row.Mem_ID;// 데이터그리드 선택시해당 로우의 아이디 담기
					to_name = row.MEM_NAME;// 데이터그리드 선택시 해당 로우의 이름 담기
					console.log(to_id+ " , " +to_name);
				}
				,onDblClickCell: function(index,field,value){
					//console.log(index+", "+field+", "+value);
					if("BUTTON" == field) {
						alert("쪽지쓰기");
					}
				}
			});	
			$("#d_member").show();
			// after
			$("#d_memberInsert").hide();
		}
		
		function memberInsert(){
			//alert("회원등록 호출 성공");
			$("#d_member").hide();
			$("#d_memberInsert").show();
		}
		
		function memoForm(){
			console.log("memoForm 호출");
			$("#dlg_memo").dialog({
				title: "쪽지쓰기",
				href:"/memo/memoForm.jsp?to_id="+to_id+"&to_name="+to_name,
				modal: true,
				closed: true
			});
			$("#dlg_memo").dialog('open');
		}
		
		function memoSend(){
			console.log("쪽지보내기");
			$("#f_memo").submit();
		}
		function memoFormClose(){
			$("#dlg_memo").dialog('close');
		}
	</script>
</head>
<body>
<script>
	// DOM트리가 다 그려 진거니? - yes
	// DOM트리가 그려졌을 때 - 준비되었을 때 - ready
	$(document).ready(function(){
		$("#d_member").hide();
		$("#d_memberInsert").hide();
		$("#mem_id").textbox('setValue','apple');
		$("#mem_pw").textbox('setValue','123');
		
	});
</script>
    <div style="margin:20px 0;"></div>
    <div class="easyui-layout" style="width:1000px;height:500px;">
        <div data-options="region:'south',split:true" style="height:50px;"></div>
        <div data-options="region:'west',split:true" title="KH정보교육원" style="width:200px;">
 			<div style="margin:10px 0;"></div>
      
<%
	//s_name = "이순신";
	if(smem_name == null){
%>
<!--######################  로그인 영역 시작 ######################-->    
			<div id="d_login" align="center">
			<div style="margin: 3px 0;"></div>
			<input id="mem_id" name="mem_id" class="easyu-textbox"/>
			<script type="text/javascript">
			$("#mem_id").textbox({
				iconCls:'icon-man',
				iconAlign: 'right',
				prompt: '아이디'
			});
			</script>
			<div style="margin: 3px 0;"></div>
			<input id="mem_pw" name="mem_pw" class="easyui-passwordbox"/>
			<script type="text/javascript">
			$("#mem_pw").passwordbox({
				iconAlign: 'right',
				prompt: '비밀번호'
			});
			</script>					
			<div style="margin: 3px 0;"></div>
			<a id="btn_login" href="javascript:login()" class="easyui-linkbutton" data-options="iconCls:'icon-man'">
			로그인
			</a>
			<a id="btn_member" href="javascript:memberShip()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">
			회원가입
			</a>
			</div>
		
<!--######################  로그인 영역 끝 ######################-->    
<%
	}else {
%>
<!--###################### 로그아웃 영역 시작 ######################-->     
			<div id="d_logout" align="center">
				<div id="d_ok"><%=smem_name%>님 환영합니다.</div>
				<div style="margin:3px 0"></div>
				<a id="btn_logout" href="javascript:logout()" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">
				로그아웃
				</a>
				<a id="btn_member" href="javascript:memberUpdate()" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">
				정보수정
				</a>
			</div>
<!--###################### 로그아웃 영역  끝 ######################-->   
<%
	}// end of 로그아웃
%>   
<!--###################### 메뉴 영역 시작 ######################-->
    <div style="margin:20px 0;"></div>
<%
	if(smem_id != null){
%>   
      <ul id="tre_gym" class="easyui-tree" style="margin:0 6px">
          <li data-options="state:'closed'">
              <span>회원관리</span>
               <ul>
	               <li>
	 		       		<a href="javascript:memberList()">회원목록</a>
	               </li>
	               <li>
	                 	<a href="javascript:memberInsert()">회원등록</a>
	               </li>
	               <li>    
	                 	<a href="javascript:memberDelete()">회원삭제</a>
				   </li>
               </ul>
          </li>
          
          <li data-options="state:'closed'">
              <span>쪽지관리</span>
              <ul>
	               <li>
	 		       		<span>받은쪽지함</span>
	               </li>
	               <li>
	                 	<span>보낸쪽지함</span>
	               </li>
              </ul>
          </li>
          
          <li data-options="state:'closed'">
              <span>게시판</span>
              <ul>
	               <li>
	 		       		<span>1:1</span>
	               </li>
	               <li>
	 		       		<span>공지사항</span>
	               </li>
	               <li>
	                 	<span>QnA</span>
	               </li>
              </ul>
          </li>
      </ul>
<%
	}
%>
    </div>      
<!--###################### 메뉴 영역 끝 ######################-->
        <div data-options="region:'center',title:'TerrGYM System',iconCls:'icon-ok'">
        
        <!-- [[ 회원관리{회원목록, 회원등록, 회원삭제]] -->
        	<div id="d_member">
        	<div style="margin: 5px 0px"></div>
       		HOME > 회원관리 > 회원목록
       		<hr>
	    	<div style="margin: 20px 0"></div>
	    <!--[[ 조건검색 화면 ]]-->
	    	<div style="margin: 20px 0">
	    	아이디 : <input id="mem_id" name="mem_id" class="easyui-textbox" style="width:110px">
	    	&nbsp;&nbsp;&nbsp;
	    	이 름 : <input id="mem_name" name="mem_name" class="easyui-textbox" style="width:110px">
	    	</div>
	    <!--[[ 조회|입력|수정|삭제 버튼 ]]-->
	    	<div style="margin: 10px 0;">
				<a id="btn" href="javascript:memberList()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">조회</a>
				<a id="btn" href="javascript:memberInsert()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">입력</a>
				<a id="btn" href="javascript:memberUpdate()" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">수정</a>
				<a id="btn" href="javascript:memberDelete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">삭제</a>	    	
	    	</div>
	    <!--[[ 회원목록 출력 ]]-->
		    <table id="dg_member" class="easyui-datagrid" style="width:700px;height:250px"
		            data-options="singleSelect:true,collapsible:true,method:'get'">
		        <thead>
		            <tr>
		                <th data-options="field:'MEM_ID',width:80">아이디</th>
		                <th data-options="field:'MEM_NAME',width:100">이름</th>
		                <th data-options="field:'MEM_ADDRESS',width:300,align:'left'">주소</th>
		                <th data-options="field:'BUTTON',width:80,align:'center'">버튼</th>
		            </tr>
		        </thead>
		    </table>    
	    	</div>
	    	
        	<div id="d_memberInsert">
	        	<div style="margin: 5px 0px"></div>
	       		HOME > 회원관리 > 회원등록
	       		<hr>
		    	<div style="margin: 20px 0;"></div>
		    	<div>회원등록화면 보여주기</div>
	    	</div>
        <!-- [[ 쪽지관리{받은쪽지함, 보낸쪽지함} ]] -->
		    <div id="dlg_memo" footer="#btn_memo" class="easyui-dialog" 
		         title="쪽지쓰기" data-options="modal:true,closed:true" 
		         style="width:600px;height:400px;padding:10px">
				<div id="btn_memo" align="right">
					<a href="javascript:memoFormClose()" class="easyui-linkbutton" iconCls="icon-clear">닫기</a>
		 		</div>
		 	</div>
		 </div>
	</div>
 	
</body>
</html>