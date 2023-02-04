<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--@ page import="egovframework.rte.ipss.common.vo.TnUser,org.springframework.security.core.context.SecurityContextHolder" --%>
<%@ page import="egovframework.rte.daps.usermgmt.vo.TnUpisUserVo,org.springframework.security.core.context.SecurityContextHolder" %>
<% TnUpisUserVo user = (TnUpisUserVo)SecurityContextHolder.getContext().getAuthentication().getDetails(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title><c:out value="정보입력" /></title>
<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_USER')">
	<c:set var="username">
		<sec:authentication property="principal" /> 
	</c:set>
</sec:authorize>
<script type="text/javascript">
var isLimited;
var rdnmAddrPop;
function delegationTypeSelected(type){
	if(type == '0'){
		/*한정 위임*/
		$("#descAll").hide();
		$("#descLimited").show();
		$('#agentType').html('<span color=\'red\'><b>위임형태 : 한정 위임</b></span><input type="hidden" id="isAgent" value="true"/>');
		$("#btnLimited").removeClass("gray");
		$("#btnLimited").addClass("sky");
		$("#btnAll").removeClass("sky");
		$("#btnAll").addClass("gray");
		$("#selectUserForm input[name='agentType']").val("DAA000020");
		isLimited = true;
	} else {
		/*포괄 위임*/
		$("#descLimited").hide();
		$("#descAll").show();
		$('#agentType').html('<span color=\'red\'><b>위임형태 : 포괄 위임</b></span><input type="hidden" id="isAgent" value="true"/>');
		$("#btnLimited").removeClass("sky");
		$("#btnLimited").addClass("gray");
		$("#btnAll").removeClass("gray");
		$("#btnAll").addClass("sky");
		$("#selectUserForm input[name='agentType']").val("DAA000010");
		isLimited = false;
	}
}
function closeError(){
	error.dialog("close");
	error.remove();
}
  
function divChange(){
	var name = $("#searchChange").val();
	if(name == "userid"){
		$("#userIdSearch").css("display","inline-block");
		$("#phoneNoSearch").css("display","none");
	}else if(name == "phoneNo"){
		$("#phoneNoSearch").css("display","inline-block");
		$("#userIdSearch").css("display","none");
	}
}

function fnOnKeyUp(evt) {
	$(evt.target).val($(evt.target).val().replace(/[^0-9]/g,""));
}
function fnOnKeyUpEmail(evt) {
	$(evt.target).val($(evt.target).val().replace(/[^a-z0-9-_]/g,""));
}
function fnOnKeyUpDomain(evt) {
	$(evt.target).val($(evt.target).val().replace(/[^a-z0-9.]/g,""));
}

$(document).ready(function() {

// 	$("#radioGroup").css("display", "${display}");
	fnTypeChange();
	$("#divDelegate").css("display", "${display}");
	$("#delegationType").hide();
	if("${display}" == "none") {
		$("#warning").show();
		$("#delegationType").show();
		$("#delegationTypeTitle").show();
		$("#delegationTypeTitle2").show();
		$("#userTypeTitle").remove();
	}else {
		$("#warning").remove();
		$("#delegationTypeTitle").remove();
		$("#delegationTypeTitle2").remove();
		$("#userTypeTitle").show();
		$("#delegationType").remove();
	}
	$(".txtDisable").prop("disabled",true);
	$(".txtDisable").prop("disabled",false);
	$("#selEmailDomain").prop("disabled", false);
	$(".txtDisable").text("");
	$("#selEmailDomain").val("");
	/* $("#selEmailDomain").prop("disabled", true); */
	if(<c:out value="${num}"/> == 1){
		$("#selectUserForm").append("<input type='hidden' name='agentType' value='DAA000020' />");
	}
	if(<c:out value="${num}"/> == 2 || <c:out value="${num}"/> == 3 || <c:out value="${num}"/> == 4){
		$("#saveBtn").css("display","${display}");
		$("#selectUserPop #type").disable();
		$("#selectUserPop input").disable();
		$("#selectUserPop select").disable();
		$("#selectUserPop .button").hide();
		$("#bottom_bar .button").css("display","inline");
		$("#warning").remove();
		$("#delegationType").remove();
		$("#delegationTypeTitle").remove();
		$("#delegationTypeTitle2").remove();
		if(<c:out value="${num}"/> == 2){
			var index = $("#applicant tr").index($("#applicant tr.highlight"));
			var data = applicant.get(index);
		} else if(<c:out value="${num}"/> == 4) {
			var index = $("#applicantOld tr").index($("#applicantOld tr.highlight"));
			var data = applicant.get(index);
		} else {
			var index = $("#agent tr").index($("#agent tr.highlight"));
			var data = agent.get(index);
		}
		
		$.each(data, function(name, value){
			
			var num = <c:out value="${num}"/>;
			if(num==3 )//대리인
			{
				if(name == "cprYn" )
				{
					if(value!=""&&value!=undefined&&value!=null&& value==true)//법인
					{
						$("#dialog #type").val("corperation");
						$("#dialog td input[name=coRgstNo]").val(fnNvl(data.corporationNum).toString().replace('`', ''));
					}
					else
					{
						$("dialog td input[name=identifyNo]").val(fnNvl(data.corporationNum).toString().replace('`', ''));
					}
					fnTypeChange();
				}
			}
			if(num==2||num==4)//신청인
			{
				if(name == "presidentNm")
				{
					if(value!=""&&value!=undefined&&value!=null&&value!='null')//법인
					{
						$("#dialog #type").val("corperation");
						$("#dialog td input[name=coRgstNo]").val(fnNvl(data.identifyNo).toString().replace('`', ''));
					}
					fnTypeChange();
				}
				if(name=="coRgstNo"&&!(value!=""&&value!=undefined&&value!=null&&value!='null'))
				{
					name=name+"_";
				}
			}

			value = fnNvl(value).toString().replace('`', '');
			/* 
			if(value) {
				2018.09.28 법인 정보 표기 추가 
				if(name == "cprYn" )
				{
					if(value!=""&&value!=undefined&&value!=null&& value==true)//법인
					{
						$("#dialog #type").val("corperation");
						
						if(<c:out value="${num}"/> == 3 && name=="identifyNo"&& value!=""&&value!=undefined&&value!=null)
						{
							$("#dialog td input[name='coRgstNo']").val(value);
						}
					}
					fnTypeChange();
				}
			} */
			
			$("#dialog td input[name='" + name + "']").val(value);
			$("#dialog td select[name='" + name + "']").val(value);
		});
	}
	
	$("#selEmailDomain").on("change", function() {
		if($("#selEmailDomain option:selected").val() == "custom") {
			$("#txtEmailDomain").val("");
			$("#txtEmailDomain").prop('disabled', false);
		} else {
			$("#txtEmailDomain").val($("#selEmailDomain option:selected").val());
			$("#txtEmailDomain").prop('disabled', true);
		}
		if($("input[name=diInpYn]:checked").val() == "false") {
			$("#selEmailDomain").prop("disabled", true);
			$("#txtEmailDomain").prop("disabled", true);
		}
		if($("input[name=diInpYn]:checked").val() == "false") {
			$("#selEmailDomain").prop("disabled", true);
			$("#txtEmailDomain").prop("disabled", true);
		}
		if($("#selEmailDomain option:selected").val() != "custom") {
			$("#txtEmailDomain").val($(this).val());
		}
	});
	
	$("#radioGroup input").on("change", function(){
		if($("input[name=diInpYn]:checked").val() == "false") {
			$("#appNm").val("<%=user.getUserNm()%>").disable();
			$("#identifyNo").val("<%=user.getUserIdNo()%>").disable();
			$("#presidentNm").val("<%=user.getUserCeoNm()%>").disable();
			$("#rdnmadr").val("<%=user.getUserAddrPre()%>").disable();
			$("#rdnmadrDetail").val("<%=user.getUserAddrSuf()%>").disable();
			$("select[name=mobileArea]").val("<%=user.getUserMobileLoc()%>").disable();
	 		$("#mobilePre").val("<%=user.getUserMobilePre()%>").disable();
	 		$("#mobileSuf").val("<%=user.getUserMobileSuf()%>").disable();
	 		$("#selEmailDomain").val("<%=user.getUserEmailDomain()%>").disable();
	 		$("#selEmailDomain").trigger("change");
	 		$("#txtEmail").val("<%=user.getUserEmailId()%>").disable();
	 		$("#txtEmailDomain").val("<%=user.getUserEmailDomain()%>").disable();
	 		var getUserTelArea = "";
	 		if(<%=user.getUserTelArea()%>)
	 			getUserTelArea = "<%=user.getUserTelArea()%>".replace(/ /g, '');
	 		$("select[name=telArea]").val(getUserTelArea).disable();
	 		$("#telPre").val("<%=user.getUserTelPre()%>").disable();
	 		$("#telSuf").val("<%=user.getUserTelSuf()%>").disable();
	 		$("#userSeq").val(<%=user.getUserSeq()%>).disable();
		} else {
			$("#dialog td input:not([type=radio])").val("").enable();
			$("#selEmailDomain").val("null").enable();
			$("#selEmailDomain").trigger("change");
		}
	});
	$("input[type=number]").css("outline","0px");
	$("input[name=mobilePre]").on("input",function(){
		var regex = /[0-9]{3,4}/g;
		if($(this).val().length >= 5)
			$(this).val($(this).val().substring(0,4));
		if($(this).val().match(regex))
			$(this).css("border", "1px solid #2FC578");
		else {
			$(this).css("border", "1px solid #ff2e2e");
			$(this).focus();
		}
	});
	$("input[name=mobileSuf]").on("input",function(){
		var regex = /[0-9]{4}/g;
		if($(this).val().length >= 5)
			$(this).val($(this).val().substring(0,4));
		if($(this).val().match(regex))
			$(this).css("border", "1px solid #2FC578");
		else {
			$(this).css("border", "1px solid #ff2e2e");
			$(this).focus();
		}
	});
	$("input[name=telPre]").on("input",function(){
		var regex = /[0-9]{3,4}/g;
		if($(this).val().length >= 5)
			$(this).val($(this).val().substring(0,4));
		if($(this).val().match(regex))
			$(this).css("border", "1px solid #2FC578");
		else {
			$(this).css("border", "1px solid #ff2e2e");
			$(this).focus();
		}
	});
	$("input[name=telSuf]").on("input",function(){
		var regex = /[0-9]{4}/g;
		if($(this).val().length >= 5)
			$(this).val($(this).val().substring(0,4));
		if($(this).val().match(regex))
			$(this).css("border", "1px solid #2FC578");
		else {
			$(this).css("border", "1px solid #ff2e2e");
			$(this).focus();
		}
	});
// 	$("#dialog td input[name='diInpYn'][value='true']").trigger("click");
// 	droppers.push($(value).data("dropper"));
});
function fnSearchStreetAddr() {
	rdnmAddrPop = window.open("", "_blank", "location=no,width=550,height=550,resizable = no");
	rdnmAddrPop.document.write("<form id='temp' action='<c:url value='/cmnmgmt/viewSelectRdnmAdr.pop'/>' method='POST'></form>");
	rdnmAddrPop.document.forms.temp.submit();
}
function jusoCallBack(rdnmrdnmadr, rdnmrdnmadrDetail, rdnmAddrTyped, rdnmAddrDong, rdnmAddrEng, jibun, zipCd, dongCd, dd, pnuWithOldZip){
	//debugger;
	var pnu = pnuWithOldZip.substring(0, pnuWithOldZip.length - 6);
	$("#rdnmadr").val(rdnmrdnmadrDetail);
	$("#rdnmadrDetail").val(rdnmAddrTyped);
	//TODO:PNU
	//TODO:지번
	rdnmAddrPop.close();
}
/*
 @param isAgent => true이면 대리인용 팝업, false이면 신청인용 팝업
 */
function save(isAgent)
{
	
	var userType = "<%=user.getUserType()%>";
	if($("input[name=chkInfoAgree]:checked").val()!="chkInfoAgree") 
	{
		"개인정보 활용에 동의 하셔야 진행이 가능합니다.".alert();
	}
	
	if(isAgent) //대리인 등록
	{
		/* 대리인 입력 일 때*/
		$("#selectUserForm input").prop('disabled', false);
		$("#selectUserForm select").prop('disabled', false);
		$("input[name=chkInfoAgree]").disable();
		var temp = $("#selectUserForm").fnSerializeObject();
		temp.rdnmadr = $("#rdnmadr").val();/*사용자주소*/
		if (temp.appNm == "") 
		{
			//alert("성명을 입력하세요.");
			"성명을 입력하세요.".alert();
			$("#appNm").focus();
			return;
		} 
		else if ($("#type").val() == "person" && temp.identifyNo == "") 
		{
			"생년월일을 입력하세요.".alert();
			$("#identifyNo").focus();
			return;
		} 
		else if($("#type").val() == "corperation" && (temp.coRgstNo == "" || temp.coRgstNo == undefined ||  temp.coRgstNo.length!=13)) 
		{
			"법인등록번호를 입력하세요.".alert();
			$("#identifyNo").focus();
			
			return;
		}
		else if($("#type").val() == "person" && !dateVailidationCheck($("#identifyNo").val()))
		{//개인의 경우 생년월일 정상 값 check
			"정상적인 생년월일을 입력하세요.".alert();
			$("#identifyNo").focus();
			return;
		}
		else if((temp.mobilePre!=""||temp.mobileSuf!="")&&(temp.mobilePre==""||temp.mobilePre.length<3||temp.mobileSuf=="" ||temp.mobileSuf.length!=4))
		{
			"휴대전화번호를 정확히 입력하세요".alert();	
			return ;	
		}
		else if((temp.telPre!=""||temp.telSuf!="")&&(temp.telPre=="" ||temp.telPre.length<3||temp.telSuf=="" ||temp.telSuf.length!=4))
		{
			"유선전화번호를 정확히 입력하세요".alert();	
			return ;	
		}
		else if(temp.telPre==""&&temp.telSuf==""&&temp.mobilePre==""&&temp.mobileSuf=="")
		{
			"유선전화번호나 휴대전화번호 둘 중 하나는 입력해야합니다.".alert();
			return ;
		}
		else if($("#messaging").prop("checked") && (temp.mobilePre=="" || temp.mobileSuf=="")) //SMS 수신 체크시 휴대전화번호 필수
		{
			"SMS 수신 동의시 휴대전화번호 입력은 필수입니다.".alert();
			return ;
		}
		else
		{
			 if($("#dialog #type").val() == "corperation")
			 {
					if (temp.presidentNm == "") 
					{
						"대표자명을 입력하세요.".alert()
						$("#presidentNm").focus();
						return ;
					}
					else if($("#delegationType").find(".sky").length == 0)
					{
						"대리인 권한을 선택하세요.".alert();
						return ;
					}
					else
					{
						temp.identifyNo =temp.coRgstNo;/*법인일 경우 법인등록번호를 identifyNo로 setting*/
						temp.agentYn=true;
						agent.clear();
						agent.push(temp);
						$("#selectUserForm input").prop('disabled', true);
						modalPop.dialog('close');
					}
			 }
			 else if($("#delegationType").find(".sky").length == 0)
			 {
				 "대리인 권한을 선택하세요.".alert();
				  return;
			 }
			 else
			 {
			    temp.agentYn=true;
				agent.clear();
				agent.push(temp);
				$("#selectUserForm input").prop('disabled', true);
				modalPop.dialog('close');
			 }
		}
	} 
	else //신청인 등록
	{
		/* 신청인 입력 일 때*/
		$("#selectUserForm input").prop('disabled', false);
		$("input#rdnmadr").disable();
		$("#selectUserForm select").prop('disabled', false);
		$("input[name=chkInfoAgree]").disable();
		var temp = $("#selectUserForm").fnSerializeObject();
		temp.rdnmadr = $("#rdnmadr").val();/*사용자주소*/
		if (temp.appNm == "") {
			///alert("성명을 입력하세요.");
			"성명을 입력하세요.".alert();
			$("#appNm").focus();
			return
		} 
		else if (temp.rdnmadr == ""||temp.rdnmadr == undefined)
		{
			"주소를 입력하세요.".alert();
			$("#rdnmadr").focus();
			return ;
		}
		else if((temp.mobilePre!=""||temp.mobileSuf!="")&&(temp.mobilePre==""||temp.mobilePre.length<3||temp.mobileSuf=="" ||temp.mobileSuf.length!=4))
		{
			"휴대전화번호를 정확히 입력하세요".alert();	
			return ;	
		}
		else if((temp.telPre!=""||temp.telSuf!="")&&(temp.telPre=="" ||temp.telPre.length<3||temp.telSuf=="" ||temp.telSuf.length!=4))
		{
			"유선전화번호를 정확히 입력하세요".alert();	
			return ;	
		}
		else if(temp.telPre==""&&temp.telSuf==""&&temp.mobilePre==""&&temp.mobileSuf=="")
		{
			"유선전화번호나 휴대전화번호 둘 중 하나는 입력해야합니다.".alert();
			return ;
		}
		else if($("#messaging").prop("checked") && (temp.mobilePre=="" || temp.mobileSuf=="")) //SMS 수신 체크시 휴대전화번호 필수
		{
			"SMS 수신 동의시 휴대전화번호 입력은 필수입니다.".alert();
			return ;
		}
		//신청성에 등록된 신청인이 하나도 없고, 대표자 지정이 되어있지 않은 경우, 강제로 대표자 지정 
		if(!applicant.toArray().length && !$("#reprsntYn").is(":checked"))
		{
			$("#reprsntYn").trigger("click");
		}
			
		temp.reprsntYn = $("#reprsntYn").is(":checked");
		temp.prmisnSeq=$("input[name=prmisnSeq]").val();
		temp.agentYn=false;
		
		//00.02  법인  validation check
		if($("#dialog #type").val() == "corperation")
		{
			if(temp.presidentNm == "" || temp.presidentNm == undefined)
			{
				"대표자명을 입력하세요.".alert();
				$("#presidentNm").focus();
				return ;
			}
			if(temp.coRgstNo == "" || temp.coRgstNo == undefined ||  temp.coRgstNo.length!=13)
			{
				"법인등록번호를 입력하세요".alert();
				$("#coRgstNo").focus();
				return ;
			}
			
			temp.identifyNo =temp.coRgstNo;/*법인일 경우 법인등록번호를 identifyNo로 setting*/
		}
		else if (temp.identifyNo == ""|| temp.identifyNo.length!=8)/*개인일 경우, 생년월일 check*/ 
		{
			"생년월일을 입력하세요.".alert();
			$("#identifyNo").focus();
			return ;
		}

		//개인의 경우 생년월일 정상 값 check
		if($("#dialog #type").val() == "person" && !dateVailidationCheck($("#identifyNo").val()))
		{
			"정상적인 생년월일을 입력하세요.".alert();
			$("#identifyNo").focus();
			return;
		}
		//신청인을 최초 등록하고, 대표자지정이 체크되 있지 않는 경우, 강제로 대표자 지정 체크
		if(!applicant.toArray().length && !$("#reprsntYn").is(":checked")){
			$("#reprsntYn").trigger("click");
		}
		else if(applicant.toArray().length>0 &&$("#reprsntYn").is(":checked"))
		{//대표자로 지정되있고 등록된 신청인이 있을때,
			//신청서에 등록된 신청인 모두 대표자가 아니게 setting
			applicant.each(function(index, value){
				value.reprsntYn = false;
			});
		}
			
		if($("#dialog #type").val() != "corperation")//개인의 경우
		{
			var compareTemp = true;
			applicant.each(function(index, value)
			{
				var appTemp = value.appNm;
				if(appTemp == temp.appNm){
					modalPop.dialog('close');
					"동일 이름의 신청인은 추가할 수 없습니다. 기존 신청인 삭제 후 진행해 주세요.".alert();
					compareTemp = false;
				}
			});
			if(!compareTemp)
			{	
				return false;
			}
	 	}
		
		if($("#reprsntYn").is(":checked"))
		{
			applicant.unshift(temp);
			/* 신청인과 대리인이 동일인일 때 */
			if($("#chkSelf").is(":checked"))
			{
				$("#agent").empty();
				var temp2 = fnClone(temp)
				temp2.agentYn=true;
				agent.push(temp2);
			}
		} 
		else 
		{
			applicant.push(temp);	
		}
		
		if(userType != 'DAU000010' && userType != 'DAU000020') {
			if($("input[name=prmisnSeq]").val() != null && $("input[name=prmisnSeq]").val() != ""){
				var param = applicant.array;
				doAjaxSubmit(contextBase + "minwonmgmt/insertListTnReqstCpttr.json", JSON.stringify(param),"json","json","fnSaveApplicantCallback");
			}
		}
		$("#selectUserForm input").prop('disabled', true);
		modalPop.dialog('close');	
	}
}
function fnSaveApplicantCallback(response){
	//debugger;
	if(response.result == "SUCCESS"){
		applicant.array = response.list;
	}else {
		"신청인/대리인 정보 저장 실패".alert();
	}
}
function fnTypeChange(){
	if($("#dialog #type").val() == "person"){/*개인*/
		$(".appNmTh").html("성명<p style='color: red; display:inline;'>&#xFF0A;</p>");
		$(".presidentNmTd").hide();
		$(".appNmTd").attr("colspan","3");
		$(".appNmTd input").removeClass("w94");
		$(".appNmTd input").addClass("w48");
		

		$(".identifyNoTh").show();
		$(".identifyNoTd").show();
		$(".coRgstNoTd").hide();
		$(".identifyNoTd").attr("colspan","3");
	}
	else if($("#dialog #type").val() == "corperation"){/*법인*/
		$(".appNmTh").html("법인명<p style='color: red; display:inline;'>&#xFF0A;</p>");
		$(".presidentNmTd").show();
		$(".appNmTd").attr("colspan","1");
		$(".appNmTd input").addClass("w94");
		$(".appNmTd input").removeClass("w48");
		
		$(".identifyNoTh").hide();
		$(".identifyNoTd").hide();
		$(".coRgstNoTd").show();
		$("td.coRgstNoTd").attr("colspan","3");
	}
}


/*date => yyyymmdd, yyyy-mm-dd, yyyy/mm/dd, yyyy.mm.dd 날짜 형식 맞나 체크*/
function dateVailidationCheck(date)
{
	date = date.replace(/-/gi,"").replace(/\//gi,"").replace(/\./gi,"");
	
	if(date.match(/[0-9]{8}/g))
	{
		var _year = Number(date.substring(0,4));
		var _month = Number(date.substring(4,6));
		var _date = Number(date.substring(6,8));
		var _dateArr = [null,31,29,31,30,31,30,31,31,30,31,30,31];
		
		if(_month>0&&_month<13)
		{
			if(_date>0&& _date<(_dateArr[_month]+1))
			{
				if(_month==2)
				{
					var d = new Date(_year,_month,_date);
					if(_date==d.getDate())
					{
						return true;
					}
					return false;
					
				}
				return true;
			}
			return false;
		}
		return false;
	}
	return false;
}
</script>
<style>
input[type=checkbox],
input[type=radio   ]{
  vertical-align: middle;
  margin: 0px;
}
input[type=text   ]{
	margin-top: 1px;
}
.dropper-dropzone{
	width:97%;
	font-size: 12px;
}
.wrapDesign .simpleTable2 th{
	text-align: left;
}
.mr15 {margin-right: 15px;}
</style>
</head>
<body>
	<div id="dialog" class="wrapDesign_2">
		<div class="topAreaPopup">
		    <i class="axi axi-ion-person-add titleIcon"></i>
		    <span class="sectionSubject"><c:out value="${title}" /></span>
		    <span class="sectionDesc" style="padding-left:10px;"> 개발행위허가 관련 민원처리의 <c:out value="${title}" />를 합니다.</span>
	    </div>
	    <div class="dialogContent">
	    	<form id="selectUserForm">
				<table id="selectUserPop" class="simpleTable2" style="border-top: none; border-right: none; border-left: none; border:0; ">
					<colgroup>
						<col style="width:10%"/>
						<col style="width:15%"/>
						<col style="width:27%"/>
						<col style="width:23%"/>
						<col style="width:20%"/>
					</colgroup>
					<tbody>
						<tr>
							<th rowspan="7" valign="top">
								<select id="type" style="margin-top: 3px;height: 26px; width:100%; background: #fff url(../images/select_bg.png)no-repeat 95% 60%;" onChange="fnTypeChange();">
									<option value="person" selected="selected">개인</option>
									<option value="corperation">법인</option>
								</select>
							</th>
							<th class="appNmTh">성명<p style="color: red; display:inline;">&#xFF0A;</p></th>
							<td class="appNmTd"><input type="text" id="appNm" name="appNm" class="w94"></td>
							<th class="presidentNmTd">대표자명<p style="color: red; display:inline;">&#xFF0A;</p></th>
							<td class="presidentNmTd"><input type="text" id="presidentNm" name="presidentNm" class="w94"></td>
						</tr>
						<tr>
					  		<th class="identifyNoTh">생년월일<p style="color: red; display:inline;">&#xFF0A;</p></th>
					  		<td class="identifyNoTd" ><input type="text" id="identifyNo" name="identifyNo" class="w48" placeholder="생년월일 8자리(ex 19911205)" maxlength="8" onkeyup="fnOnKeyUp(event);"> </td>
					  		<th class="coRgstNoTd">법인등록번호<p style="color: red; display:inline;">&#xFF0A;</p></th>
					  		<td class="coRgstNoTd"><input type="text" id="coRgstNo" name="coRgstNo"  class="w48" maxlength="13" onkeyup="fnOnKeyUp(event);" placeholder="법인등록번호 13자리 "> </td>
						</tr>
						<tr>
							<th>주소<p style="color: red; display:inline;">&#xFF0A;</p></th>
							<td colspan="3">
							<Button class="button small gray W100" onclick="fnSearchStreetAddr(); return false;" style="height: 26px;">주소찾기</Button>
							<input type="text" id="rdnmadr" name="rdnmadr" class="w66"><br><br>
							<span class="in_blk" style="margin: 0 27px;">추가주소</span>
							<input type="text" id="rdnmadrDetail" name="rdnmadrDetail" class="w65" placeholder="추가주소">
							</td>
						</tr>
						<tr>
							<th>E-mail</th>
							<td colspan="3"><input type="text" id="txtEmail" name="emailId" class="W100" onkeyup="fnOnKeyUpEmail(event);" maxlength="30"> @<input type="text" id="txtEmailDomain" name="emailDomain" disabled="disabled" class="W100" onkeyup="fnOnKeyUpDomain(event);" maxlength="30">
								<select id="selEmailDomain" style="height: 26px; vertical-align:bottom;">
									<option value="">선택하세요</option>
								<option value="daum.net">daum.net</option>
								<option value="chol.com">chol.com</option>
								<option value="gmail.com">gmail.com</option>
								<option value="hotmail.com">hotmail.com</option>
								<option value="korea.kr">korea.kr</option>
								<option value="nate.com">nate.com</option>
								<option value="naver.com">naver.com</option>
								<option value="custom">직접입력</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>유선전화번호</th>
							<td colspan="3">
							<select name="telArea" style="width: 80px;">
								<option value="02" selected>02</option>
								<option value="031" >031</option>
								<option value="032" >032</option>
								<option value="033" >033</option>
								<option value="041" >041</option>
								<option value="042" >042</option>
								<option value="043" >043</option>
								<option value="044" >044</option>
								<option value="051" >051</option>
								<option value="052" >052</option>
								<option value="053" >053</option>
								<option value="054" >054</option>
								<option value="055" >055</option>
								<option value="061" >061</option>
								<option value="062" >062</option>
								<option value="063" >063</option>
								<option value="064" >064</option>
								<option value="070" >070</option>
							</select>-
							<input name="telPre" id="telPre" type="text" style="width: 80px;" maxlength="4" onkeyup="fnOnKeyUp(event);">-
							<input name="telSuf" id="telSuf" type="text" style="width: 80px;" maxlength="4" onkeyup="fnOnKeyUp(event);">
							<!-- <input type="text" id="telPre" name="telPre" class="w10" maxlength="4" onkeydown="return showKeyCode(event);"/>-<input type="text" id="telSuf" name="telSuf" class="w10" maxlength="4" onkeydown="return showKeyCode(event);"/> -->
							</td>
						</tr>
						<tr>
							<th>휴대전화번호<p style="color: red; display:inline;">&#xFF0A;</p></th>
							<td colspan="3">
							<select name="mobileArea"  style="width: 80px;">
								<option value="010" selected>010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
								<option value="019">019</option>
							</select>
							-
							<input name="mobilePre" id="mobilePre"  type="text" style="width: 80px;" maxlength="4" onkeyup="fnOnKeyUp(event);">-
							<input name="mobileSuf" id="mobileSuf" type="text" style="width: 80px;" maxlength="4" onkeyup="fnOnKeyUp(event);">
							<!-- <input type="text" id="mobilePre" name="mobilePre" class="w10" maxlength="4" onkeydown="return showKeyCode(event);"/>-<input type="text" id="mobileSuf" name="mobileSuf" class="w10" maxlength="4" onkeydown="return showKeyCode(event);"/> -->
							/ <label><input type="checkbox" class="chkAgreed" name="smsRtYn" checked value="true" id="messaging"> SMS 수신</label></td>
						</tr>
						<tr>
							<th>개인정보 활용<p style="color: red; display:inline;">&#xFF0A;</p></th>
							<td style="border-right: 0px;">
								<label><input type="radio" name="chkInfoAgree" checked="checked" value="chkInfoAgree"> 동의함</label>
								<input type="hidden" id="userSeq" name="userSeq">
							</td>
							<td colspan="2">
								<label><input type="radio" name="chkInfoAgree" value="chkInfoDisagree"> 동의안함</label>
							</td>
						</tr>
					</tbody>
				</table>
				<div id="delegationType" style="width:100%; padding-top: 10px; display:none;">
					<p id="delegationTypeTitle2" class="tableHeaderBar roundBoxBG titleCell_line" style="height:30px;">
						<span class="text_white text_14 text_sh">대리인 권한 선택</span>
					</p>
					<p style="height: 50px;padding-top:10px;">
						<button id="btnLimited" onclick="delegationTypeSelected('0'); return false;" style="min-width:360px;" class="button floatLeft grayBlue"><span class="text_16"><i class="axi axi-ion-person text_24"></i> 한정 위임</span></button>
						<button id="btnAll" onclick="delegationTypeSelected('1'); return false;" style="min-width: 360px;" class="button floatRight grayBlue"><span class="text_16"><i class="axi axi-ion-person-add  text_24"></i> 포괄 위임</span></button>
					</p>
					<p id="descLimited" class="text_20" style="margin: 0 auto;padding: 7px; width: 98%; background: #ffda95; margin-bottom: -9px;">
						<span style="color: #2e72a2;line-height: 16px;">[<span style="color:red">한정위임</span>]은 본 개발행위허가 민원신청 건에 대한 권한만 위임되며 허가 후 발생되는 준공신청 및 후속민원에 대한 권한은 지속되지 않습니다.</span>
					</p>
					<p id="descAll" class="text_20" style="margin: 0 auto; padding: 7px; width: 98%; background: #ffda95; margin-bottom: -9px;">
							<span style="color: #2e72a2;line-height: 16px;">[<span style="color:red">포괄위임</span>]은 본 개발행위허가 민원신청 건과 허가 후 발생되는 준공신청 및 모든 후속민원이 종결될때까지 권한이 위임됩니다.</span>
						</p>
					<%-- <table style="width:99%; height:50px" class="divFileTable">
						<tr>
							<th  style="text-align:left; width:25;">
                                     <span class="text_13 text_sh"><i class="axi axi-attach-file text_18"></i> 위임장 첨부</span>
                                     </th>
							<td style="background:#F1F1EF; border:1px solid #ddd; width:75%;">
								<form action="#" class="w98 h98">
									<div id="deligationFilesOnPop">
										<ol id="deligationFileList"></ol>
									</div>
								</form>
							</td>
						</tr>
					</table> --%>
				</div>
			</form>
			<div class="inBox2" style="height:60px; margin-top:20px;" >
				<div id="divDelegate" style="padding-bottom:10px;float: left;line-height: 39px;"><label><input type="checkbox" id="reprsntYn"> 대표자 지정 </label></div>
				<div style="text-align:right">
					<button onClick="save(${isAgent}); return false;" id="saveBtn" class="button blue02"><span class="text_16"><i class="axi axi-ion-checkmark-circled"></i> 저장</span></button>
			  		<button onclick="modalPop.dialog('close'); return false;" class="button grayBlue"><span class="text_16"><i class="axi axi-ion-close-circled"></i> 닫기</span></button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
