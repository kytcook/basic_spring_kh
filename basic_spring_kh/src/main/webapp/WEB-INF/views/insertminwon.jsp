<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="egovframework.rte.daps.usermgmt.vo.TnUpisUserVo,org.springframework.security.core.context.SecurityContextHolder" %>
<% TnUpisUserVo user = (TnUpisUserVo)SecurityContextHolder.getContext().getAuthentication().getDetails(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>개발행위허가 신청</title>
<script type="text/javascript">
var contextBase = "${pageContext.request.contextPath}/";
var layeredPop;
var applicant = new handleableArray();
var agent = new handleableArray();
var tmpAgent = new handleableArray();
var jibun = new handleableArray();
var fileList = new Array();
var droppers = new Array();
var changeSave = false;
var bfLNDCGR = "";
var bfSPFC = "";
var bfSPCFC= "";
var seq;
var reqstType = "<c:out value='${reqstType}'/>";
var vMountProg; //산지상태값
var vMountPayYn; //산지결제여부
var vSiteCode;  //산지 오픈지자체 확인용 값 추후 전체 오픈시 삭제 예정
var commissionBak = "";
var userType = "<%=user.getUserType()%>";
var loginUserId = "<%=user.getUserId()%>";
var userSeq = "<%=user.getUserSeq()%>";
var farmPayYn; //농지결제여부
var reCheckComplementResult = ""; // 서류보완 중일 때 업무시스템에서 보완요청 취소하였을 경우 확인

$(document).ready(function(){ 
	seq = "<c:out value='${seq}'/>"
	if(seq!="")
	{
		$("#btSubmit").show();//임시저장 이후에만 신청버튼 활성화
// 		$("#payInfoList").html("");
		//결제 정보가 있으면 payInfoTb 영역 활성화
		setTimeout(function(){
			$.ajax({
				type:"POST"
				,async:false
				,url:contextBase + "minwonmgmt/selectPayList.json"
				,dataType:"json"
				,data:"prmisnSeq=" + seq+"&prmisnType=DAB000010"
				,success: function(result) 
				{	
					if(result.resultCode=="SUCCESS")
					{
						var payList = result.payList;
						if(payList.length!=0)
						{
							$(".payInfoTb").css("display","");
							for(var pi=0; pi<payList.length ; pi++)
							{
								var html = "";
								var item = payList[pi];
								html+=	  "<tr>"
											+"<td>"+item.RNUM+"</td>"
											+"<td>"+item.REQ_FIN_DTIME+"</td>"
											+"<td>"+item.PAY_MTHD+"</td>"
											+"<td style='font-weight: bold; color:red; text-align:right;'>"+item.PAY_SUM+"</td>"
											+"<td style='font-weight: bold; color:red; text-align:right;'>"+item.PAY_SUM_COM+"</td>"
											+"<td>"+item.PAY_USER+"</td>"
											+"<td style='font-weight: bold; color:red;'>"+item.IS_SUCCESS+"</td>"
										 +"</tr>";
								$("#payInfoList").append(html);
								farmPayYn = item.IS_SUCCESS;
							}
						}
					}
					else
					{
						"결제정보 조회중 오류가 발생하였습니다.".alert();
					}
				}
				,error : function(xhr,status,error)
				{
					"결제정보 조회중 오류가 발생하였습니다.".alert();
				}
			});
		}, 500);
	}
	else// 신규등록 페이지 인허가 신청 전
	{
		if(userType == 'DAU000020') {
			$("#btAddThisAgent").show();//대리인 추가 버튼 활성화	
		}
	}
	
	//대리인일 경우에만 신청인 임의 등록 가능하게
	if(userType!="DAU000020")
	{
		$("#reqstAddApplicant").hide();
	}
	
	if(location.href.includes(".pop")){
		$("section.wrapDesign").css("margin","65px auto 10px auto");
	}
	/* 2019-04-04 공지사항 */
	if(new Date().format("YYYYMMDDhhmm") >= "201904040001" && new Date().format("YYYYMMDDhhmm") <= "201904301800"){
	 	if(getCookie("upisPollnotToday")!="Y"){
			fnShowpPop();
		} 
	}
	
	setTimeout(function(){
		fnSpanCheckShowHide();
	}, 500);
	

	applicant.getReprsnt = function(){
		var reprsnt;
		applicant.each(function(i,v){
			if(v.reprsntYn){
				reprsnt = v; return true;
			}
		});
		return reprsnt;
	}

	applicant._keys = ["appNm","presidentNm", "identifyNo", "rdnmadr", "rdnmadrDetail"];
	agent._keys = ["diInpYn", "appNm", "cprYn", "identifyNo", "presidentNm", "rdnmadr", "rdnmadrDetail", "emailId", "emailDomain", "userSeq", "telArea", "telPre", "telSuf", "mobileArea", "mobilePre", "mobileSuf", "reprsntYn", "agentYn", "smsRtYn", "agentSeq", "fileDtlSeq", "fileRealNm", "fileExt"];
	jibun._keys = ["ladPnu"];
	applicant.change(function(index, data){
		var tr = "<tr>" +
					"<td ><input style='width:45px;' type='text' class='w98 applicant reprsntYn' disabled/></td>" +
					"<td><p class='applicant index'></p></td>" +
					"<td><input type='text' class='w98 applicant name' disabled/></td>" +
					"<td><input type='text' class='w98 applicant num' disabled/></td>"+
					"<td><input type='text' class='w98 applicant addr' disabled /></td>" +
					"<td><input type='text' class='w98 applicant mobile' disabled /></td>" +
				 "</tr>";
		if(index == 0) 
		{
			$("#applicant").empty();
		}
		$("#applicant").append(tr);
		tr = $("#applicant tr")[index];
		$(tr).find(".reprsntYn").val(data.reprsntYn?"대표":"");
		$(tr).find(".index").text(index + 1);
		$(tr).find(".name").val(fnNvl(data.appNm));
		$(tr).find(".num").val(fnNvl(data.identifyNo));
		$(tr).find(".addr").val(fnNvl(data.rdnmadr) + " " + fnNvl(data.rdnmadrDetail));
		
		if(data.mobileArea!="" &&data.mobilePre!=""&&data.mobileSuf!="")
		{
			if(data.mobilePre==""||data.mobilePre==null||data.mobilePre==undefined)
			{
				$(tr).find(".mobile").val("-");	
			}
			else
			{
				$(tr).find(".mobile").val(fnNvl(data.mobileArea).toString().lpad(3,"0") + "-" +fnNvl(data.mobilePre) + "-" + fnNvl(data.mobileSuf).toString().lpad(4,"0"));
			}	
		}
		else
		{
			$(tr).find(".mobile").val("-");
		}
		
		$("#applicant tr").on("click", function(){
			$("#applicant tr.highlight").removeClass("highlight");
			$(this).addClass("highlight");
		});
	});
	agent.change(function(index,data){
		var tr = "<tr>" +
					"<td><input type='text' class='w98 agent reprsntYn' disabled/></td>" +
					"<td class='center'><p class='agent index'></p></td>" +
					"<td><input type='text' class='w98 agent agentBizNm' disabled/></td>" +
					"<td><input type='text' class='w98 agent agentNm' disabled/></td>" +
					"<td><input type='text' class='w98 agent num' disabled/></td>" +
					"<td><input type='text' class='w98 agent addr' disabled/></td>" +
					"<td><input type='text' class='w98 agent tel' disabled/></td>" +
				 "</tr>";
	 	if(index == 0) {
			$("#agent").empty();
		}
		$("#agent").append(tr);
		tr = $("#agent tr")[index];
		$(tr).find(".reprsntYn").val(data.reprsntYn?"대표":"");
		$(tr).find(".index").text(index + 1);
		$(tr).find(".agentBizNm").val(fnNvl(data.appNm));
		$(tr).find(".agentNm").val(fnNvl(data.presidentNm));
		$(tr).find(".num").val(((data.identifyNo!=null && data.identifyNo!=undefined&& data.identifyNo!=""&& (data.identifyNo.length==13||data.identifyNo.length==8))?fnNvl(data.identifyNo):''));
		$(tr).find(".addr").val(fnNvl(data.rdnmadr) + " " + fnNvl(data.rdnmadrDetail));
		if(data.telArea!="" &&data.telPre!=""&&data.telSuf!="")
		{
			if(data.telPre==""||data.telPre==null||data.telPre==undefined)
			{
				$(tr).find(".tel").val("-");
			}
			else
			{
				$(tr).find(".tel").val(fnNvl(data.telArea) + "-" +fnNvl(data.telPre) + "-" + fnNvl(data.telSuf).toString().lpad(4,"0"));
			}	
		}
		else
		{
			$(tr).find(".tel").val("-");
		}
		
		$("#agent tr").on("click", function(){
			$("#agent tr.highlight").removeClass("highlight");
			$(this).addClass("highlight");
		});
	});

	////////////////////////////////////////////////////////////////////////23.01.06 TESTING
	function isNumberKey(event) {
		$(event.target).val($(event.target).val().replace(/[^0-9]/g,''));
	}
	///////////////////////////////////////////////////////////////////////////	
	
	jibun.change(function(index, data){
		if(index == 0) {
			$(".jibunInfo").remove();
		}
		if(jibun.toArray().length == 1){
			data.reprsntYn = true;
		}
		$("#rowSpanner").attr("rowspan", index + 4);
		$("#rowSpannerJibun").attr("rowspan", index + 3);
		var tr ="<tr class='jibunInfo'>" +
			"<td class='jibun'></td>" +
					"<td class='reqstAr'></td>" +
					/* "<td class='percent'></td>"+ */
					"<td class='LNDCGR'>&nbsp;</td>" +
					"<td class='SPFC'>&nbsp;</td>" +
					"<td class='SPCFC'>&nbsp;</td>" +
				"</tr>";
		/*
			LNDCGR = 지목
			SPFC = 용도지역
			SPCFC = 용도지구
		*/
		$("#jibunTbody").append(tr);
		tr = $("#jibunTbody tr")[index + 3];
		$(tr).find(".reqstAr").append(fnAddCommas(fnNvl(data.reqstAr)));
		//전체 주소 보여주기 20211109 추가 아직 반영 안함
		$(tr).find(".jibun").text((data.reprsntYn?"대표":"외 " + parseInt(index)) + "    " + data.ladAddrPre + " " + data.ladAddrSuf);
		
		//산지 오픈 사이트 코드 확인용 추후 전체 오픈시 삭제 예정
		vSiteCode = data.ladPnu.substr(0,5);
		
		//$(tr).find(".jibun").text((data.reprsntYn?"대표":"외 " + parseInt(index)) + "    " + data.ladAddrSuf);
		/* $(tr).find(".percent").text(data.percent + "%"); */
		$(tr).find(".LNDCGR").text(data.lndcgrNm);
		$(tr).find(".SPFC").text(data.spfcNm);
		$(tr).find(".SPCFC").text(data.spcfcNm);
		$(".jibunInfo").on("click", function(){
			$(".jibunInfo.highlight").removeClass("highlight");
			$(this).addClass("highlight");
		});
		
		
		/* 지번별 토지분할 */
		$("#divP").empty(); // divP가 비어있다
		$("#divS").empty();
		jibun.each(function(i,v){ //  i와 v는 어디서 가져오는 거지??
				console.log("v넌 뭐냐" + v);
			var blank = "";
			for(count=0; count < (9-v.ladAddrSuf.length); count++){// v.ladAddrSuf.length
				blank += "&nbsp;";
			}
			
			var $p = $("<p/>");
			$p.addClass("division");
			var $input = $("<input/>");
			$input.attr({
				"type":"text",
				"class":"w80",
				"placeholder":"숫자"
			});
			$p.append(v.ladAddrSuf + " : " + blank).append($input).append(" ㎡");
			$input.val(fnAddCommas(fnNvl(v.divP)));
			$input.on("keydown keyup keypress change", function(event){
		 		if(!isNumberKey(event)) {
					return false;
				} else {
					v.divP = $(event.target).val().replace(/\,/g,'');// /찾을 문자열, /g(전체 문자열 변경)  ,는 빈공백으로 전환
				}  
			});
			$("#divP").append($p);
		    $("#divP").attr("style","text-indent:0px;");
		    
			var $p = $("<p/>");
			$p.addClass("division");
			var $input = $("<input/>");
			$input.attr({
				"type":"text",
				"class":"w80"
			});
			$p.append(v.ladAddrSuf + " : " + blank).append($input);
			$input.val(fnNvl(v.divS));
			$input.on("keydown keyup keypress change", function(event){
				v.divS = $(event.target).val().replace(/\,/g,'');
			});
			$("#divS").append($p);
			$("#divS").attr("style","text-indent:0px;");
		});
		
		if($("#chkDivision").is(":checked")) {
			$("#divP").show();
			$("#divS").show();
		} else {
			$("#divP").hide();
			$("#divS").hide();
		}
	});
	if("<c:out value='${reqstType}'/>" == "DUR000080") 
	{
		$("#reqstSelect").remove();//신청인 선택
		$("#reqstAddApplicant").remove();//신청인 임의등록
		$("#reqstAdd").remove();//신청인 추가
		$("#reqstDel").remove();//신청인 삭제
		$("#appointReprsntYn").remove();//신청인대표지정
		
		$("#agentReprsntYn").remove();//대리인대표지정
		$("#btFindAddr").remove();//주소찾기
		$("#jibunTbody button[name!=btViewPosition]").hide();//지번 수정버튼영역
		
		$("input,select").prop("readonly","readonly");
		$(".bottom_btn button:not(#btComplement)").remove();
	} else {
		$("#btComplement").remove();
	}
	
	if(userType != null) {
		if(userType == 'DAU000010') {
			// 사용자 구분이 일반일 경우
			$("#reqstSelect").remove();
			if(seq) {
				doAjaxSubmit(contextBase + "minwonmgmt/selectPrmisnDetail.json", JSON.stringify({"prmisnSeq":seq}), "json", "json", "fnSetDatas" );
				doAjaxSubmit(contextBase + "minwonmgmt/selectListPrmisnLadInfo.json", {"prmisnSeq":seq}, "json", "html", "fnSetJibunDatas");
				doAjaxSubmit(contextBase + "minwonmgmt/selectListCpttr.json", {"prmisnSeq":seq}, "json", "html", "fnSetCpttrDatas");
				// 2019-11-01 대리인 조회(TN_AGENT_CPTTR_PROC_DTLS 조회)
				doAjaxSubmit(contextBase + "minwonmgmt/selectListAgentCpttrProcDtls.json", {"prmisnSeq":seq}, "json", "html", "fnSetUserAgentDatas");
			} else {
				fnSetLoggedInUser();
				$("input[name=agendaFilesChkBox]").on("click",fnAgendaChk);
			}
		} else if(userType == 'DAU000020'){
			// 사용자 구분이 대리인일 경우
			$("#reqstAdd").remove();
			if(seq) {
				doAjaxSubmit(contextBase + "minwonmgmt/selectPrmisnDetail.json", JSON.stringify({"prmisnSeq":seq}), "json", "json", "fnSetDatas" );
				doAjaxSubmit(contextBase + "minwonmgmt/selectListPrmisnLadInfo.json", {"prmisnSeq":seq}, "json", "html", "fnSetJibunDatas");
				doAjaxSubmit(contextBase + "minwonmgmt/selectListCpttr.json", {"prmisnSeq":seq}, "json", "html", "fnSetCpttrDatas");
				// 2019-11-01 대리인 조회(TN_AGENT_CPTTR_PROC_DTLS 조회)
				doAjaxSubmit(contextBase + "minwonmgmt/selectListAgentCpttrProcDtls.json", {"prmisnSeq":seq}, "json", "html", "fnSetUserAgentDatas");
			} else {
				$("input[name=agendaFilesChkBox]").on("click",fnAgendaChk);
			}
		}
		
	}
	
	<%-- $("#mwContent").append("<input type=\"hidden\" name=\"createUserSeq\" value=\"<%=user.getUserSeq()%>\"/>"); --%>
	
	/* DatePicker 선언 */
	openDatepickerWithTerm('txtHeapFrom', 'txtHeapTo');
	openDatepickerWithTerm('txtConstructionStart', 'txtConstructionEnd');
	
	/* CheckBox Action 선언*/
	$(".handicraft, .transformation, .collection, .division, .heap").parent().parent().find(":not(.mainTh img, .mainTh)").hide();
	
	/* 공작물 */
	$("#chkHandicraft").change(function(){
		if($("#chkHandicraft").is(":checked")) {
			$(".handicraft").parent().parent().find(":not(.mainTh img, .mainTh)").show();
		} else {
			$(".handicraft").parent().parent().find(":not(.mainTh img, .mainTh)").hide();
		}

		fnSpanCheckShowHide();
	});
	
	/* 토지 형질 변경 */
	$("#chkTranformation").change(function(){
		if($("#chkTranformation").is(":checked")) {
			$(".transformation").parent().parent().find(":not(.mainTh img, .mainTh)").show();
		} else {
			$(".transformation").parent().parent().find(":not(.mainTh img, .mainTh)").hide();
		}

		fnSpanCheckShowHide();
	});
	
	/* 토석채취 */
	$("#chkCollection").change(function(){
		if($("#chkCollection").is(":checked")) {
			$(".collection").parent().parent().find(":not(.mainTh img, .mainTh)").show();
		} else {
			$(".collection").parent().parent().find(":not(.mainTh img, .mainTh)").hide();
		}

		fnSpanCheckShowHide();
	});
	
	/* 토지분할 */
	$("#chkDivision").change(function(){
		if($("#chkDivision").is(":checked")) {
			$(".division").parent().parent().find(":not(.mainTh img, .mainTh)").show();
			$("#divP").show();
			$("#divS").show();
		} else {
			$(".division").parent().parent().find(":not(.mainTh img, .mainTh)").hide();jibun.each(function(i,v){v.divP = ""; v.divS = "";});jibun.each(jibun.change);
			$("#divP").hide();
			$("#divS").hide();
		}

		fnSpanCheckShowHide();
	});
	
	/* 물건 적치 */
	$("#chkHeap").change(function(){
		if($("#chkHeap").is(":checked")) {
			$(".heap").parent().parent().find(":not(.mainTh img, .mainTh)").show();
		} else {
			$(".heap").parent().parent().find(":not(.mainTh img, .mainTh)").hide();
		}
		fnSpanCheckShowHide();
	});
	
	/* IE 9 이하 PostData 작동불가 */
	if(getBrowser().startsWith("MSIE") && typeof FormData == "undefined"){
		/* IE 9 이하 파일 업로드 */
		$("td div[id*=Files]").has('ol').each(function(index, value){
			var _fileType = "09";
			switch($(value).attr("id")){
			case "ownerShipFiles":
				_fileType = "00";
				break;
			case "constructionFiles":
				_fileType = "01";
				break;
			case "planFiles":
				_fileType = "02";
				break;
			case "structureFiles":
				_fileType = "03";
				break;
			case "budgetFiles":
				_fileType = "04";
				break;
			case "landscapeFiles":
				_fileType = "05";
				break;
			case "deligationFiles":
				_fileType = "06";
				break;
			case "etcFiles":
				_fileType = "09";
				break;
			}
			droppers.push({files:[],postData:{fileType:_fileType},$dropper:$(value), total:0});
			var form = $(value).parent();
			var fileType = $("<input type='hidden' name='fileType' value='" + _fileType + "'/>");

			$(value).append(fileType);
			var fileGroupSeq = $("<input type='hidden' name='fileGroupSeq' value='" + $("#mwContent input[name='fileGroupSeq']").val() + "' />");
			$(value).append(fileGroupSeq);
			
			// 대리인 위임장의 경우
			if (_fileType == "06") {
				var agentSeqInfo = $("<input type='hidden' name='agentSeqInfo' value=''/>");
				$(value).append(agentSeqInfo);
			}
			
			var button = $("<button style='float:right;margin-left:-85px;' class='button white' onclick='return false;'>파일찾기</button>");
			var file = $("<input type='file' name='file'>");
			file.css({
				"z-index":"100",
				"width":"85px",
				"height":"30px",
				"opacity":"0",
				"float":"right"
			});
			$(value).append(button);
			$(value).append(file);
			
			file.on("change", function(){
				
				
				// 업로드전 fileGroupSeq 생성
				fnCreateFileGroupSeq();
				fnDroppersSetFileGroupSeq();

				var frameNm = "tempFrame" + parseInt(Math.random()*100000).toString().lpad("0",5);
				var fileNm = file.val().split("\\").pop();
				$(value).find("ol").append("<li class=\"fileListItem\" ><a>" + fileNm + "<button class='button flat' ><i class=\"axi axi-close\"></i></button></a></li>");

				// 대리인 위임장의 경우
				if (_fileType == "06") {
					var _agentSeq = "";
					agent.each(function(idx){
						if (idx == 0) {
							_agentSeq = this.agentSeq;
						} else {
							_agentSeq += "," + this.agentSeq;
						}
					});
					$(value).find("input[name=agentSeqInfo]").val(_agentSeq);
				}

				var iframe = $("<iframe/>").attr("name",frameNm);
				iframe.css({
					"position":"absolute",
					"left":"-1000",
					"top":"-1000"
				});
				iframe[0].onload = function(){
					
					var data;
					try{
						data = $.parseJSON(iframe.contents().text());
					}catch(err) {
						"파일 전송 실패".alert();
						$($(value).find("ol li")[$(value).find("ol li").length]).remove();
						iframe.remove();
						return false;
					}
					if(data.tnCmnMsgVo.smsgCd == "SUCCESS") {
						$("input[name='fileGroupSeq']").val(data.fileGroupSeq);
						$($(value).find("ol li")[$(value).find("ol li").length-1]).find("a").attr({"href":contextBase + "cmnmgmt/fileDownload.do?fileDtlSeq=" + data.fileDtlSeq, "download":data.fileRealNm + "." + data.fileExt, "target":"_blank", "File-Seq":data.fileDtlSeq});
						$($(value).find("ol li")[$(value).find("ol li").length-1]).find("a button.button.flat").attr("onclick", "fnFileDelete(" + data.fileDtlSeq + ");return false;");

						/*$(droppers).each(function(i,v){
							v.postData.fileGroupSeq = data.fileGroupSeq;
						});*/
					} else {
						"파일 전송 실패".alert();
					}
					iframe.remove();
				};
				$("body").append(iframe);
				form.attr({
					"action" : contextBase + "cmnmgmt/uploadFiles.json",
					"enctype" : "multipart/form-data",
					"target" : frameNm,
					"method" : "POST"
				});
				
				form.submit();
				
				$(this).wrap('<form>').closest('form').get(0).reset();
				
			});
		});
	} else {
		/* File Upload Dropper 선언*/
		$("td div[id*=Files]").has('ol').each(function(index, value){
			var _fileType = "09";
			var _agentSeq = "";					// 대리인 위임장의 경우
			var _dropzoneMesg = "";				// 대리인 위임장의 경우
			
			switch($(value).attr("id")){
			case "ownerShipFiles":
				_fileType = "00";
				break;
			case "constructionFiles":
				_fileType = "01";
				break;
			case "planFiles":
				_fileType = "02";
				break;
			case "structureFiles":
				_fileType = "03";
				break;
			case "budgetFiles":
				_fileType = "04";
				break;
			case "landscapeFiles":
				_fileType = "05";
				break;
			case "deligationFiles":
				_fileType = "06";
				break;
			case "etcFiles":
				_fileType = "09";
				break;
			}
			
			if (_fileType == "06") {
				_dropzoneMesg = "<span class=\"dropzoneSpan\">여기에 파일을 끌어다놓거나 클릭하세요. 등록 파일은 파일당 15MB로 제한합니다.<br>위임장의 경우 파일명은 <span class=\"boldText\">대리인의 대표자명</span>으로 지정하여야 합니다. (예) 홍길동.pdf</span>";
			} else {
				_dropzoneMesg = "<span class=\"dropzoneSpan\">여기에 파일을 끌어다놓거나 클릭하세요<br>등록 파일은 파일당 15MB로 제한합니다.</span>";
			}
			
			$(value).dropper({
				action: contextBase+"cmnmgmt/uploadFiles.json",
				label: _dropzoneMesg,
				maxSize: 15728640,
				postData: {"fileType":_fileType, "fileGroupSeq":$("input[name='fileGroupSeq']").val()},
			}).on("start.dropper", function(e, files){
				
				// 업로드전 fileGroupSeq 생성
                fnCreateFileGroupSeq();
				fnDroppersSetFileGroupSeq();

				// 대리인 위임장의 경우 - 위임장 대리인 파일명 관련 기능
				if (_fileType == "06" && agent.array.length > 0) {
					agent.each(function(idx){
						if (idx == 0) {
							_agentSeq = this.agentSeq;
						} else {
							_agentSeq += "," + this.agentSeq;
						}
					});
					if (_agentSeq != "") {
						droppers[index].postData.agentSeqInfo = _agentSeq;
					}
				}
				// 대리인 위임장의 경우 - 위임장 대리인 파일명 관련 기능
				
				$(this).find(".dropper-dropzone p").remove();
				if($(this).find(".dropper-dropzone").text().startsWith("여기에")) {
					$(this).find(".dropper-dropzone").text("");
					$(this).find(".dropper-dropzone").append($("<span><button style=\"float:right;\" class=\"button white\">파일찾기</button></span>"));
				}
				for(i = 0; i < files.length; i++) {
					$(this).find("ol").append("<li id = \"" + $(this).attr("id") + "_" + files[i].index + "\" class=\"fileListItem\" style=\"word-break:break-word;\" ><a>" + files[i].name + "<button class='button flat' ><i class=\"axi axi-close\"></i></button></a></li>");
				}
				for(i = 0; i < $(this).find("ol li").length; i++) {
					$(this).find(".dropper-dropzone").append("<p style='height:20px;'></p>").attr("");
				}	
			}).on("fileStart.dropper", function(b, fileInfo){
				
				/* File Tranffering Start */
				$($(this).find("ol li")[fileInfo.index]).append("<div class=\"fileProgressBar\"><div class=\"percentDone\"></div></div>");
			}).on("fileProgress.dropper", function(e, file, percent){
				/* Percentage */
				$($(this).find("ol li")[file.index]).find(".fileProgressBar .percentDone").css("width", "" + percent);
			}).on("fileComplete.dropper", function(e, file, response){
				if(response.tnCmnMsgVo == undefined) {
					response = $.parseJSON(response);
				}
				if (response.tnCmnMsgVo.smsgTypeCd == "ERR") {
					// 대리인 위임장의 경우
					// 업로드 실패시
					if (response.tnCmnMsgVo.smsgBody != "") {
						(response.tnCmnMsgVo.smsgBody).alert();
					} else {
						progress.stop();
						(file.name + " 전송 실패").alert();
					}
					if(!fileList.length) {
						(file.name + " 전송 실패").alert();
						$(this).find("ol li").remove();
						$(this).find(".dropper-dropzone").text("");
						$(this).find(".dropper-dropzone").append($("<span class=\"dropzoneSpan\">여기에 파일을 끌어다놓거나 클릭하세요. 등록 파일은 파일당 15MB로 제한합니다.<br>위임장의 경우 파일명은 대리인의 <b>대표자명</b>으로 지정하여야 합니다. (예) 홍길동.pdf</span>"));
						$(this).find(".dropper-dropzone").append($("<span><button style=\"float:right;\" class=\"button white\">파일찾기</button></span>"));
					} else {
						
						var $id = "#deligationFiles_" + file.index;
						$($(this).find($id)).remove();
					}
				} else {
					// 업로드 성공시
				/*	$.each(droppers, function(i,v){
						v.postData.fileGroupSeq = response.fileGroupSeq;
					});*/
					$($(this).find("ol li")[file.index]).find(".fileProgressBar").remove();
					file.fileSeq = response.fileSeq;
					$("#mwContent input[name='fileGroupSeq']").val(response.fileGroupSeq);
					$($(this).find("ol li")[file.index]).find("a").attr({"href":contextBase + "cmnmgmt/fileDownload.do?fileDtlSeq=" + response.fileDtlSeq, "download":response.fileRealNm + "." + response.fileExt, "target":"_blank", "File-Seq":response.fileDtlSeq});
					$($(this).find("ol li")[file.index]).find("a button.button.flat").attr("onclick", "fnFileDelete(" + response.fileDtlSeq + ");return false;");
					fileList.unshift(response);
				}
			}).on("fileError.dropper", function(e, file, error){
				$($(this).find("ol li")[file.index]).find(".fileProgressBar .percentDone").css("background-color", "#FF0000");
				$($(this).find("ol li")[file.index]).delay(5000).queue(function(){$(this).remove();});
				if(typeof(error) === 'string' && error == "Too large") {
					"파일 크기 15MB로 제한합니다.".alert();					
				} else if(typeof(error) === 'string' && error == "Too ext") {
					"해당 파일은 업로드 할 수 없습니다.".alert();
				} else {
					(file.name + " 전송 실패").alert();
				}
			});
			droppers.push($(value).data("dropper"));
			
			if(!$(value).contents(".dropper-dropzone .button.white").length) {
				$(value).contents(".dropper-dropzone").append($("<span><button style=\"float:right;\" class=\"button white\">파일찾기</button></span>"));
			}
		});
	}
	
	fnAllTableShow('show');
	$(".trAgent").toggle();
	
	$(window).trigger("resize");
	
	$("#mwContent input[type=text]").attr("style","margin-left:10px;");
	$("#mwContent textarea").attr("style","margin-left:10px;");
	
	if(reqstType == "DUR000080") {
		$("#txtConstructionStart").removeClass('hasDatepicker');
		$("#txtConstructionStart").addClass('disabled');
		$("#txtConstructionStart").off();
		$("#txtConstructionEnd").removeClass('hasDatepicker');
		$("#txtConstructionEnd").addClass('disabled');
		$("#txtConstructionEnd").off();
	}
});
function fnCreateFileGroupSeq(){
    if ($("input[name='fileGroupSeq']").val() == "") {
        doAjax(contextBase + "/cmnmgmt/createFileGroupSeq.json", "", "json", "json", false, "fnSetCreateFileGroupSeq");
    }
}
function fnSetCreateFileGroupSeq(response){
    if (response && response.fileGroupSeq != "") {
		$("input[name='fileGroupSeq']").val(response.fileGroupSeq);
    }
}
function fnDroppersSetFileGroupSeq(){
	$.each(droppers, function(i,v){
		v.postData.fileGroupSeq = $("input[name='fileGroupSeq']").val();
	});
}
function fnSetLoggedInUser(){
	var reprsntYn;
	if(applicant.getReprsnt()) {
		reprsntYn = applicant.getReprsnt().userSeq=="<%=user.getUserSeq()%>"
	} else {
		reprsntYn = true;
	}
	
	var coRgstNo = "<%=user.getCoRgstNo()%>";
	applicant.unshift({
		"diInpYn":"false",
		"appNm":"<%=user.getUserNm()%>",
		"identifyNo": (coRgstNo!=""&&coRgstNo!=null&&coRgstNo!=undefined&&coRgstNo!="null"?coRgstNo:"<%=user.getUserIdNo()%>"),
		"presidentNm" : (coRgstNo!=""&&coRgstNo!=null&&coRgstNo!=undefined&&coRgstNo!="null"?"<%=user.getUserCeoNm()%>":""),
		"cprYn":false,
		"presidentNm":"<%=user.getUserCeoNm()%>",
		"rdnmadr":"<%=user.getUserAddrPre()%>",
		"rdnmadrDetail":fnNvl("<%=user.getUserAddrSuf()%>"),
		"emailId":fnNvl("<%=user.getUserEmailId()%>"),
		"emailDomain":fnNvl("<%=user.getUserEmailDomain()%>"),
		"userSeq":"<%=user.getUserSeq()%>",
		"telArea":fnNvl("<%=user.getUserTelArea()%>"),
		"telPre":fnNvl("<%=user.getUserTelPre()%>"),
		"telSuf":fnNvl("<%=user.getUserTelSuf()%>"),
		"mobileArea":fnNvl("<%=user.getUserMobileLoc()%>"),
		"mobilePre":fnNvl("<%=user.getUserMobilePre()%>"),
		"mobileSuf":fnNvl("<%=user.getUserMobileSuf()%>"),
		"reprsntYn":reprsntYn,
		"agentYn":false,
		"smsRtYn":true,
		"prmisnSeq":$("input[name=prmisnSeq]").val()
	});
}
function fnDropZoneFileDelete(data){
	if(!isNaN(data)){
		doAjaxSubmit(contextBase + "cmnmgmt/fileDelete.json", {"fileDtlSeq" : data} ,"json", "html", "fnDropZoneFileDelete");
	} else {
		if(data.tnCmnMsgVo.smsgBody == "SUCCESS") {
			//console.log($("tr[class*=Files] ol li a[file-seq='" + data.fileDtlSeq + "']").length);
			if($("tr[class*=Files] ol li a[file-seq='" + data.fileDtlSeq + "']").length > 0) {
				$("tr[class*=Files] ol li a[file-seq='" + data.fileDtlSeq + "']").parent().remove();
			}
			
			if($("#mwInfo div[class*=Files] ol li a[file-seq='" + data.fileDtlSeq + "']").length > 0) {
				$("#mwInfo div[class*=Files] ol li a[file-seq='" + data.fileDtlSeq + "']").parent().remove();
			}
			
			for(i=0; i < fileList.length; i++){
				if(fileList[i].fileDtlSeq == data.fileDtlSeq) {
					fileList.splice(i,1);
					break;
				}
			}
		}
	}
}

function fnSpanCheckShowHide() {
	if ($("#spanChk").find("input[type=checkbox]:checked").length == 0) {
		$(".mainTh").hide();
	} else {
		$(".mainTh").show();
	}
}
function fnFileDelete(data){
	if(!isNaN(data)){
		doAjaxSubmit(contextBase + "cmnmgmt/fileDelete.json", {"fileDtlSeq" : data} ,"json", "html", "fnFileDelete");
		return false;
	} else {
		if(data.tnCmnMsgVo.smsgBody == "SUCCESS") {
			var div = $("div[id*=Files] ol li a[file-seq='" + data.fileDtlSeq + "']").parent().parent().parent();
			$.each(droppers, function(i, v){
				if($(v.$dropper).attr("id") == div.attr("id")){
					v.total -= 1;
				}
			});
			$("div[id*=Files] ol li a[File-Seq='" + data.fileDtlSeq + "']").parent().remove();
			for(i=0; i < fileList.length; i++){
				if(fileList[i].fileDtlSeq == data.fileDtlSeq) {
					fileList.splice(i,1);
					break;
				}
			}
		} else {
			data.tnCmnMsgVo.smsgBody.alert();
		}
	}
}
function fnSetCpttrDatas(response){
	if(response.result == "SUCCESS") {
		var temp = response.list;
		$.each(temp, function(i,v){
			if(v.agentYn) {
				agent.unshift(v);
			} else {
				v.updateYn = true;
				applicant.unshift(v);
			}
		});
	} else {
		("불러오기 실패<br>" + response.msg).alert(); 
	}
}

function fnSetUserAgentDatas(response){
	if(response.result == "SUCCESS") {
		var temp = response.list;
		if(temp.length > 0) {
			$.each(temp, function(i,v){
				agent.unshift({
					"diInpYn":"false",
					"appNm":v.companyNm,
					"cprYn":v.agentCprYn,
					"identifyNo":((v.corporationNum!=null && v.corporationNum!=undefined&& v.corporationNum!=""&& (v.corporationNum.length==8||v.corporationNum.length==13))?v.corporationNum:''),
					"presidentNm":v.agentNm,
					"rdnmadr":v.businessAddr,
					"rdnmadrDetail":fnNvl(v.businessAddrDetail),
					"emailId":fnNvl(v.emailId),
					"emailDomain":fnNvl(v.emailDomain),
					"userSeq":v.agentUserSeq,
					"telArea":fnNvl(v.agentTelArea),
					"telPre":fnNvl(v.agentTelPre),
					"telSuf":fnNvl(v.agentTelSuf),
					"mobileArea":fnNvl(v.mobileArea),
					"mobilePre":fnNvl(v.mobilePre),
					"mobileSuf":fnNvl(v.mobileSuf),
					"reprsntYn":v.agentReprsntYn,
					"agentYn":true,
					"smsRtYn":true,
					"agentSeq":v.agentSeq,
					"fileDtlSeq":v.fileDtlSeq,
					"fileRealNm":v.fileRealNm,
					"fileExt":v.fileExt
				});
			});
			
			$(".trAgent").show();
			if(userType == 'DAU000020')//대리인 사용자일때, 
			{
				$.each(temp, function(i,v){
					tmpAgent.unshiftIS({
						"diInpYn":"false",
						"appNm":v.companyNm,
						"cprYn":v.agentCprYn,
						"identifyNo":((v.corporationNum!=null && v.corporationNum!=undefined&& v.corporationNum!=""&& (v.corporationNum.length==8||v.corporationNum.length==13))?v.corporationNum:''),
						"presidentNm":v.agentNm,
						"rdnmadr":v.businessAddr,
						"rdnmadrDetail":fnNvl(v.businessAddrDetail),
						"emailId":fnNvl(v.emailId),
						"emailDomain":fnNvl(v.emailDomain),
						"userSeq":v.agentUserSeq,
						"telArea":fnNvl(v.agentTelArea),
						"telPre":fnNvl(v.agentTelPre),
						"telSuf":fnNvl(v.agentTelSuf),
						"mobileArea":fnNvl(v.mobileArea),
						"mobilePre":fnNvl(v.mobilePre),
						"mobileSuf":fnNvl(v.mobileSuf),
						"reprsntYn":v.agentReprsntYn,
						"agentYn":true,
						"smsRtYn":true,
						"agentSeq":v.agentSeq,
						"fileDtlSeq":v.fileDtlSeq,
						"fileRealNm":v.fileRealNm,
						"fileExt":v.fileExt
					});
				});
			} 
			else //신청인 사용자 일경우
			{
				$("#trAgentFile").remove();//위임장 관련 파일 tr
				$("#agentReprsntYn").remove();//대리인 대표지정 버튼
			}
			$("#agentAdd").remove();//대리인 입력 버튼
		}
	} else {
		("불러오기 실패<br>" + response.msg).alert(); 
	}
}
function fnSetFileGroupSeq(response) {
	alert("fnSetFileGroupSeq");
	alert("response.tnCmnMsgVo.smsgBody : " + response.tnCmnMsgVo.smsgBody);
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS"){
		$("#mwContent input[name='fileGroupSeq']").val(response.fileGroupSeq);
		$.each(droppers, function(i,v){

			v.postData.fileGroupSeq = response.fileGroupSeq;
		});// 
		doAjaxSubmit(contextBase + "minwonmgmt/insertAndUpdateTnPrmisnDoc.json", JSON.stringify($("#mwContent input, #mwContent textarea").fnSerializeObject()), "json", "json", "fnTemporarySaveCallback");
		console.log(doAjaxSubmit);
	} else {
		response.tnCmnMsgVo.smsgBody.toString().alert();
	}
}
function fnSetDatas(response) {
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
		$.each(response, function(name, value){
			if(name=="workDateBgn" && value != null) {
				value = new Date(response.workDateBgn).format("yyyy-mm-dd");
			} else if(name=="workDateEnd" && value != null) {
				value = new Date(response.workDateEnd).format("yyyy-mm-dd");
			} else if(name=="thHeapBgn" && value != null) {
				value = new Date(response.thHeapBgn).format("yyyy-mm-dd");
			} else if(name=="thHeapEnd" && value != null) {
				value = new Date(response.thHeapEnd).format("yyyy-mm-dd");
			} else if(name=="tmlmtDate" && value != null) {
				value = value.substring(0,4)+"년"+value.substring(4,6)+"월"+value.substring(6,8)+"일";
				$("#tmlmtDate").html(value);
			}
			if(name=="reqstSttus" && value != null) {//최초저장이 아닌경우, 
				
				if(value!="DAS009000") {//임시저장이 아닌경우
					$("#btDelete").remove();//삭제 버튼 비활성화
					$("#tmlmtDateBox").show();//처리기한일 활성화

					$("input:checkbox[class='type']").prop("disabled",true);
					$("#btDelMinwon").remove();//민원 삭제 버튼 삭제
				}
				else//임시저장 상태라면
				{
					$("#btDelMinwon").show();//민원 삭제 버튼 활성화
				}
				//보완상태가 아니면
				if(value!="DUP000030"&& userType == 'DAU000020') {//임시저장이 아닌경우
					$("#btAddThisAgent").show();//대리인 추가 버튼 활성화	
				}
			}
			$("input[name='" + name + "'], textarea[name='" + name + "']").val(value);
			if($("input[name='" + name + "']").attr("placeholder") == "숫자") {
				$("input[name='" + name + "']").val(fnAddCommas(fnNvl(value)));
			}
			$("input:checkbox[class='" + name + "']").each(function() {
				for(var i=0;i<6;i++){
					if(i == 5){
						if(value.substring(i) == 1){
							if(this.value.indexOf(1) == i)
								$("#" + this.id).trigger("click");
						}
					}else{
						if(value.substring(i,i+1) == 1){
							if(this.value.indexOf(1) == i)
								$("#" + this.id).trigger("click");
						}	
					}
				}
			});
			
		});
		
// 		fnSetLoggedInUser();
		if(!droppers[0].postData.fileGroupSeq) {
			$.each(droppers, function(i,v){
				droppers[i].postData.fileGroupSeq = $("input[name='fileGroupSeq']").val();
			});
		}
		if(response.fileGroupSeq){
			doAjaxSubmit(contextBase + "cmnmgmt/selectFileList.json", JSON.stringify({"fileGroupSeq":response.fileGroupSeq}), "json", "json", "fnSetFileList");
		} else {
			$("input[name=agendaFilesChkBox]").on("click",fnAgendaChk);
		}
		
		//산지 상태값이 있을 경우
		if(response.mountProg != null || response.mountProg != undefined){
			//산지 상태 값 넣어줌
			vMountProg = response.mountProg;
		}
		//산지 결제 여부
		if(response.mountPayYn != null || response.mountPayYn != undefined){
			vMountPayYn = response.mountPayYn;
		}
	} else {
		response.tnCmnMsgVo.smsgBody.toString().alert();
	}
}
function fnSetFileList(response) {
	if(response.result == "SUCCESS") {
		var hasAgenda = false;
		var hasAgent = false;
		if(response.list.length != 0){
			for(var i = 0; i < response.list.length; i++){
				if(response.list[i].fileTypeCd == 0){		
					$("#mwFile th:eq(0)").attr("rowspan","2");
					$(".getOwnerShipFiles").css("display","table-row");
					addToFileList("mwFile .getOwnerShipFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}	else if(response.list[i].fileTypeCd == 1){
					$("#mwFile th:eq(1)").attr("rowspan","2");
					$(".getConstructionFiles").css("display","table-row");
					addToFileList("mwFile .getConstructionFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}	else if(response.list[i].fileTypeCd == 2){
					$("#mwFile th:eq(2)").attr("rowspan","2");
					$(".getPlanFiles").css("display","table-row");
					addToFileList("mwFile .getPlanFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}	else if(response.list[i].fileTypeCd == 3){
					$("#mwFile th:eq(3)").attr("rowspan","2");
					$(".getStructureFiles").css("display","table-row");
					addToFileList("mwFile .getStructureFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}	else if(response.list[i].fileTypeCd == 4){
					$("#mwFile th:eq(4)").attr("rowspan","2");
					$(".getBudgetFiles").css("display","table-row");
					addToFileList("mwFile .getBudgetFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}	else if(response.list[i].fileTypeCd == 5){
					$("#mwFile th:eq(5)").attr("rowspan","2");
					$(".getLandscapeFiles").css("display","table-row");
					addToFileList("mwFile .getLandscapeFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}  else if(response.list[i].fileTypeCd == 6) { //위임장관련파일
					hasAgent = true;
					$(".getDeligationFiles").show();
					addToFileList("mwInfo .getDeligationFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
					$("#mwInfo div button i.axi").css("position","relative");
					$("#mwInfo div button i.axi").css("right","0px");
					$("#mwInfo div button i.axi").css("top","0px");
					//$(".getDeligationFiles:eq(0)").show();
					//addToFileList("mwInfo .getDeligationFiles ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				}  else if(response.list[i].fileTypeCd == 9){
					$("#mwFile th:eq(7)").attr("rowspan","2");
					$(".getEtcFiles").css("display","table-row");
					addToFileList("mwFile .getEtcFiles td div ol", response.list[i].fileRealNm,response.list[i].fileDtlSeq,response.list[i].fileExt,"temp");
				} else if(response.list[i].fileTypeCd >= 11 && response.list[i].fileTypeCd <= 172) {
					hasAgenda = true;
				}
			}
		}
		if(!hasAgenda){
			$("input[name=agendaFilesChkBox]").trigger("click");
			$("#agendaFilesButton").html("<span><button style=\"width: calc(100% - 15px);cursor: default;\" class=\"button gray w98\" disabled>의제협의 관련사항 없음</button></span>");
		}
		$("input[name=agendaFilesChkBox]").on("click", fnAgendaChk);
		if(hasAgent){
			var val = $($(".trAgent")[0]).find("th:first-child").attr("rowspan")?$($(".trAgent")[0]).find("th").attr("rowspan"):"1";
			$($(".trAgent")[0]).find("th:first-child").attr("rowspan", parseInt(val) + 1);
			
			val = $($(".trAgent")[$(".trAgent").length - 1]).find("th").attr("rowspan")?$($(".trAgent")[$(".trAgent").length - 1]).find("th").attr("rowspan"):"1";
			$($(".trAgent")[$(".trAgent").length - 1]).find("th").attr("rowspan", parseInt(val)+1);
			/* $("#chkSelf").trigger("click"); */
		}
		doAjaxSubmit(contextBase + "cmnmgmt/selectMissionList.json", JSON.stringify({"fileGroupSeq":$("#mwContent input[name=fileGroupSeq]").val()}), "json", "json", "fnSetMissionList");
	} else {
		response.msg.toString().alert();
	}
}
function fnSetMissionList(response){
	//산지 상태 값이 있을 경우 체크
	if(vMountProg != null){
		$("input[name=agendaFilesChkBox]").trigger("click");
	}
	if(response.result == "SUCCESS"){
		if(response.list.length > 0) {
			$("input[name=agendaFilesChkBox]").trigger("click");
		}
	}else{
		response.msg.toString().alert();
	}
}
function fnSetJibunDatas(response) {
	
	
	if(response.result == "SUCCESS") {
		if(response.list[0]) {
			if(response.list[0].ladAddrPre) {
				$("#txtAddr").val(response.list[0].ladAddrPre);
				$("#riCd").val(response.list[0].ladPnu.substr(0,10));
				vSiteCode = response.list[0].ladPnu.substr(0,5);
			}
		}
		$.each(response.list, function(i, v){
			v.updateYn = true;
			jibun.unshift(v);
		});
	} else {
		response.msg.toString().alert();
	}
}
function openPop(num) {
	var param = "num="+num;
	if(num == 2) {
		if(!$("#applicant tr.highlight").length) {
			"정보를 보고싶은 신청인을 선택하세요".alert();
			return;
		}

		/*더블클릭한 신청자가 임의등록 사용자인치 check*/
		var index = $("#applicant tr").index($("#applicant tr.highlight"));
		var userSeq = (applicant.toArray()[index].userSeq==null?applicant.toArray()[index].cpttrUserSeq:applicant.toArray()[index].userSeq);
		
		
		$.ajax({
			type:"POST"
			,async:false
			,url:contextBase + "minwonmgmt/checkAbrrUserYn.json"
			,dataType:"json"
			,data:"cpttrUserSeq=" + userSeq
			,success: function(result) 
			{
				var abrrUserYnFlag =  result.flag;
				if(abrrUserYnFlag!="Y")
				{
					doAjaxSubmit(contextBase + "usermgmt/viewSelectUser.pop", param, "html", "html", "commonCallback");
				}
				else //임의등록 사용자일 경우에만 정보 수정 팝업 열릴 수 있음
				{
					if(''/*최초*/==seq||'DAS009000'/*임시저장*/==$("#mwContent input[name='reqstSttus']").val()||'DUR000080'/*보완요청*/!=$("#mwContent input[name='reqstType']").val())
					{
						fnAddApplicant('update');
					}
					else
					{
						fnAddApplicant('view');
					}
					
				}
			}
			,error : function(xhr,status,error)
			{
				
			}
		});
		
	} else if(num == 3) {
		if(!$("#agent tr.highlight").length) {
			"정보를 보고싶은 대리인을 선택하세요".alert();
			return;
		}
		doAjaxSubmit(contextBase + "usermgmt/viewSelectUser.pop", param, "html", "html", "commonCallback");
	}
	else
	{
		doAjaxSubmit(contextBase + "usermgmt/viewSelectUser.pop", param, "html", "html", "commonCallback");
	}
}
function commonCallback(response) {// 팝업 : 응답 받은 case 넘버에 따라 다른 화면을 띄어준다.
	var title = response.match(/<title>(.*?)<\/title>/)[1];
	modalPop = createLayerPopup("modalForm", title, "auto", "760", response);
	modalPop.dialog("open");
	$("#dialog").css('margin-left','0px');
	if($("#deligationFilesOnPop").length) {
		$("#deligationFilesOnPop").dropper({
			action:contextBase+"cmnmgmt/uploadFiles.json",
			label: "<span class=\"dropzoneSpan\">여기에 파일을 끌어다놓거나 클릭하세요<br>등록 파일은 파일당 15MB로 제한합니다.</span>",
			postData: {"fileType":"09", "fileGroupSeq":$("input[name='fileGroupSeq']").val()},
		}).on("start.dropper", function(e, files){
			// 업로드전 fileGroupSeq 생성
			fnCreateFileGroupSeq();
			fnDroppersSetFileGroupSeq();
			$(this).find(".dropper-dropzone p").remove();
			$("#deligationFiles").find(".dropper-dropzone p").remove();
			if($(this).find(".dropper-dropzone").text().startsWith("여기에")) {
				$(this).find(".dropper-dropzone").text("");
				$(this).find(".dropper-dropzone").append($("<span><button style=\"float:right;\" class=\"button white\">파일찾기</button></span>"));
				
				$("#deligationFiles").find(".dropper-dropzone").text("");
				$("#deligationFiles").find(".dropper-dropzone").append($("<span><button style=\"float:right;\" class=\"button white\">파일찾기</button></span>"));
			}
			for(i = 0; i < files.length; i++) {
				$(this).find("ol").append("<li id = \"" + $(this).attr("id") + "_" + files[i].index + "\" class=\"fileListItem\" ><a>" + files[i].name + "<button class='button flat' ><i class=\"axi axi-close\"></i></button></a></li>");
				$("#deligationFiles").find("ol").append("<li id = \"" + $(this).attr("id") + "_" + files[i].index + "\" class=\"fileListItem\" ><a>" + files[i].name + "<button class='button flat'><i class=\"axi axi-close\"></i></button></a></li>");
			}
		}).on("fileStart.dropper", function(b, fileInfo){
			/* File Tranffering Start */
			$($(this).find("ol li")[fileInfo.index]).append("<div class=\"fileProgressBar\"><div class=\"percentDone\"></div></div>");
			$($("#deligationFiles").find("ol li")[fileInfo.index]).append("<div class=\"fileProgressBar\"><div class=\"percentDone\"></div></div>");
		}).on("fileProgress.dropper", function(e, file, percent){
			/* Percentage */
			$($(this).find("ol li")[file.index]).find(".fileProgressBar .percentDone").css("width", "" + percent);
			
			$($("#deligationFiles").find("ol li")[file.index]).find(".fileProgressBar .percentDone").css("width", "" + percent);
		}).on("fileComplete.dropper", function(e, file, response){
			$.each(droppers, function(i,v){
				v.postData.fileGroupSeq = response.fileGroupSeq;
			});
			$($(this).find("ol li")[file.index]).find(".fileProgressBar").remove();
			file.fileSeq = response.fileSeq;
			$("#mwContent input[name='fileGroupSeq']").val(response.fileGroupSeq);
			$($(this).find("ol li")[file.index]).find("a").attr({"href":contextBase + "file/download.do?fileDtlSeq=" + response.fileDtlSeq, "download":response.fileRealNm + "." + response.fileExt, "target":"_blank", "File-Seq":response.fileDtlSeq});
			$($(this).find("ol li")[file.index]).find("a button.white").attr("onclick", "fnFileDelete(" + response.fileDtlSeq + ");return false;");
			fileList.unshift(response);
			
			$($("#deligationFiles").find("ol li")[file.index]).find(".fileProgressBar").remove();
			$($("#deligationFiles").find("ol li")[file.index]).find("a").attr({"href":contextBase + "file/download.do?fileDtlSeq=" + response.fileDtlSeq, "download":response.fileRealNm + "." + response.fileExt, "target":"_blank", "File-Seq":response.fileDtlSeq});
			$($("#deligationFiles").find("ol li")[file.index]).find("a button.white").attr("onclick", "fnFileDelete(" + response.fileDtlSeq + ");return false;");
		}).on("fileError.dropper", function(e, file, error){
			$($(this).find("ol li")[file.index]).find(".fileProgressBar .percentDone").css("background-color", "#FF0000");
			$($(this).find("ol li")[file.index]).delay(5000).queue(function(){$(this).remove();});
			
			$($("#deligationFiles").find("ol li")[file.index]).find(".fileProgressBar .percentDone").css("background-color", "#FF0000");
			$($("#deligationFiles").find("ol li")[file.index]).delay(5000).queue(function(){$("#deligationFiles").remove();});
			
			if(typeof(error) === 'string' && error == "Too large") {
				"파일 크기 15MB로 제한합니다.".alert();					
			} else if(typeof(error) === 'string' && error == "Too ext") {
				"해당 파일은 업로드 할 수 없습니다.".alert();
			} else {
				(file.name + " 전송 실패").alert();
			}
		});
		droppers.push($("#deligationFilesOnPop").data("dropper"));
	}
// 	droppers.push($(value).data("dropper"));
	$("#deligationFilesOnPop").find(".dropper-dropzone").append($("<span><button style=\"float:right;\" class=\"button white\">파일찾기</button></span>"));
	if(!$("input[name=fileGroupSeq]").val()){
		if($("input[name=fileGroupSeq]").val() != "")
		doAjaxSubmit(contextBase + "cmnmgmt/createFileGroupSeq.json", "", "json", "json", "fnAgendaOnClick");
	}
}
function fnEnable(classNm) {
	if($("#jibunTbody").find(".jibunInfo").length == 0){
		//alert("주소와 지번을 먼저 입력해주세요.");
		"주소와 지번을 먼저 입력해주세요.".alert();
	}else{
		if($("#jibunTbody tr.highlight").length > 0){
			changeSave = false;
			$("#btCadastralInfo").hide();
			$(".btTxtInput").hide();
			//$("#jibunTbody tr:eq(1) td:last").append("<button id='btJibunChangeSave' class='button grayBlue' onclick='jibunChangeSave();'>저장</button><button id='btJibunChangeCancel' class='button blue02'onclick='jibunChangeCancel();'>취소</button>")
			$("#jibunTbody tr:eq(1) td:last").append("<button id='btJibunChangeSave' class='button grayBlue' onclick='fnJibunChangeSave();'>저장</button><button id='btJibunChangeCancel' class='button blue02'onclick='jibunChangeCancel();'>취소</button>");
			reqstAr =  $(".jibunInfo.highlight .reqstAr").html().replace(/,/gi,'');
			bfLNDCGR = $(".jibunInfo.highlight .LNDCGR").html();
			bfSPFC = $(".jibunInfo.highlight .SPFC").html();
			bfSPCFC = $(".jibunInfo.highlight .SPCFC").html();
			$(".jibunInfo.highlight .reqstAr").html("<input type='text' class='w80' value='" +reqstAr + "'>");
			$(".jibunInfo.highlight .LNDCGR").html("<input type='text' class='w80' value='" +bfLNDCGR+ "'>");
			$(".jibunInfo.highlight .SPFC").html("<input type='text' class='w80' value='" + bfSPFC+ "'>");
			$(".jibunInfo.highlight .SPCFC").html("<input type='text' class='w80' value='" + bfSPCFC+ "'>");
			
			if(!changeSave){
				$('.jibunInfo').unbind('click');
				$(".jibunInfo").on("click", function(){
					if($(this).attr("class").indexOf("highlight") < 0)
						//alert("입력중인 지번정보를 저장해주세요.");
						"입력중인 지번정보를 저장해주세요.".alert();
				});	
			}
		}else{
			//alert("수동입력할 지번을 먼저 선택해주세요.");
			"수동입력할 지번을 먼저 선택해주세요.".alert();
		}
	}
}

function jibunChangeCancel(){
	if($("#jibunTbody tr.highlight").length > 0){
// 		$(".jibunInfo.highlight .LNDCGR").html(bfLNDCGR);
// 		$(".jibunInfo.highlight .SPFC").html(bfSPFC);
// 		$(".jibunInfo.highlight .SPCFC").html(bfSPCFC);
		changeSave = true;
		if(changeSave){
			$('.jibunInfo').unbind('click');
			 $(".jibunInfo").on("click", function(){
				$(".jibunInfo.highlight").removeClass("highlight");
				$(this).addClass("highlight");
			}); 
		}
		$("#btCadastralInfo").show();
		$(".btTxtInput").show();
		$("#btJibunChangeSave").remove();
		$("#btJibunChangeCancel").remove();
		jibun.each(jibun.change);
	}
}

function fnAgendaOnClick(response) {
	seq = "<c:out value='${seq}'/>" // 임시저장 안 할 시 "" 상태
	if (seq == "") {
		"임시저장 후 등록할 수 있습니다.".alert();
		return;
	}
		
	if(!$(".jibun").text()){
		"신청위치 입력 후 클릭 하여 주세요.".alert();
	}else{
		
		if(response){
			if(response.tnCmnMsgVo.smsgBody == "SUCCESS"){
				$("input[name='fileGroupSeq']").val(response.fileGroupSeq);
				$.each(droppers, function(i,v){v.postData.fileGroupSeq = response.fileGroupSeq;});
				var option = "menubar=no, toolbar=no, location=no, status=no, scrollbars=yes, resizable=yes, width=1050px, height=740px, top=40, left=30";
				window.open(contextBase+"minwonmgmt/viewInsertAgendaFiles.pop?fileGroupSeq=" + $("input[name='fileGroupSeq']").val(),"questionPop",option);
				
			} else {
				//retry
				"필수값이 부족하여 창을 열수 없습니다.<br>지속적으로 같은 문제가 발생할 시 브라우저를 닫고 다시 열어주시기바랍니다.".alert();
			}
		} else {
			if(!$("#mwContent input[name=fileGroupSeq]").val()){
				doAjaxSubmit(contextBase + "cmnmgmt/createFileGroupSeq.json", "", "json", "json", "fnAgendaOnClick");
			} else {
				var option = "menubar=no, toolbar=no, location=no, status=no, scrollbars=yes, resizable=yes, width=1050px, height=740px, top=40, left=30";
				window.open(contextBase+"minwonmgmt/viewInsertAgendaFiles.pop?fileGroupSeq=" + $("input[name='fileGroupSeq']").val(),"questionPop",option);
			}
		}
	}
}

function fnQuestionMark(name){
	var option = "width=530,height=180";
	window.open(contextBase+"minwonmgmt/question.pop?selectNm=" + name,"questionPop",option);
}

/* 신청인 대표 지정 */
function appointReprsntYn(){
	var index = $("#applicant tr").index($("#applicant tr.highlight"));
	if(applicant.toArray().length == 0) {
		"신청인이 존재하지 않습니다.".alert();
	} else {
		if(index < 0){
			"대표 지정할 신청인을 선택해 주세요.".alert();
		} else {
			$.each(applicant.toArray(), function(i,v){
				if (i == index) {
					applicant.toArray()[i].reprsntYn = true;
				} else {
					applicant.toArray()[i].reprsntYn = false;					
				}
			});
			applicant.each(applicant.change);
		}
	}
}

$(function(){
	$(document).tooltip({
		items: ".dropper-dropzone, #btUpCsv",
		content: function(){
			if($(this).is(".dropper-dropzone"))
				return "여기를 누르거나 파일을 끌어다 놓으면 파일이 첨부가 됩니다.";
			if($(this).is("#btUpCsv"))
				return "양식받기로 받은 CSV 파일을 엑셀 혹은 메모장에서 양식에 맞춰 추가한 뒤 파일을 올려주세요";
		},
		track: false,
		show:{effect:"none", delay: 0},
		hide:{effect:"none", delay: 0}
	});
});

/* 수수료로 인한 신청 소스 수정 */
var fileSeq;
function fnSubmit(){
	
	fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
	if(fileSeq == null || fileSeq == ""){
		
		fnInsertMinwon();
	}else{
		
		if(fnCpttrReprsntYnCheck()) {
			if(applicant.array.length == 0){
				"신청인 정보를 입력해 주세요.".alert();
				modalPop.dialog("close");
				progress.stop();
			}else if(jibun.array.length == 0){
				"신청위치 정보를 입력해 주세요.".alert();
				modalPop.dialog("close");
				progress.stop();
			}else if(!$("input:checkBox[class=type]:checked").val()){
				"신청내용을 선택해 주세요.".alert();
				modalPop.dialog("close");
				progress.stop();
			}else{
				if(droppers.length){
					var fileExist = false;
					for(i = 0; i < droppers.length ; i++){
						if(droppers[i].total > 0)
							fileExist = true;
					}
					if($("#mwFile .fileListItem").length > 0){
						fileExist = true;
					}
					if(!fileExist){
						"첨부서류 등록을 해야 민원신청이 진행됩니다.".alert();
						progress.stop();					
					}else{
						// 대리인일경우 위임장 파일 여부 체크
						var agentFileExist = false;
						if(userType == 'DAU000020') {
							var totalCnt = $("#mwInfo .fileListItem").length;
							if(totalCnt > 0) {
								if(agent.array.length != totalCnt) {
									"대리인 목록과 위임장 파일 개수가 다릅니다.".alert();	
									progress.stop();
									return false;
								} else {
									var tmpArr = new Array;
									var fileListCnt = $("#deligationFileList .fileListItem").length;
									if(fileListCnt > 0) {
										for (var j = 0; j < fileListCnt; j++) {
											var fileNm = $("#deligationFileList .fileListItem").eq(j).find("a").text();
											tmpArr.push(fileNm.substring(0, fileNm.indexOf('.')));
										}									
									}
									var getFileListCnt = $(".getDeligationFiles .fileListItem").length;
									if(getFileListCnt > 0) {
										for (var x = 0; x < getFileListCnt; x++) {
											var fileNm = $(".getDeligationFiles .fileListItem").eq(x).attr("id");
											tmpArr.push(fileNm.substring(0, fileNm.indexOf('_')));
										}									
									}
									var tmpCnt = 0;
									$.each(agent.toArray(), function(i,v) {
										
										for (var y = 0; y < tmpArr.length; y++) {
											
											
											
											if(v.presidentNm == tmpArr[y]) {
												
												
												
												tmpCnt++;
												
												
												
												break;
											}
										}	
									});
									
									
									
									if(agent.array.length != tmpCnt) {
										"위임장 파일명을 확인해주십시오. <br> ex) 대리인 대표자명이 홍길동일 시 파일명은 홍길동.pdf".alert();	
										progress.stop();
										return false;
									} else {
										agentFileExist = true;
									}
								}
							}
						} else {
							agentFileExist = true;
						}
						
						if(!agentFileExist) {
							"대리인 위임장관련파일 등록을 해야 민원신청이 진행됩니다.".alert();
							progress.stop();
						}/*else if(vMountProg != undefined){
							if(agentFileExist){
								var param = "fileGroupSeq=" + fileSeq;
								doAjaxSubmit(contextBase + "minwonPayCheck.json", param, "json", "html", "fnSubmitPay");
							}else{
								fnInsertMinwon();
							}
						}*/else {
							
							var param = "fileGroupSeq=" + fileSeq;
							doAjaxSubmit(contextBase + "minwonPayCheck.json", param, "json", "html", "fnSubmitPay");
							
							
						}
					}
				}
			}
		}
	}	
	
	
}

function fnConsent(){	
	$('#paySelect').toggle();
	$('#doPay').toggle();
	doPay("0402");
}

/* input 박스 글자입력 방지 */
function digit_check(evt){
    var code = evt.which?evt.which:event.keyCode;
    if(code < 48 || code > 57){
        return false;
    }
}

var paymthdcd; // 결제방법 파라미터
var payInfo;	// 결제방법 안내창
var paySum;	//결제 총합
var paySumCom;	//결제 수수료 금액
var receiptNumber; //접수번호
function doPay(value){
	var temp;	
		
	if(value == "0402"){
		paymthdcd = "0402";
		payInfo = "신용카드";
	}	
	if(value == "0403"){
		paymthdcd = "0403";
		payInfo = "계좌이체";
	}
	if(value == "0404"){
		paymthdcd = "0404";
		payInfo = "모바일";
	}
	temp = "<li><span>결제방법</span><span>" + payInfo + "</span></li>" +
	"<li><span>이름</span><span><input type='text' name='hddReqManName' id='hddReqManName'/></span></li>" + 
	"<li><span>주민등록번호</span><span><input type='text' placeholder='-없이 숫자만 입력하세요.' onkeypress='return digit_check(event)' name='req_man_rrn' id='req_man_rrn' maxlength='13'/></span></li>" +
	"<div>"+
	"①고유식별정보의 수집·이용 목적 : 개발행위허가 수수료 납부<br>"+
	"②고유식별정보 항목 : 이름, 주민등록번호<br>"+
	"③동의를 거부할 수 있으며, 동의 거부시 개발행위허가 신청이 진행 되지 않습니다.<br>"+
	"<span><label><input type='checkbox' id='privacyCheck' name='privacyCheck'/>※위 고유식별정보 수집이용에 동의하십니까?</label></span></div>";
	
	$('#doPay').html(temp);
}

function paySubmit(){
	var userNumberCheck = /^[0-9]{13}$/;
	fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
	if(!$("input:checkbox[name='minwonCheck']").is(":checked")){
		alert("동의하셔야만 인터넷 민원신청이 가능합니다.");		
		return false;
	}else if(!$("input:checkbox[name='privacyCheck']").is(":checked")){
		alert("동의하셔야만 인터넷 민원신청이 가능합니다.");
		return false;
	}else if($.trim($('#hddReqManName').val()) == ''){
		alert("이름을 입력하세요.");
		$('#hddReqManName').focus();
		return false;
	}else if(!userNumberCheck.test($('#req_man_rrn').val())){
		alert("주민등록번호를 잘못 입력하셨습니다.");
		$('#req_man_rrn').focus();
		return false;
	}else if($.trim($('#req_man_rrn').val()) == ''){
		alert("주민등록번호를 입력하세요.");
		$('#req_man_rrn').focus();
		return false;
	}
	var tempSiteCode = $("#riCd").val().substr(0,5);
	if(tempSiteCode == "41173" || tempSiteCode == "41171"){
		tempSiteCode = "41170";
	}
	$("#siteCd").val(tempSiteCode);
	var param = "paymthdcd=" + paymthdcd + "&userName=" + $('#hddReqManName').val() + "&reqmanrrn=" + $('#req_man_rrn').val() + "&capptot=" + paySum + "&capptotCom=" + paySumCom + "&fileSeq=" + fileSeq + "&siteCd=" + $('#siteCd').val();

	doAjaxSubmit(contextBase + "paySubmit.json", param, "json", "html", "paySubmitCallBack");
}


function paySubmitCallBack(value){
	var form1 = document.createElement("form");
	form1.setAttribute("accept-charset", "euc-kr");
    form1.setAttribute("method", "POST");
    form1.setAttribute("action", "https://www.gov.kr/main");
    form1.setAttribute("target", "minwon24");
    document.body.appendChild(form1);
	
    var formInput1 = document.createElement("input");
    formInput1.setAttribute("type", "hidden");
    formInput1.setAttribute("name", "a");
    formInput1.setAttribute("id", "a");
    formInput1.setAttribute("value", "CS040GPKIPaySetlPreApp");
    form1.appendChild(formInput1);
    
    var formInput2 = document.createElement("input");
    formInput2.setAttribute("type", "hidden");
    formInput2.setAttribute("name", "g4cssCK");
    formInput2.setAttribute("id", "g4cssCK");
    formInput2.setAttribute("value", value.encrypt_txt);
    form1.appendChild(formInput2);
    var option = "menubar=no, toolbar=no, location=no, status=no, scrollbars=no, resizable=yes, width=570px, height=350px, top=40, left=30";
    window.open('', "minwon24", option);
    form1.submit();
    
    var prmisnSeq = $("input[name=prmisnSeq]").val();
	var prmisnType  = $("input[name=prmisnType]").val();
	var bowanParam = "&bowanParam=1";
	if(reqstType == "DUR000080")//서류보완 상태이면  bowanParam setting
	{
		bowanParam = "&bowanParam=2";
	}
    var timer = setInterval( function () {
		    	$.ajax({
					type:"POST"
					,async:false
					,url:contextBase + "isPayed.json"
					,dataType:"json"
					,data:"prmisnSeq=" + prmisnSeq+"&capp_tot="+paySum+"&pg_fee="+paySumCom/*개발행위허가 신청서 번호(PK)*/+bowanParam+"&prmisnType="+prmisnType
					,success: function(result) 
					{
						if(result.isPayedYn=="Y")
						{
							clearInterval(timer);
							fnDoPost("minwonmgmt/viewInsertMinwon.do", {seq:prmisnSeq});
						}
					}
					,error : ""
				});
   			},2000);
}

function payResult(value){
	if(value){
		if(value.isSuccess == 1/*결재완료*/){
			if($(".ui-dialog").length > 0 && modalPop.css("display") == "block") {
				modalPop.dialog("close");
			}
			if(commissionBak == "DUP000031") {
				doAjaxSubmit(contextBase + "minwonUpdateBak.json", JSON.stringify(payArray), "json","json", "payResult");
			}else{
				//fnInsertMinwon();
				"수수료가 결제 되었습니다.".complete(function(){ fnInsertMinwon(); });
			}
		}else if(value == 1){
			doAjaxSubmit(contextBase + "minwonmgmt/insertMinwonComplement.json", JSON.stringify({"prmisnSeq":$("input[name=prmisnSeq]").val()}), "json","json", "fnComplement");			
		}else{
			"결제가 실패하였습니다.".alert();
			location.reload();
		}
	}else{
		"에러가 발생하였습니다.".alert();
		location.reload();
	}
}

var payArray = new Array();

function fnSubmitPay(value){
	
	if($("input[type=radio][name=agree]:checked").val() == "disagree"){
		"개인정보 수집 및 이용에 대한 안내(민원신청정보)동의를 선택하셔야 진행할 수 있습니다.".alert();
		progress.stop();
	}else{
		//민원신청시 개인정보 동의 추가되어 추가된 소스(2021.02.25 LeeJI)
		if($("input[type=radio][name=agree]:checked").val() == "agreement" && $("input[type=radio][name=agreeChoose]:checked").val() == "agreementChoose"){
			$("#privacyUse").val("Y");$("#privacyDeny").val("Y");
		}else{
			$("#privacyUse").val("Y");$("#privacyDeny").val("N");
		}
		if(!value.length > 0){ // MINWONCOMMISSION 테이블에 수수료 결제할 내역이 없을 경우
			// fnInsertMinwon();
			
			if(reqstType != "DUR000080"){
				fnInsertMinwon();	
			} else {
				if(!progress.isShowing()){
					progress.start();
				}
				doAjaxSubmit(contextBase + "minwonmgmt/insertMinwonComplement.json", JSON.stringify({"prmisnSeq":$("input[name=prmisnSeq]").val()}), "json","json", "fnComplement");
			}
			
		}else{
			
			if($(".ui-dialog").length > 0 && modalPop.css("display") == "block") {
				modalPop.dialog("close");
			}
			paySum = 0;
			paySumReturn = 0;
			var minwonList = "";
			var minwonReturn = "";
			var farmCheck = "";
			for(i=0; i<value.length; i++){			
				/* if(value[i].FILE_TYPE_CD == 41){
					farmCheck = "y";
					if(farmPayYn == "결제완료"){
						value[i].PAY = 0;
					}else{
						
						if(value[i].RETURN_PAY == 1)
							minwonList += "<li><span>농지전용의 허가</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";					
						if(value[i].RETURN_PAY == 2){
							var payData = new Object();
							payData.typeCd = value[i].FILE_TYPE_CD;
							payData.returnPay = (value[i].PAY).toString();
							payData.fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
							payArray.push(payData);
							minwonReturn += "<li><span>농지전용의 허가</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						}
					}
				} else if(value[i].FILE_TYPE_CD == 42){
					farmCheck = "y";
					if(farmPayYn == "결제완료"){
						value[i].PAY = 0;
					}else{
						
						if(value[i].RETURN_PAY == 1)
							minwonList += "<li><span>농지전용의 협의</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						if(value[i].RETURN_PAY == 2){
							var payData = new Object();
							payData.typeCd = value[i].FILE_TYPE_CD;
							payData.returnPay = (value[i].PAY).toString();
							payData.fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
							payArray.push(payData);
							minwonReturn += "<li><span>농지전용의 협의</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						}
					}
				} */ if(value[i].FILE_TYPE_CD == 43){
					farmCheck = "y";
					if(farmPayYn == "결제완료"){
						value[i].PAY = 0;
					}else{
						
						if(value[i].RETURN_PAY == 1)
							minwonList += "<li><span>농지전용의 신고</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						if(value[i].RETURN_PAY == 2){
							var payData = new Object();
							payData.typeCd = value[i].FILE_TYPE_CD;
							payData.returnPay = (value[i].PAY).toString();
							payData.fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
							payArray.push(payData);
							minwonReturn += "<li><span>농지전용의 신고</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						}
					}
				}else if(value[i].FILE_TYPE_CD == 91){
					if(vMountProg != undefined || vMountProg != null){//산지 상태값이 있을 경우 결제 패스
						value[i].PAY = 0;
// 						if(farmCheck != "y")
// 							fnInsertMinwon();
					}else{
						if(value[i].RETURN_PAY == 1)
							minwonList += "<li><span>산지전용의 허가</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						if(value[i].RETURN_PAY == 2){
							var payData = new Object();
							payData.typeCd = value[i].FILE_TYPE_CD;
							payData.returnPay = (value[i].PAY).toString();
							payData.fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
							payArray.push(payData);
							minwonReturn += "<li><span>산지전용의 허가</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						}
					}					
				}else if(value[i].FILE_TYPE_CD == 92){
					if(vMountProg != undefined || vMountProg != null){//산지 상태값이 있을 경우 결제 패스
						value[i].PAY = 0;
// 						if(farmCheck != "y")
// 							fnInsertMinwon();
					}else{
						if(value[i].RETURN_PAY == 1)
							minwonList += "<li><span>산지전용의 신고</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						if(value[i].RETURN_PAY == 2){
							var payData = new Object();
							payData.typeCd = value[i].FILE_TYPE_CD;
							payData.returnPay = (value[i].PAY).toString();
							payData.fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
							payArray.push(payData);
							minwonReturn += "<li><span>산지전용의 신고</span><span>" + (value[i].PAY).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
						}
					}										
				}
				if(value[i].RETURN_PAY == 1)
					paySum += value[i].PAY;
				if(value[i].RETURN_PAY == 2)					
					paySumReturn += value[i].PAY;
			}
			
			if(vMountProg != undefined || vMountProg != null){//산지 상태값이 있을 경우 결제 패스
					if(farmCheck != "y"){
						//fnInsertMinwon();
					}else if(farmPayYn == "결제완료"){
						fnInsertMinwon();
					}
			}else{
				
				if(commissionBak == "DUP000031") {
					fileSeq = $("#mwContent input[name=fileGroupSeq]").val();
					minwonList += "<li><span>결제 수수료</span><span>" + Number((paySum * 0.04)).toFixed().toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>" + 
					"<li><span>총합계</span><span>" + (Number(paySum) + Number((paySum * 0.04))).toFixed().toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li></ul></fieldset>" +
					"<fieldset class='payList'>" +
					"<legend><i class='axi axi-exclamation'></i>추가 수수료 금액</legend><ul>" + minwonReturn;
					paySum = paySumReturn;
				}
				
			}
			paySumCom = (paySum * 0.04).toFixed();
			
			minwonList += "<li><span>결제 수수료</span><span>" + (paySumCom).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li>";
			
			

			/*결제가 완료된 상태인지 check하여 결제 로직 타는지 여부 분기*/
			var prmisnSeq = $("input[name=prmisnSeq]").val();
			var prmisnType  = $("input[name=prmisnType]").val();
			var bowanParam = "&bowanParam=1";
			if(reqstType == "DUR000080")//서류보완 상태이면  bowanParam setting
			{
				bowanParam = "&bowanParam=2";
			}
			
			$.ajax({
				type:"POST"
				,async:false
				,url:contextBase + "isPayed.json"
				,dataType:"json"
				,data:"prmisnSeq=" + prmisnSeq+"&capp_tot="+paySum+"&pg_fee="+paySumCom/*개발행위허가 신청서 번호(PK)*/+bowanParam+"&prmisnType="+prmisnType
				,success: function(result) 
				{
					if(result.isPayedYn=="Y")//임시로 결제 건너뛰고 인허가 신청 처리
					{
						//fnInsertMinwon();
						if(reqstType != "DUR000080"){
							fnInsertMinwon();	
						} else {
							if(!progress.isShowing()){
								progress.start();
							}
							doAjaxSubmit(contextBase + "minwonmgmt/insertMinwonComplement.json", JSON.stringify({"prmisnSeq":$("input[name=prmisnSeq]").val()}), "json","json", "fnComplement");
						}
					}
					else if(result.isPayedYn=="NOT_MATCHED_PRICE")//결제 이력은 있으나, 결제된 금액이 계산된 수수료 금액과 같지 않은 경우 결제 취소 후 다시 결제 진행
					{
						"이전에 결제한 이력이 있으나, 해당 결제금액이 현재 계산된 수수료 금액과 같지 않습니다. 관리자에게 문의하여 결제를 취소한 후 다시 인허가 신청을 진행하세요.".alert();
					}
					else if(result.isPayedYn=="N")
					{
						if(vMountProg != undefined || vMountProg != null){
							if(farmCheck != "y"){
								if(reqstType != "DUR000080"){
									/* $.ajax({
										type:"POST"
										,async:false
										,url:"https://fcis.forest.go.kr/cntct/api"
										,dataType:"json"
										,data:"cntctInsttTpcd=02"+"&cntctCvappStcd=002"
										,success: function(result) 
										{
											console.log("result> " + result)
										}
									}); */
									fnInsertMinwon();
								}else{
									if(!progress.isShowing()){
										progress.start();
									}
									doAjaxSubmit(contextBase + "minwonmgmt/insertMinwonComplement.json", JSON.stringify({"prmisnSeq":$("input[name=prmisnSeq]").val()}), "json","json", "fnComplement");
								}
							}else if(farmPayYn == "결제완료"){
								fnInsertMinwon();
							}else{
								var temp = $("<div id=\"dialog\" class=\"wrapDesign ui-dialog-content ui-widget-content\" style=\"min-height: 106px; max-height: 856px; height: auto;\">" +
										"<div class=\"agree24Box\" style=\"margin:auto;\">" +
										"<h1 class='block'>민원24 전자지불시스템을 통해 [아래]의 민원 수수료를 납부하시는데 동의하십니까?</h1>" +
										"<fieldset class='payList'>" +
										"<legend><i class='axi axi-exclamation'></i>수수료 납부 내역</legend><ul>" +
										minwonList +
										"<li><span>총합계</span><span>" + (Number(paySum) + Number(paySumCom)).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li></ul></fieldset>" +
										"<div class='applyAgreeMsg text_left block floatRight'><span><label><input type='checkbox' id='minwonCheck' name='minwonCheck' onclick='fnConsent();'/>동의하셔야만 인터넷 민원신청이 가능합니다.</label></span></div>"+
										"<div id='paySelect' class='selectPayment dashed_line clearBoth' style='display:none;'>" +
										"<h1>결제방법을 선택해주세요.</h1>" +
										"<div class='payTypeSelect text_center'>" +
										"<a herf='' class='button tiny cyan' style='font-size:11px;' onclick='doPay(\"0402\")'>신용카드</a><span class='text_lightGray'> | </span>" +
										"<a herf='' class='button tiny cyan' style='font-size:11px;' onclick='doPay(\"0403\")'>계좌이체</a><span class='text_lightGray'> | </span>" +
										"<a herf='' class='button tiny cyan' style='font-size:11px;' onclick='doPay(\"0404\")'>모바일</a>" +
										"</div></div>" +
										"<div id='doPay' class='payInfo dashed_line' style='display:none;'></div>" + 
										"<button id=\"cancel\" class=\"button grayBlue\" onclick=\"modalPop.dialog('close');\" style=\"float:right\">취소</button>" +
										"<button id=\"submit\" class=\"button blue02\" onclick=\"paySubmit();\" style=\"float:right;margin-bottom:10px;\">결제</button></div></div></div>");
									modalPop = createLayerPopup("modalForm", "결제방법 선택", "auto", "600", temp);
									modalPop.dialog("open");
								
							}
						}else{
							
							var temp = $("<div id=\"dialog\" class=\"wrapDesign ui-dialog-content ui-widget-content\" style=\"min-height: 106px; max-height: 856px; height: auto;\">" +
									"<div class=\"agree24Box\" style=\"margin:auto;\">" +
									"<h1 class='block'>민원24 전자지불시스템을 통해 [아래]의 민원 수수료를 납부하시는데 동의하십니까?</h1>" +
									"<fieldset class='payList'>" +
									"<legend><i class='axi axi-exclamation'></i>수수료 납부 내역</legend><ul>" +
									minwonList +
									"<li><span>총합계</span><span>" + (Number(paySum) + Number(paySumCom)).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</spna></li></ul></fieldset>" +
									"<div class='applyAgreeMsg text_left block floatRight'><span><label><input type='checkbox' id='minwonCheck' name='minwonCheck' onclick='fnConsent();'/>동의하셔야만 인터넷 민원신청이 가능합니다.</label></span></div>"+
									"<div id='paySelect' class='selectPayment dashed_line clearBoth' style='display:none;'>" +
									"<h1>결제방법을 선택해주세요.</h1>" +
									"<div class='payTypeSelect text_center'>" +
									"<a herf='' class='button tiny cyan' style='font-size:11px;' onclick='doPay(\"0402\")'>신용카드</a><span class='text_lightGray'> | </span>" +
									"<a herf='' class='button tiny cyan' style='font-size:11px;' onclick='doPay(\"0403\")'>계좌이체</a><span class='text_lightGray'> | </span>" +
									"<a herf='' class='button tiny cyan' style='font-size:11px;' onclick='doPay(\"0404\")'>모바일</a>" +
									"</div></div>" +
									"<div id='doPay' class='payInfo dashed_line' style='display:none;'></div>" + 
									"<button id=\"cancel\" class=\"button grayBlue\" onclick=\"modalPop.dialog('close');\" style=\"float:right\">취소</button>" +
									"<button id=\"submit\" class=\"button blue02\" onclick=\"paySubmit();\" style=\"float:right;margin-bottom:10px;\">결제</button></div></div></div>");
								modalPop = createLayerPopup("modalForm", "결제방법 선택", "auto", "600", temp);
								modalPop.dialog("open");
						}
					}
					else
					{
						"결제 여부 확인중 오류가 발생하였습니다. 관리자에게 문의 후 이용 바랍니다.".alert();
					}
				}
				,error : function(){
					"결제 여부 확인중 오류가 발생하였습니다. 관리자에게 문의 후 이용 바랍니다.".alert();
				}
			});
		}
	}
	
	
}

function fnSubmitLast(){
	
	//.num132 type validation check
	if(!fnCheckNumType132())
	{
		return;
	}

	var workDateBgn=$("input[name=workDateBgn]").val().replace(/\-/gi,"");
	var workDateEnd=$("input[name=workDateEnd]").val().replace(/\-/gi,"");
	var thHeapBgn=$("input[name=thHeapBgn]").val().replace(/\-/gi,"");
	var thHeapEnd=$("input[name=thHeapEnd]").val().replace(/\-/gi,"");
	var today = new Date().format("yyyymmdd");
	var _reqstDate = $("input[name=reqstDate]").val().replace(/\-/gi,"");
	var pivutDate = today;
	
	if(vMountProg != undefined){
		if(vMountPayYn != "Y"){ //산지 결제여부 값이 Y가 아닌경우 신청 막기
			"산지 신청시 결제완료 후 신청 가능합니다. <br>결제완료 하신 경우 임시저장 버튼을 클릭한 후 신청하여 주세요.".alert();
			return false;
		}
	}
	
	
	if(_reqstDate!=null && _reqstDate!="" &&_reqstDate!=undefined)
	{
		pivutDate = _reqstDate;
	}
	
	if(workDateBgn!=null && workDateBgn!="" && workDateBgn!=undefined &&workDateEnd!=null && workDateEnd!="" && workDateEnd!=undefined  )
	{
		if(workDateBgn>workDateEnd)
		{
			"준공일자는 착공일자보다 빠를 수 없습니다.".alert();
			return false;
		}
	}
	if(thHeapBgn!=null && thHeapBgn!="" && thHeapBgn!=undefined &&thHeapEnd!=null && thHeapEnd!="" && thHeapEnd!=undefined  )
	{
		if(thHeapBgn>thHeapEnd)
		{
			"적치기간시작일은 적치기간종료일보다 빠를 수 없습니다.".alert();
			return false;
		}
	}
	if(workDateBgn==null || workDateBgn=="" || workDateBgn==undefined || workDateEnd==null || workDateEnd=="" || workDateEnd==undefined) {
		"착공일자/준공일자를 입력해주시기 바랍니다.".alert();
		return false;
	} else if (fnCpttrReprsntYnCheck()){
		//민원신청시 개인정보 동의 추가되어 변경된 소스(2021.02.25 LeeJI)
		var temp = $("<div id=\"dialog\" class=\"wrapDesign\"><table width=\"100%\" height=\"100%\" style=\"background: #fff;\" cellpadding=\"5px\" cellspacing=\"3px\">"+
				"<tr><td align=\"center\" valign=\"center\" colspan=\"2\">"+
				"<h2 style=\"font-size: 16px;text-align: left;font-weight: bold;margin-bottom: 10px;\">○ 개인정보  수집 및 이용에 대한 안내(민원신청정보)</h2>"+
				"<h2 style=\"font-size:14px;line-height:25px;font-weight: 500;color: #666;text-align: left;border: 1px solid #ddd;background: #eee;padding: 15px;border-radius: 10px;height: 100px;overflow-x: hidden;\">"+
				"수집하는 개인정보의 항목<br>"+
				"통합인허가지원서비스 사이트(이하 “IPSS”)에서는 정보주체의 동의에 의해서만 수집·보유합니다. 단, 서비스 이용과정에서 발생하는 로그정보(“아이피 주소”, “로그인 일시”, “서비스 이용기록” 등)는 자동으로 수집됩니다.<br>"+
				"IPSS는 다음의 개인정보 항목을 처리하고 있습니다.<br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">· 통합인허가 민원신청정보 : 이름, 생년월일, 휴대전화 번호, 주소</span><br>"+
				"<span style=\"font-size:17px;font-weight: bold;color: blue;text-decoration: underline;\">보존기간 : 준영구 </span><br>"+
				"<br>개인정보의 수집, 이용 목적<br>"+
				"IPSS에서는 다음의 목적을 위해 개인정보를 수집 및 이용합니다. 수집된 개인정보는 정해진 목적 이외의 용도로는 이용되지 않으며 수집 목적이 변경될 경우 사전에 알리고 동의를 받을 예정입니다.<br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">회원제 서비스에 따른 본인 식별·인증, 부정 이용방지 등을 위한 목적으로 개인정보를 처리.민원사무 처리 및 신청·열람·발급서비스 제공.</span><br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">민원 신청서에 포함된 개인정보는 전자정부법 제9조에 의한 민원사무 처리를 위한 목적으로 민원접수기관 및 처리기관에서 이용합니다.</span><br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">민원사무의 전자적 처리를 위해 내부적으로 타 행정기관 시스템 연계 시 개인정보를 이용합니다.</span><br>"+
				"<br>회원 가입 및 서비스관리<br>"+
				"회원가입, 회원제 서비스 이용 및 제한적 본인 확인절차에 따른 본인확인, 부정이용 방지, 비인가 이용방지, 가입의사 확인, 만 14세 미만 아동 개인정보 수집 시 법정대리인 동의여부 확인, 추후 법정대리 본인확인, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달 등을 목적으로 개인정보를 처리합니다.<br>"+
				"개인정보 수집에대한 동의를 거부하시는 경우에는 개발행위허가서비스 이용이 불가합니다.<br>"+
				"</h2></td></tr><tr><td style=\"text-align: center;\"><input type=\"radio\" name=\"agree\" value=\"agreement\" checked><h3 style=\"display: inline;\">동의</h3><input type=\"radio\" name=\"agree\" value=\"disagree\" style=\"margin-left:30px;\"><h3 style=\"display: inline;\">미동의</h3></td></tr><tr><td align=\"center\">"+
				"<h2 style=\"font-size: 16px;text-align: left;font-weight: bold;margin-bottom: 10px;\">○ 개인정보(선택정보)수집 및 이용에 대한 안내(민원신청정보)</h2>"+
				"<h2 style=\"font-size:14px;line-height:25px;font-weight: 500;color: #666;text-align: left;border: 1px solid #ddd;background: #eee;padding: 15px;border-radius: 10px;height: 100px;overflow-x: hidden;\">"+
				"수집하는 개인정보의 항목<br>"+
				"통합인허가지원서비스 사이트(이하 “IPSS”)에서는 정보주체의 동의에 의해서만 수집·보유합니다. 단, 선택항목에 해당하는 정보를 입력하지 않으셔도 회원가입 및 서비스 이용에는 제한이 없습니다.<br>"+
				"IPSS는 다음의 개인정보 선택항목을 구분하고 있습니다.<br>"+
				"· 민원신청정보 선택동의 항목 : 유선전화번호, 이메일주소"+
				"<br><br>개인정보의 수집, 이용 목적<br>"+
				"IPSS에서는 다음의 목적을 위해 개인정보를 수집 및 이용합니다. 수집된 개인정보는 정해진 목적 이외의 용도로는 이용되지 않으며 수집 목적이 변경될 경우 사전에 알리고 동의를 받을 예정입니다.<br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">회원제 서비스에 따른 본인 식별·인증, 부정 이용방지 등을 위한 목적으로 개인정보를 처리.민원사무 처리 및 신청·열람·발급서비스 제공.</span><br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">민원 신청서에 포함된 개인정보는 전자정부법 제9조에 의한 민원사무 처리를 위한 목적으로 민원접수기관 및 처리기관에서 이용합니다.</span><br>"+
				"<span style=\"font-size:17px;font-weight: bold;text-decoration: underline;\">민원사무의 전자적 처리를 위해 내부적으로 타 행정기관 시스템 연계 시 개인정보를 이용합니다.</span><br>"+
				"<br>회원 가입 및 서비스관리<br>"+
				"회원가입, 회원제 서비스 이용 및 제한적 본인 확인절차에 따른 본인확인, 부정이용 방지, 비인가 이용방지, 가입의사 확인, 만 14세 미만 아동 개인정보 수집 시 법정대리인 동의여부 확인, 추후 법정대리 본인확인, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달 등을 목적으로 개인정보를 처리합니다.<br>"+
				"개인정보(선택적)수집에 대한 동의를 거부하시는 경우에도 통합인허가민원서비스 이용에 제한이업습니다.<br>"+
				"</h2></td></tr><tr><td style=\"text-align: center;\"><input type=\"radio\" name=\"agreeChoose\" value=\"agreementChoose\" checked><h3 style=\"display: inline;\">동의</h3><input type=\"radio\" name=\"agreeChoose\" value=\"disagreeChoose\" style=\"margin-left:30px;\"><h3 style=\"display: inline;\">미동의</h3></td></tr><tr><td align=\"center\">"+
				"<h2 style=\"color: #76B091 ;text-align: center;\">개인정보 수집 및 이용에 대한 안내(민원신청정보)는 필수동의 항목 입니다.<br>신청서 접수시 수정할 수 없습니다.</h2></td></tr><tr><td align=\"center\">"+
				"<button id=\"submit\" class=\"button grayBlue\" onclick=\"modalPop.dialog('close');\"style=\"float:right\"><h4>취소</h4></button>"+
				"<button id=\"cancel\" class=\"button blue02\" onclick=\"fnSubmit();\" style=\"float:right\">"+
				"<h4>확인</h4></button></td></tr></table></div>");
				modalPop = createLayerPopup("modalForm", "개인정보 수집동의", "auto", "760", temp);
				modalPop.dialog("open");
	}
}

/* 수수료로 인한 신청 소스 수정 */
function showTable(id){
	if(id != "mwInfo") {
		if($("#" + id).is(":hidden")){
			$("#" + id).show(0,"",function(){});
			$("#" + id + "Link").parent().removeClass("bgBlue");
			$("#" + id + "Link").html("<button class=\"button flat txtBlack\" onclick=\"showTable('"+id+"'); return false;\"style=\"width:70px; height:30px; line-height: 0px;\"><span>접  기</span><i class='axi axi-ion-chevron-up'></i></button>");
			
		} else {
			$("#" + id).hide(0,"",function(){});
			$("#" + id + "Link").parent().addClass("bgBlue");
			// $("#" + id + "Link").html("<button class=\"button flat txtWhite\" onclick=\"showTable('"+id+"'); return false;\"style=\"width:105px; height:30px; line-height: 0px;\"><span>펼치기</span><i class='axi axi-ion-chevron-down'></i></button>");
			$("#" + id + "Link").html("<button class=\"button flat txtWhite\" onclick=\"showTable('"+id+"'); return false;\"style=\"width:77px; height:30px; line-height: 0px;\"><span>펼치기</span><i class='axi axi-ion-chevron-down'></i></button>");
		}
	}
	var temp = 0;
	$("#mwInfo,#jibunTbody,#mwContent,#mwFile").each(function(index, value){
		if($(value).is(":visible")){
			temp += 1;
		}
	});
	if(temp == 4){
		$("#divShowTable").html("<button class=\"button  flat txtWhite\" style=\"width: 90px;height: 30px; line-height: 0px;\" onClick=\"fnAllTableShow('hide');\"><span>모두 접기</span><i class='axi axi-ion-chevron-up' style='float:right;'></i></button>");
	} else {
		$("#divShowTable").html("<button class=\"button  flat txtWhite\" style=\"width: 77px;height: 30px; line-height: 0px;\" onClick=\"fnAllTableShow('show');\"><span>모두 펼치기</span><i class='axi axi-ion-chevron-down' style='float:right;'></i></button>");
	}
	$(window).trigger("resize");
}

function fnAllTableShow(index){
	if(index == "show"){
		$("#mwInfo").show();
		$("#jibunTbody").show();
		$("#mwContent").show();
		$("#mwFile").show();
		
		$("#mwInfoLink").parent().removeClass("bgBlue");
		$("#jibunTbodyLink").parent().removeClass("bgBlue");
		$("#mwContentLink").parent().removeClass("bgBlue");
		$("#mwFileLink").parent().removeClass("bgBlue");
				
// 		$("#mwInfoLink").html(	"<div class='pageSize floatRight'>" +
// 								"<button class='button blue02 topImg' onclick='fnAgendaInfo();'>의제신청 정보 불러오기</button>" +
// 								"<button class='button circleBt3 topImg' style='margin-left: 10px;' onclick='fnAgendaHelp();'><i class='axi axi-question text_16'></i></button>" +
// 								"<button class=\"button flat txtBlack\" style=\"width: 90px;height: 30px; line-height: 0px;\" onClick=\"fnAllTableShow('hide');\"><span>모두 접기</span><i class='axi axi-ion-chevron-up' style='float:right;'></i></button>" +
// 								"</div>");
		$("#jibunTbodyLink").html("<button class=\"button flat txtBlack\" onclick=\"showTable('jibunTbody'); return false;\"style=\"width:70px; height:30px; line-height: 0px;\"><span>접  기</span><i class='axi axi-ion-chevron-up'></i></button>");
		$("#mwContentLink").html("<button class=\"button flat txtBlack\" onclick=\"showTable('mwContent'); return false;\"style=\"width:70px; height:30px; line-height: 0px;\"><span>접  기</span><i class='axi axi-ion-chevron-up'></i></button>");
		$("#mwFileLink").html("<button class=\"button flat txtBlack\" onclick=\"showTable('mwFile'); return false;\"style=\"width:70px; height:30px; line-height: 0px;\"><span>접  기</span><i class='axi axi-ion-chevron-up'></i></button>");
	}
	else if(index == "hide"){
		$("#mwInfo").hide();
		$("#jibunTbody").hide();
		$("#mwContent").hide();
		$("#mwFile").hide();

		$("#mwInfoLink").parent().addClass("bgBlue");
		$("#jibunTbodyLink").parent().addClass("bgBlue");
		$("#mwContentLink").parent().addClass("bgBlue");
		$("#mwFileLink").parent().addClass("bgBlue");
		
		$("#mwInfoLink").html("<button class=\"button flat txtWhite\" style=\"width: 101px;height: 30px; line-height: 0px;\" onClick=\"fnAllTableShow('show');\"><span>모두 펼치기</span><i class='axi axi-ion-chevron-down' style='float:right;'></i></button>");
		$("#jibunTbodyLink").html("<button class=\"button flat txtWhite\" onclick=\"showTable('jibunTbody'); return false;\"style=\"width:77px; height:30px; line-height: 0px;\"><span>펼치기</span><i class='axi axi-ion-chevron-down'></i></button>");
		$("#mwContentLink").html("<button class=\"button flat txtWhite\" onclick=\"showTable('mwContent'); return false;\"style=\"width:77px; height:30px; line-height: 0px;\"><span>펼치기</span><i class='axi axi-ion-chevron-down'></i></button>");
		$("#mwFileLink").html("<button class=\"button flat txtWhite\" onclick=\"showTable('mwFile'); return false;\"style=\"width:77px; height:30px; line-height: 0px;\"><span>펼치기</span><i class='axi axi-ion-chevron-down'></i></button>");
	}
}


function fnAgendaInfo(){
	var dt = new Date('07/16/2018');
	var currentDt = new Date();
	/*2018-06-27 세움터 디비 통합 작업*/
	if(dt > currentDt){
		alert("세움터 데이터베이스 통합 작업으로 인하여 2018년 7월 16일까지  해당 기능을 사용할 수 없습니다.");
	}else{
		var temp = $(	"<div id='dialog' class='agendaInfo'>" +
						"<p class='contentsPara text_center'>" +										
						"인터넷 의제신청정보를 불러 오시면 저장되지 않은 입력 정보는 사라집니다.</p>" +
						"<div class='btnBox text_center'>" +
						"<button class='button blue02' onclick=\"fnAgendaRequest();\">확인</button>" + 
						"<button class='button grayBlue' onclick=\"modalPop.dialog('close');\">취소</button>" +
						"</div></div>");
			modalPop = createLayerPopup("modalForm", "의제신청 정보", "auto", "600", temp);
			modalPop.dialog("open");
	}
}

function fnAgendaHelp(){
	var temp = $(	"<div id='dialog' class='agendaHelp'>" +
					"<div class='noticeMsgBox'>" +
					"<div class='leftBox01'>" +
					"<i class='axi axi-download2'></i>" +
					"</div>" +
					"<div class='rightBox01'>" +
					"<p class='contentsPara'>" +
					"세움터, 공장설립온라인지원시스템(FEMIS)에서 접수된 인터넷 개발행위 의제협의 정보를 불러올 수 있습니다.</p>" +
					"</div>" +
					"<div class='leftBox02'>" +
					"<p class='contentsPara'>" +
					"해당정보를 사용하기 위해서는 세움터, FEMIS 온라인 접수번호가 필요하며 본 신청서 작성인이 세움터, femis의 신청인 또는 대리인으로 저장된 의제협의 신청건 이여야 합니다.</p>" +
					"</div>" +
					"<div class='rightBox02'>" +
					"<i class='axi axi-paper'></i>" +
					"</div></div></div>");
		modalPop = createLayerPopup("modalForm", "의제신청 정보", "auto", "600", temp);
		modalPop.dialog("open");
}

function fnPrint() {
	var type = 0;
	$("#mwInfo input.type:checked").each(function(i, v){
		type += Number($(v).val());
	});
	$("input[name='type']").val(type.toString().lpad(5,"0"));
	var temp = $("#mwContent input, #mwContent textarea").fnSerializeObject();
	temp.thHeapDuration = (new Date(temp.thHeapEnd) - new Date(temp.thHeapBgn)) / 3600 / 24 / 1000;
	if(temp.thHeapDuration.length){
		if(temp.thHeapDuration < 30) {
			temp.thHeapDuration = 1;
		} else {
			temp.thHeapDuration = parseInt(temp.thHeapDuration / 30);
		}
	}
	if(temp.thHeapBgn.length) {
		temp.thHeapBgn = new Date(temp.thHeapBgn).format("yyyy년mm월dd일");
	}
	if(temp.thHeapEnd.length) {
		temp.thHeapEnd = new Date(temp.thHeapEnd).format("yyyy년mm월dd일");
	}
	if(temp.workDateBgn.length) {
		temp.workDateBgn = new Date(temp.workDateBgn).format("yyyy년mm월dd일");
	}
	if(temp.workDateEnd.length) {
		temp.workDateEnd = new Date(temp.workDateEnd).format("yyyy년mm월dd일");
	}
	
	temp.applicant = applicant.toArray();
	temp.jibun = jibun.toArray();
	
	var tempDivP = new Array();
	var tempDivS = new Array();
	jibun.each(function(i,v){
		tempDivP.push(v.divP);
		tempDivS.push(v.divS);
	});
	tempDivP = tempDivP.filter(function(v){return fnNvl(v)!=""});
	tempDivS = tempDivS.filter(function(v){return fnNvl(v)!=""});
	temp.divP = tempDivP.join(",");
	temp.divS = tempDivS.join(",");
	temp.regDate = "";
	doAjaxSubmit(contextBase + "minwonmgmt/viewPrmisnDoc.do", JSON.stringify(temp), "html", "json", "fnPrintCallback");
}
function fnPrintCallback(response) {
	var pop = window.open("", "_blank");
	var doc = pop.document.open("text/html", "replace");
	doc.write(response);
	pop.window.print();
}
function fnAgendaChk(){
	 if($("input:checkbox[name='agendaFilesChkBox']").is(":checked")) {
		 if($("input[name=fileGroupSeq]").val()) {
			 $("input[name=agendaFilesChkBox]").prop("checked",false);
			// "<p style='margin-bottom:10px;'>의제협의 관련 파일 및 수수료 정보들이 <span style='color:red;font-weight:600;font-size:14px;'>삭제</span>됩니다.</p><p>동의하십니까?</p>".confirm(window.fnDeleteAgendaFiles)
		 } else {
			 $("#agendaFilesButton").html("<span><button style=\"width: calc(100% - 15px);cursor: default;\" class=\"button gray w98\" disabled>의제협의 관련사항 없음</button></span>");
		 }
	 } else {
		 $("#agendaFilesButton").html("<span><button style=\"width: calc(100% - 15px);\" class=\"button blue02\" onclick=\"fnAgendaOnClick();\">의제협의 서류등록</button></span>");
	 }
}
//산정된 수수료 삭제
function fnDeletePay(response){
	if(response){
		if(response.tnCmnMsgVo.smsgCd == "SUCCESS") {
			//삭제 완료
		} else {
			"삭제에 실패하였습니다.".alert();
			//되돌리기
		}
	} else {
		doAjaxSubmit(contextBase + "minwonmgmt/deletePay.json", JSON.stringify({fileGroupSeq:$("input[name=fileGroupSeq]").val()}), "json", "html", "fnDeletePay");
	}
}
function fnDeleteAgendaFiles(response) {
	if(response) {
		if(response.tnCmnMsgVo.smsgCd == "SUCCESS"){
			$("#agendaFilesButton").html("<span><button style=\"width: calc(100% - 15px);cursor: default;\" class=\"button gray w98\" disabled>의제협의 관련사항 없음</button></span>");
			$("input[name=agendaFilesChkBox]").prop("checked",true);
		} else {
			"정보 삭제에 실패하였습니다.".alert();
			$("input[name=agendaFilesChkBox]").prop("checked",true);
		}
	} else {
		doAjaxSubmit(contextBase+"minwonmgmt/deleteAgendaFiles.json", JSON.stringify({"fileGroupSeq":$("input[name=fileGroupSeq]").val()}), "json", "json", "fnDeleteAgendaFiles");
	}
}

function fnTemporarySave() // 임시저장 버튼 클릭시 실행하는 함수
{
	
	//.num132 type validation check
	if(!fnCheckNumType132())
	{
		if(progress.isShowing())
		{
			progress.stop();
		}
		return;
	}
	
	if(!progress.isShowing()){
		progress.start();
	}
	$("#mwContent input, #mwContent textarea").each(function(i,v){
		$(v).val($(v).val() == $(v).attr("placeholder")?"":$(v).val());
	});
	$("#mwContent input[name='reqstSttus']").val("DAS009000");//DAS009000 임시저장
	$("input[name=siteCode]").val($("#riCd").val().substr(0,5));
	
	var typeCd = 0;
	if($("#chkHandicraft").is(":checked")) typeCd += 10000;
	if($("#chkTranformation").is(":checked")) typeCd += 1;
	if($("#chkCollection").is(":checked")) typeCd += 1000;
	if($("#chkDivision").is(":checked")) typeCd += 100;
	if($("#chkHeap").is(":checked")) typeCd += 10;
	$("input[name=type]").val(typeCd.toString().lpad(5,"0"));
	
	
	var workDateBgn=$("input[name=workDateBgn]").val().replace(/\-/gi,"");
	var workDateEnd=$("input[name=workDateEnd]").val().replace(/\-/gi,"");
	var thHeapBgn=$("input[name=thHeapBgn]").val().replace(/\-/gi,"");
	var thHeapEnd=$("input[name=thHeapEnd]").val().replace(/\-/gi,"");
	var today = new Date().format("yyyymmdd");
	//alert("workDateBgn : " + workDateBgn);
	var _reqstDate = $("input[name=reqstDate]").val().replace(/\-/gi,"");
	var pivutDate = today;
	
	if(_reqstDate!=null && _reqstDate!="" &&_reqstDate!=undefined)
	{
		pivutDate = _reqstDate;
	}
	
	if(workDateBgn!=null && workDateBgn!="" && workDateBgn!=undefined &&workDateEnd!=null && workDateEnd!="" && workDateEnd!=undefined  )
	{
		if(workDateBgn>workDateEnd)
		{
			"준공일자는 착공일자보다 빠를 수 없습니다.".alert();
			if(progress.isShowing())
			{
				progress.stop();
			}
			return false;
		}
	}
	if(thHeapBgn!=null && thHeapBgn!="" && thHeapBgn!=undefined &&thHeapEnd!=null && thHeapEnd!="" && thHeapEnd!=undefined  )
	{
		if(thHeapBgn>thHeapEnd)
		{
			"적치기간시작일은 적치기간종료일보다 빠를 수 없습니다.".alert();
			if(progress.isShowing())
			{
				progress.stop();
			}
			return false;
		}
	}
	if(fnCpttrReprsntYnCheck()) {// commonMinwon.js > *신청인/대리인 대표자 지정 check*
		if(!droppers.length || !droppers[0].postData.fileGroupSeq) {// 신규등록
			doAjaxSubmit(contextBase + "cmnmgmt/createFileGroupSeq.json", "", "json", "json", "fnSetFileGroupSeq");
		} else if($("#mwContent input[name='fileGroupSeq']").val()){// 재등록
			$("#mwInfo input[name='fileGroupSeq']").val(droppers[0].postData.fileGroupSeq);
			//임시저장
			$("#mwContent input[name='reqstSttus']").val("DAS009000");
			$("#mwContent input[name='reqstType']").val("DAS009000");
			doAjaxSubmit(contextBase + "minwonmgmt/insertAndUpdateTnPrmisnDoc.json", JSON.stringify($("#mwContent input, #mwContent textarea").fnSerializeObject()), "json", "json", "fnTemporarySaveCallback")// 콜백함수 response 바로아래
		}
	}
}

function fnTemporarySaveCallback(response){// response
	// alert("response.prmisnSeq : " + response.prmisnSeq);//656
	// alert("response.prmisnCode : " + response.prmisnCode);//TM000000002450
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
		$("#mwContent input[name='prmisnCode']").val(response.prmisnCode);
		$("#mwContent input[name='prmisnSeq']").val(response.prmisnSeq);
		
		if($("input[name='prmisnSeq']").val() == null || $("input[name='prmisnSeq']").val() == "") {
			fnTemporarySaveJibunCallback({tnCmnMsgVo:{smsgBody:"FAIL"}});
		} else {
			var param = new Array();
			if(jibun.toArray().length) {
				jibun.each(function(i, v){
					v.prmisnSeq = $("#mwContent input[name='prmisnSeq']").val();
					param.push(v);
				});
			}
			if(jibunDelArr.length) {
				$.each(jibunDelArr, function(i,v){
					param.push(v);
				});
			}
			if(param.length) { // param = new Array(); 0이면 false 1이상이면 true
				doAjaxSubmit(contextBase + "minwonmgmt/iuwebInsertTnPrmisnLadInfo.json", JSON.stringify(param),"json","json", "fnTemporarySaveJibunCallback");
			} else {
				fnTemporarySaveJibunCallback({tnCmnMsgVo:{smsgBody:"SUCCESS"}});
			}
		}
	} 
	else 
	{
		if(progress.isShowing())
		{
			progress.stop();
		}
		"임시저장 처리에 실패하였습니다. 관리자에게 문의 바랍니다.".alert();
		
	}
}
function fnTemporarySaveJibunCallback(response) {
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
		var temp = fnClone(applicant.toArray());
		var param = new Array();
		$.each(temp, function(i,v){
			v.prmisnSeq = $("input[name='prmisnSeq']").val();
			param.push(v);
		});
		doAjaxSubmit(contextBase + "minwonmgmt/iuwebInsertListTnReqstCpttr.json", JSON.stringify(param),"json", "json", "fnTemporarySaveCpttrCallback");
	} else {
		if(progress.isShowing()){
			progress.stop();
		}
		"지번 저장 실패".alert();
	}
}
function fnTemporarySaveCpttrCallback(response){
	if(response.result == "SUCCESS") {
		// 동일한 대리인 이지만 각각의 다른 신청인이 지정한 대리인이므로 agent_seq가 다름
		// agent는 view용, tmpAgent는 data insert용
		var array = new Array();
		if(tmpAgent.toArray().length) {
			array = array.concat(fnClone(tmpAgent.toArray()));
		} else {
			array = array.concat(fnClone(agent.toArray()));
		}
		var param = new Array();
		$.each(array, function(i,v){
			v.prmisnSeq = $("input[name='prmisnSeq']").val();
			v.agentReprsntYn = v.reprsntYn;
			param.push(v);
		});
		if(param.length==0)
		{
			param.push({prmisnSeq :$("input[name='prmisnSeq']").val()});
		}
		param.push({userSeq : userSeq });
		doAjaxSubmit(contextBase + "minwonmgmt/insertAgentCpttrProcDtls.json", JSON.stringify(param),"json","json", "fnTemporarySaveAgentCpttrCallback");
	} else {
		"신청인 정보 저장 실패".alert();
		if(progress.isShowing()){
			progress.stop();
		}
	}
}
//function fnTemporarySaveCpttrCallback(response){
function fnTemporarySaveAgentCpttrCallback(response){
	if(progress.isShowing()){
		progress.stop();
	}
	if(response.result == "SUCCESS") {
		//"저장에 성공하였습니다".complete();
		"임시 저장에 성공하였습니다.".complete(function(){fnDoPost("minwonmgmt/viewInsertMinwon.do", {seq:$("input[name='prmisnSeq']").val()})});
	} else {
		//"신청인/대리인 정보 저장 실패".alert();
		"대리인 정보 저장 실패".alert();
	}
}
function selectCadastralInfo() {
	"토지정보 불러오기시 저장되지 않은 토지정보는 사라집니다.".confirm(function(){
		jibun.each(function(i, v){
			$.ajax({
				type:"POST"
				,	async:true
				,	url:contextBase + "linkmgmt/selectLndInfo.json"
				,	dataType:"application/json; charset=UTF-8"
				,	data:"pnu=" + v.ladPnu
				,	contentType:"application/x-www-form-urlencoded; charset=UTF-8"
				,	complete: function(_this) {
						var response = _this.responseText;
						try {
							response = $.parseJSON(response);
						} catch (err) {
							
						}
						this._callback(response)
					}
				,	_callback : function(response) {
					if(response.spfc){
						v.spfc = response.spfc;
						v.spfcNm = response.spfcNm;
					} else
						v.spfcNm = "정보없음";
					if(response.spcfc){
						v.spcfc = response.spcfc;
						v.spcfcNm = response.spcfcNm;
					} else
						v.spcfcNm = "정보없음";
					if(response.lndcgr){
						v.lndcgr = response.lndcgr;
						v.lndcgrNm = response.lndcgrNm;
					} else
						v.lndcgrNm = "정보없음";
					jibun.each(jibun.change);
				}
			});
		});
	});
}
function fnDownloadCsv(){
	if(getBrowser().includes("IE") && getBrowser().includes("9")){
		"Internet Explorer 9 은 양식파일 저장시 텍스트파일(*.txt) 로 선택한 후 저장하셔야 합니다.".confirm(function(){
			var pop = window.open(contextBase+"file/guideDownload.do?fileNm=address.csv");
		 	pop.document.close();
		 	pop.document.execCommand("SaveAs", true, "address.csv");
		 	pop.close();
		});
	} else {
		var temp = $("<a href=\"<c:url value='/file/guideDownload.do?fileNm=address.csv'/>\" download></a>")[0];
		temp.click();
	}
}
function fnAddFromCsv(target) {
	function success(data){
		try{
			var succesMsg = false;
			data = JSON.parse(data);
	        if(data.result == "SUCCESS"){
	        	var riCd = $("#riCd").val();
	        	var txtAddr = $("#txtAddr").val();
	        	jibun.clear();
	        	$.each(data.list, function(i, v){
	        		v.ladAddrPre = txtAddr;
	        		var isSan = 1;
	        		if(v.ladAddrSuf.startsWith("산")) {
	        			isSan = 2;
	        		}
	        		var temp = v.ladAddrSuf.match(/([0-9]{0,})/g);
	        		var addrSuf = [];
	        		$.each(temp, function(i, v){
	        			if(v.length){
	        				addrSuf.push(v);
	        			}
	        		});
	        		v.ladPnu = riCd + isSan + addrSuf[0].lpad(4,"0") + addrSuf[1].lpad(4,"0");
	        		jibun.unshift(v);
	        		/* "CSV 불러오기 완료".complete(); */
	        		succesMsg = true;
	        	});
	        } else {
	        	("CSV 읽어오기 실패<br>" + data.msg).alert();
	        }
	        if(succesMsg)
	        	"CSV 불러오기 완료".complete();
		} catch(e) {
			
		}
	}
	if($("#riCd").val().length && $("#txtAddr").val().length) {
		alert("파일 추가시 저장되지 않은 지번 정보는 사라집니다.");
		var file = $(target);
		var errorMsg = "";
		if(getBrowser().startsWith("MSIE") && parseInt(getBrowser().split(" ")[1]) <= 9) {
			var form = file.parent();
			var frameNm = "tempFrame" + parseInt(Math.random()*100000).toString().lpad("0",5);
			var iframe = $("<iframe style='position:absolute; left: 500px;'/>").attr("name",frameNm);
			iframe.css({
				"position":"absolute",
				"left":"-1000",
				"top":"-1000"
			});
			iframe[0].onload = function(){
				var data = iframe.contents().text();
				success(data);
				iframe.remove();
			};
			$("body").append(iframe);
			form.attr({
				"action" : contextBase + "cmnmgmt/csvToTnLadInfo.json",
				"enctype" : "multipart/form-data",
				"target" : frameNm,
				"method" : "POST"
			});
			form.submit();
// 			form.ajaxSubmit({
// 				url:contextBase+"cmnmgmt/csvToTnLadInfo.json",
// 				method:"POST",
// 				iframe:true,
// 				contentType:"multipart/form-data",
// 				success: success(data)
// 			});
		} else {
			var data = new FormData();
			$.each(file[0].files, function(i, v) {
				data.append('file-' + i, v);
			});
			$.ajax({
				type: 'POST',
				url: contextBase + 'cmnmgmt/csvToTnLadInfo.json',
				data: data,
				success: success,
                error: function(jqXHR, textStatus, errorThrown) {
                },
                processData: false,
                contentType: false
			});
		}
	} else {
		"주소부터 입력하세요".alert();
	}
	$(target).wrap('<form>').closest('form').get(0).reset();
}
function fnInsertMinwon(response){
	
	if(!progress.isShowing()){
		progress.start();
	}
/* 	if($("input[type=radio][name=agree]:checked").val() == "disagree"){
		"신청서 정보 제공 동의를 선택하셔야 진행할 수 있습니다.".alert();
		progress.stop();
	}else{ */
	
		/*신청인/대리인 대표자 지정 check*/
	if(fnCpttrReprsntYnCheck()) {
		if(applicant.array.length == 0){
			"신청인 정보를 입력해 주세요.".alert();
			progress.stop();
		}else if(jibun.array.length == 0){
			"신청위치 정보를 입력해 주세요.".alert();
			progress.stop();
		}else if(!$("input:checkBox[class=type]:checked").val()){
			"신청내용을 선택해 주세요.".alert();
			progress.stop();
		}
		else{
			if(droppers.length){
				var fileExist = false;
				for(i = 0; i < droppers.length ; i++){
					if(droppers[i].total > 0)
						fileExist = true;
				}
				if($("#mwFile .fileListItem").length > 0){
					fileExist = true;
				}
				if(!fileExist){
					"첨부서류 등록을 해야 민원신청이 진행됩니다.".alert();
					progress.stop();					
				}else{
					// 대리인일경우 위임장 파일 여부 체크
					var agentFileExist = false;
					if(userType == 'DAU000020') {
						var totalCnt = $("#mwInfo .fileListItem").length;
						if(totalCnt > 0) {
							if(agent.array.length != totalCnt) {
								"대리인 목록과 위임장 파일 개수가 다릅니다.".alert();	
								progress.stop();
								return false;
							} else {
								var tmpArr = new Array;
								var fileListCnt = $("#deligationFileList .fileListItem").length;
								if(fileListCnt > 0) {
									for (var j = 0; j < fileListCnt; j++) {
										var fileNm = $("#deligationFileList .fileListItem").eq(j).find("a").text();
										tmpArr.push(fileNm.substring(0, fileNm.indexOf('.')));
									}									
								}
								var getFileListCnt = $(".getDeligationFiles .fileListItem").length;
								if(getFileListCnt > 0) {
									for (var x = 0; x < getFileListCnt; x++) {
										var fileNm = $(".getDeligationFiles .fileListItem").eq(x).attr("id");
										tmpArr.push(fileNm.substring(0, fileNm.indexOf('_')));
									}									
								}
								var tmpCnt = 0;
								$.each(agent.toArray(), function(i,v) {
									for (var y = 0; y < tmpArr.length; y++) {
										if(v.presidentNm == tmpArr[y]) {
											tmpCnt++;
											break;
										}
									}	
								});
								if(agent.array.length != tmpCnt) {
									"대표자명과 같지 않은 위임장 파알이 존재합니다.".alert();	
									progress.stop();
									return false;
								} else {
									agentFileExist = true;
								}
							}
						}
					} else {
						agentFileExist = true;
					}
					
					if(!agentFileExist) {
						"대리인 위임장관련파일 등록을 해야 민원신청이 진행됩니다.".alert();
						progress.stop();
					} else {
						
						if(!$("#mwContent input[name='prmisnSeq']").val() && !response) 
						{
							
							$("#mwContent input[name='reqstSttus']").val("DAS009000");//DAS009000 임시저장
							var tempSiteCode = $("#riCd").val().substr(0,5);
							if(tempSiteCode == "41173" || tempSiteCode == "41171"){
								tempSiteCode = "41170";
							}
							$("input[name=siteCode]").val(tempSiteCode);
							
							var typeCd = 0;
							if($("#chkHandicraft").is(":checked")) typeCd += 10000;
							if($("#chkTranformation").is(":checked")) typeCd += 1;
							if($("#chkCollection").is(":checked")) typeCd += 1000;
							if($("#chkDivision").is(":checked")) typeCd += 100;
							if($("#chkHeap").is(":checked")) typeCd += 10;
							$("input[name=type]").val(typeCd.toString().lpad(5,"0"));
							$("#mwInfo input[name='fileGroupSeq']").val(droppers[0].postData.fileGroupSeq);
							//임시저장
							$("#mwContent input[name='reqstSttus']").val("DAS009000");
							$("#mwContent input[name='reqstType']").val("DAS009000");
							$("#mwContent input:not([type=hidden]):hidden, #mwContent textarea:not([type=hidden]):hidden").disable();
							
							doAjaxSubmit(contextBase + "minwonmgmt/insertAndUpdateTnPrmisnDoc.json", JSON.stringify($("#mwContent input, #mwContent textarea").fnSerializeObject()), "json", "json", "fnInsertMinwon")	;	
						} else if(response) {
							
							if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
								
								$("#mwContent input[name='prmisnCode']").val(response.prmisnCode);
								$("#mwContent input[name='prmisnSeq']").val(response.prmisnSeq);
								
								
								if($("input[name='prmisnSeq']").val() == null || $("input[name='prmisnSeq']").val() == "") {
									
									fnSaveJibunCallback({tnCmnMsgVo:{smsgBody:"FAIL"}});
								} else {
									
									if(jibun.toArray().length) {
										var temp = fnClone(jibun.toArray());
										var param = new Array();
										$.each(temp, function(i, v){
											/*if(!v.prmisnSeq){
												jibun.toArray()[i].prmisnSeq = $("input[name='prmisnSeq']").val();
												param.push(v);
											}*/
											v.prmisnSeq = $("#mwContent input[name='prmisnSeq']").val();
											param.push(v);
										});
										if(jibunDelArr.length) {
											$.each(jibunDelArr, function(i,v){
												param.push(v);
											});
										}
										
										if(param.length) {
											//doAjaxSubmit(contextBase + "minwonmgmt/insertTnPrmisnLadInfo.json", JSON.stringify(param),"json", "json", "fnSaveJibunCallback");
											
											doAjaxSubmit(contextBase + "minwonmgmt/iuwebInsertTnPrmisnLadInfo.json", JSON.stringify(param),"json", "json", "fnSaveJibunCallback");
										} else {
											
											fnSaveJibunCallback({tnCmnMsgVo:{smsgBody:"SUCCESS"},prmisnSeq:$("#mwContent input[name='prmisnSeq']").val()});
										}
									} else {
										"신청위치 정보를 입력해 주세요.".alert();
										progress.stop();
									}
								}
							} else {
								if(progress.isShowing()){
									progress.stop();
								}
								
								"개발행위허가 신청에 실패하였습니다. 관리자에게 문의 바랍니다.".alert();
							}
						} else {
							
						
							if($("input[name='prmisnSeq']").val() == null || $("input[name='prmisnSeq']").val() == "") {
								fnSaveJibunCallback({tnCmnMsgVo:{smsgBody:"FAIL"}});
							} else {
								if(jibun.toArray().length) {
									var temp = fnClone(jibun.toArray());
									var param = new Array();
									$.each(temp, function(i, v){
										/*if(!v.prmisnSeq){
											jibun.toArray()[i].prmisnSeq = $("input[name='prmisnSeq']").val();
											param.push(v);
										}*/
										v.prmisnSeq = $("#mwContent input[name='prmisnSeq']").val();
										param.push(v);
									});
									if(jibunDelArr.length) {
										$.each(jibunDelArr, function(i,v){
											param.push(v);
										});
									}
									if(param.length) {
										//doAjaxSubmit(contextBase + "minwonmgmt/insertTnPrmisnLadInfo.json", JSON.stringify(param),"json","json", "fnSaveJibunCallback");
										doAjaxSubmit(contextBase + "minwonmgmt/iuwebInsertTnPrmisnLadInfo.json", JSON.stringify(param),"json", "json", "fnSaveJibunCallback");
									} else {
										fnSaveJibunCallback({tnCmnMsgVo:{smsgBody:"SUCCESS"},prmisnSeq:$("#mwContent input[name='prmisnSeq']").val()});
									}
								} else {
									"신청위치 정보를 입력해 주세요.".alert();
									progress.stop();
								}
							}
						}
					}
				}
			}	
		}
	}
	//}
}
function fnSaveJibunCallback(response) {
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
		var temp = fnClone(applicant.toArray());
		var param = new Array();
		$.each(temp, function(i,v){
			v.prmisnSeq = $("input[name='prmisnSeq']").val();
			param.push(v);
		});
		doAjaxSubmit(contextBase + "minwonmgmt/iuwebInsertListTnReqstCpttr.json", JSON.stringify(param), "json", "json", "fnSaveCpttrCallback");
	} else {
		if(progress.isShowing()){
			progress.stop();
		}
		"지번 저장 실패".alert();
	}
}

function fnSaveCpttrCallback(response) {
	if(response.result == "SUCCESS") {
		// 동일한 대리인 이지만 각각의 다른 신청인이 지정한 대리인이므로 agent_seq가 다름
		// agent는 view용, tmpAgent는 data insert용
		var array = new Array();
		if(tmpAgent.toArray().length) {
			array = array.concat(fnClone(tmpAgent.toArray()));
		} else {
			array = array.concat(fnClone(agent.toArray()));
		}
		var param = new Array();
		$.each(array, function(i,v){
			v.prmisnSeq = $("input[name='prmisnSeq']").val();
			v.agentReprsntYn = v.reprsntYn;
			param.push(v);
		});
		if(param.length==0)
		{
			param.push({prmisnSeq :$("input[name='prmisnSeq']").val()});
		}
		doAjaxSubmit(contextBase + "minwonmgmt/insertAgentCpttrProcDtls.json", JSON.stringify(param),"json","json", "fnSaveAgentCpttrCallback");
	} else {
		if(progress.isShowing()){
			progress.stop();
		}
		"신청인 정보 저장 실패".alert();
	}
}

//function fnSaveCpttrCallback(response){
function fnSaveAgentCpttrCallback(response){
	/* 현재 저장상태 임시저장 -> UPDATE DAS000010 필요 */
	if(response.result == "SUCCESS") {
		var typeCd = 0;
		if($("#chkHandicraft").is(":checked")) typeCd += 10000;
		if($("#chkTranformation").is(":checked")) typeCd += 1;
		if($("#chkCollection").is(":checked")) typeCd += 1000;
		if($("#chkDivision").is(":checked")) typeCd += 100;
		if($("#chkHeap").is(":checked")) typeCd += 10;
		$("input[name=type]").val(typeCd.toString().lpad(5,"0"));
		if(response.fileGroupSeq) {
			$("#mwContent input[name='fileGroupSeq']").val(response.fileGroupSeq);
		}
		if(!droppers.length || !droppers[0].postData.fileGroupSeq) {
			//doAjaxSubmit(contextBase + "cmnmgmt/createFileGroupSeq.json", "", "json", "json", "fnSaveCpttrCallback");
			doAjaxSubmit(contextBase + "cmnmgmt/createFileGroupSeq.json", "", "json", "json", "fnSaveAgentCpttrCallback");
		} else if($("#mwContent input[name='fileGroupSeq']").val()){
			$("#mwInfo input[name='fileGroupSeq']").val(droppers[0].postData.fileGroupSeq);
			$("#mwContent input[name='reqstSttus']").val("DAS000010");//DAS000010 허가신청
			$("#mwContent input[name='reqstType']").val(" ");
			$("#mwContent input[name='reqstDate']").val(new Date().format("yyyy-mm-dd"));
			progress.start("<p>지자체와 통신중입니다.</p><p>2분 소요 예정이며 2분 이상 소요 시 IPSS사업단으로 연락바랍니다.</p>");
			doAjaxSubmit(contextBase + "minwonmgmt/insertAndUpdateTnPrmisnDoc.json", JSON.stringify($("#mwContent input, #mwContent textarea").fnSerializeObject()), "json", "json", "fnInsertMinwonCallbak")
		}
	} else {
		"대리인 정보 저장 실패".alert();
		if(progress.isShowing()){
			progress.stop();
		}
	}
}
function fnInsertMinwonCallbak(response){
	if(progress.isShowing()){
		progress.stop();
	}
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS") 
	{
		if($(".ui-dialog").length > 0 && modalPop.css("display") == "block") {
			modalPop.dialog("close");
		}
		"전송 성공".complete(function(){fnDoPost("minwonmgmt/viewSelectListMinwon.do");});
		$("#mwContent input:not([type=hidden]):hidden, #mwContent textarea:not([type=hidden]):hidden").enable();
	} 
	else 
	{
		if(response.tnCmnMsgVo.smsgCd == "LNK.ERR.00010") {
			response.tnCmnMsgVo.smsgBody.confirm(function(){
				progress.start("<p>지자체와 통신중입니다.</p><p>2분 소요 예정이며 2분 이상 소요 시 IPSS사업단으로 연락바랍니다.</p>");
				doAjaxSubmit(contextBase+"minwonmgmt/retryTransfer.json", JSON.stringify({"reqstCode":response.prmisnCode, "tryCount":response.tnCmnMsgVo.commonMsg}), "json","json","fnRetryTransfer");
			},function(){
				"<p>신청정보 저장실패</p><p>민원 상세조회 페이지에서 재전송하시기 바랍니다.</p><p><span id='txtSecond'>5</span>초 후 민원관리 페이지로 이동합니다.</p>".alert();
				setInterval(function(){
					if($("#txtSecond").text() > 1){
						$("#txtSecond").text($("#txtSecond").text() - 1);
					} else {
						fnDoPost("minwonmgmt/viewSelectListMinwon.do");
					}
				},1000);
			});
		} else if(response.tnCmnMsgVo.smsgCd == "LNK.ERR.00009") {
			response.tnCmnMsgVo.smsgBody.alert();
// 			setTimeout(function(){
// 				fnDoPost("minwonmgmt/viewInsertMinwon.do", {"prmisnSeq",$("input[name=prmisnSeq]").val()});
// 			})
			$("#mwContent input:not([type=hidden]):hidden, #mwContent textarea:not([type=hidden]):hidden").enable();
		} else {
			
			"개발행위허가 신청에 실패하였습니다. 관리자에게 문의 바랍니다.".alert();
			$("#mwContent input:not([type=hidden]):hidden, #mwContent textarea:not([type=hidden]):hidden").enable();
		}
	}
}
function fnRetryTransfer(response) {
	if(progress.isShowing()){
		progress.stop();
	}
	if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
		if($(".ui-dialog").length > 0 && modalPop.css("display") == "block") {
			modalPop.dialog("close");
		}
		"전송 성공".complete(function(){fnDoPost("minwonmgmt/viewSelectListMinwon.do");});
	} else {
		if(response.tnCmnMsgVo.smsgCd == "LNK.ERR.00010") {
			response.tnCmnMsgVo.smsgBody.confirm(function(){
				progress.start("<p>지자체와 통신중입니다.</p><p>2분 소요 예정이며 2분 이상 소요 시 IPSS사업단으로 연락바랍니다.</p>")
				doAjaxSubmit(contextBase+"minwonmgmt/retryTransfer.json", JSON.stringify({"reqstCode":response.reqstCode, "tryCount":response.tryCount}), "json","json","fnRetryTransfer");
			},function(){
				"<p>신청정보 저장실패</p><p>민원 상세조회 페이지에서 재전송하시기 바랍니다.</p><p><span id='txtSecond'>5</span>초 후 민원관리 페이지로 이동합니다.</p>".alert();
				setInterval(function(){
					if($("#txtSecond").text() > 1){
						$("#txtSecond").text($("#txtSecond").text() - 1);
					} else {
						fnDoPost("minwonmgmt/viewSelectListMinwon.do");
					}
				},1000);
			});
		} else {
			response.tnCmnMsgVo.smsgBody.alert();
			$("#mwContent input:not([type=hidden]):hidden, #mwContent textarea:not([type=hidden]):hidden").enable();
		}
	}
}
/* 공사관련 도서서류  */
function fnAddInfo(value){
	
}

function fnAgendaRequest(){
	modalPop.dialog('close');
	doAjaxSubmit(contextBase + "minwonmgmt/viewSelectAgendaInfo.pop", "", "html", "html", "agendaCallback");
}

function agendaCallback(response){
	agendaPop = createLayerPopup("agendaForm", "의제 협의 정보", "auto","600", response);	
	agendaPop.dialog("open");
}
function fnGetInfo(){
	applicant.array.splice(0);
	jibun.array.splice(0);
	if($("input[name=recpPk]").val() != ""){
		if($("input[name=recpPk]").val() != null){
			applicant.array.splice(0);
			agent.array.splice(0);
			jibun.array.splice(0);
			
			doAjaxSubmit(contextBase + "minwonmgmt/selectListKcprelpInfo.json", {"recpPk":$("input[name=recpPk]").val()}, "json", "html", "fnSetCpttrDatas");
			doAjaxSubmit(contextBase + "minwonmgmt/selectListKcpplatplc.json", {"recpPk":$("input[name=recpPk]").val()}, "json", "html", "fnSetJibunDatas");
			doAjaxSubmit(contextBase + "minwonmgmt/selectPrmisnDetailToAgenda.json", JSON.stringify({"eaisNo":$("input[name=recpPk]").val()}), "json", "json", "fnSetDatas" );	
		}
	}else if($("input[name=fctNo]").val() != ""){
		if($("input[name=fctNo]").val() != null){
			applicant.array.splice(0);
			agent.array.splice(0);
			jibun.array.splice(0);
			
			doAjaxSubmit(contextBase + "minwonmgmt/selectListCpttrToFemis.json", JSON.stringify({"fctNo":$("input[name=fctNo]").val()}), "json", "json", "fnSetCpttrDatas" );
			doAjaxSubmit(contextBase + "minwonmgmt/selectListPrmisnLadInfoToFemis.json", JSON.stringify({"fctNo":$("input[name=fctNo]").val()}), "json", "json", "fnSetJibunDatas" );
			doAjaxSubmit(contextBase + "minwonmgmt/selectPrmisnDetailToAgenda.json", JSON.stringify({"femisNo":$("input[name=fctNo]").val()}), "json", "json", "fnSetDatas" );	
		}
	}else{
		"신청인 정보가 없습니다.".alert();
	}
	/* if($("input[name=eaisNo]").val() != null || $("input[name=eaisNo]").val() != ""){
		doAjaxSubmit(contextBase + "minwonmgmt/selectPrmisnDetailToAgenda.json", JSON.stringify({"eaisNo":$("input[name=eaisNo]").val()}), "json", "json", "fnSetDatas" );
	}else{
		"허가신청내용이 없습니다.".alert();
	} */
	/* $("#spanChkSelf #chkSelf").trigger("click"); */
	agendaPop.dialog("close");
}

function fnCommissionChek(response){
	if(!response){
		//.num132 type validation check
	    if(!fnCheckNumType132())
	    {
	        return;
	    }
		var param = "fileGroupSeq=" + $("#mwContent input[name=fileGroupSeq]").val();
		doAjaxSubmit(contextBase + "minwonPayCheck.json", param, "json", "html", "fnCommissionChek");
	}else{
		for(i=0; i<response.length; i++){							
			if(response[i].RETURN_PAY == 2)
				commissionBak = "DUP000031";
		}
		fnComplement();
	}
}

function fnComplement(response) {
	if(!response) {
		// 대리인일경우 위임장 파일 여부 체크
		var agentFileExist = false;
		if(userType == 'DAU000020') {
			var totalCnt = $("#mwInfo .fileListItem").length;
			if(totalCnt > 0) {
				if(agent.array.length != totalCnt) {
					"대리인 목록과 위임장 파일 개수가 다릅니다.".alert();	
					if(progress.isShowing()){
						progress.stop();
					}
					return false;
				} else {
					var tmpArr = new Array;
					var fileListCnt = $("#deligationFileList .fileListItem").length;
					if(fileListCnt > 0) {
						for (var j = 0; j < fileListCnt; j++) {
							var fileNm = $("#deligationFileList .fileListItem").eq(j).find("a").text();
							tmpArr.push(fileNm.substring(0, fileNm.indexOf('.')));
						}									
					}
					var getFileListCnt = $(".getDeligationFiles .fileListItem").length;
					if(getFileListCnt > 0) {
						for (var x = 0; x < getFileListCnt; x++) {
							var fileNm = $(".getDeligationFiles .fileListItem").eq(x).attr("id");
							tmpArr.push(fileNm.substring(0, fileNm.indexOf('_')));
						}									
					}
					var tmpCnt = 0;
					$.each(agent.toArray(), function(i,v) {
						for (var y = 0; y < tmpArr.length; y++) {
							if(v.presidentNm == tmpArr[y]) {
								tmpCnt++;
								break;
							}
						}	
					});
					if(agent.array.length != tmpCnt) {
						"대표자명과 같지 않은 위임장 파일이 존재합니다.".alert();	
						if(progress.isShowing()){
							progress.stop();
						}
						return false;
					} else {
						agentFileExist = true;
					}
				}
			}
		} else {
			agentFileExist = true;
		}
		
		if(!agentFileExist) {
			"대리인 위임장관련파일 등록을 해야 민원신청이 진행됩니다.".alert();
			if(progress.isShowing()){
				progress.stop();
			}
		} else {
			if(reqstType == "DUR000080"/**/) {
				if(commissionBak != "DUP000031"){
					"요청 후에는 수정하실 수 없습니다. 서류보완".confirm(function(){
						reCheckComplement(); // 서류보완 중일 때 업무시스템에서 보완요청 취소하였을 경우 확인
			 			if (reCheckComplementResult == "true") {
			 				"담당자로부터 서류보완 요청이 취소되었습니다. <br>해당 지자체에 문의해주시기 바랍니다.".alert();
			 				return false;
			 			}
						/*
						if(!progress.isShowing()){
							progress.start();
						}
						*/
						var param = "fileGroupSeq=" + $("#mwContent input[name=fileGroupSeq]").val();
						doAjaxSubmit(contextBase + "minwonPayCheck.json", param, "json", "html", "fnSubmitPay");
						
						//doAjaxSubmit(contextBase + "minwonmgmt/insertMinwonComplement.json", JSON.stringify({"prmisnSeq":$("input[name=prmisnSeq]").val()}), "json","json", "fnComplement");
					});
				}else{
					"요청 후에는 수정하실 수 없습니다. 수수료 반려".confirm(function(){
						modalPop = createLayerPopup("modalForm", "확인", "auto", "100", "");
						modalPop.dialog("open");
						var param = "fileGroupSeq=" + $("#mwContent input[name=fileGroupSeq]").val();
						if(!progress.isShowing()){
							progress.start();
						}
						
						doAjaxSubmit(contextBase + "minwonPayCheck.json", param, "json", "html", "fnSubmitPay");
						
					});
				}			
			} else {
				"비정상적 접근입니다.".alert();
				if(progress.isShowing()){
					progress.stop();
				}
			}
		}
	} else {
		if(progress.isShowing()){
			progress.stop();
		}
		if(response.tnCmnMsgVo.smsgBody == "SUCCESS") {
			//fnDoPost("minwonmgmt/viewSelectListMinwon.do");
			"서류보완 성공".complete(function(){fnDoPost("minwonmgmt/viewSelectListMinwon.do");});
		} else {
			"서류보완 실패".alert();
			//progress.stop();
		}
	}
}

function insertExamplePop(){
	var option = "menubar=no, toolbar=no, location=no, status=no, scrollbars=yes, resizable=yes, width=770px, height=620px, top=40, left=40";
	var winPopUp = window.open("<c:url value='/minwonmgmt/insertExamplePop.pop'/>", "insertExamplePop", option);
	winPopUp.focus();
}
function fnDeletePrmisn(response) {
	if(response) {
		if(response.tnCmnMsgVo.smsgCd == "SUCCESS") {
			"민원이 삭제되었습니다.<br><br>민원관리 페이지로 이동합니다.".complete();
			setTimeout(fnDoPost("minwonmgmt/viewSelectListMinwon.do"), 500);
		} else {
			new String(response.tnCmnMsgVo.smsgBody).alert();
		}
	} else {
		"민원이 삭제되면 복구하실수 없습니다.".confirm(function(){
			doAjaxSubmit(contextBase+"minwonmgmt/deletePrmisnDoc.json", JSON.stringify({prmisnSeq:$("input[name=prmisnSeq]").val()}),"json","json", "fnDeletePrmisn");
		});
	}
}
function fnCheckNumType132()
{
	var num132 = $(".num132");
	for(var ni=0; ni<num132.length;ni++)
	{
		var item = $(".num132")[ni];
		
		var nc = /^([0-9]{1,11})([\.]([0-9]{0,2}))?$/; // 정규화 표현식
		var v = $(item).val().replace(/\,/gi,"");
		var title = $(item).attr("title");
		if(v!="" &&!nc.test(v))
		{
			var message = "'"+title+"'은(는) 소숫점 위 11자리, 소숫점 아래 2자리까지 허용합니다.";
			message.alert();
			$(item).focus();
			return false;
		}
		
	}
	return true;
}

/* ---------------------------2019-04-04 공지사항 start ------------------------------- */
function fnShowpPop(){
	var option = "menubar=no, toolbar=no, location=no, status=no, scrollbars=no, resizable=yes, width=402px, height=418px, top=40, left=40";
	var winPopUp = window.open(contextBase + "cmnmgmt/poll.pop", "pollPopup", option);
	winPopUp.focus();
}
/* ---------------------------2019-04-04 공지사항  end---------------------------------- */
/*처리기한일 갱신*/
function fn_updateTmlmtDate()
{
	var minwonCode = $("input[name=prmisnCode]").val() ;
	var reqstSttus = $("#mwContent input[name='reqstSttus']").val();//"DAS009000" : 임시저장
	var reqstType = $("#mwContent input[name='reqstType']").val().trim();
	
	if(seq!="" && seq!=undefined && seq!=null
		&&	minwonCode!="" && minwonCode!=undefined && minwonCode!=null
		&&	reqstSttus!="DAS009000" /*임시저장*/ &&	reqstSttus!="" && reqstSttus!=undefined && reqstSttus!=null		
	)
	{
		if(!(reqstSttus =="DAS000010" && (reqstType!=null &&reqstType!=""&&reqstType!=undefined)))
		{
			var siteCd = jibun.array[0].ladPnu.substring(0,5);
			
			//처리기한일 정보가 있으면 넣기
			$.ajax({
				type:"POST"
				,async:false
				,url:contextBase + "minwonmgmt/updateTmlmtDate.json"
				,dataType:"json"
				,data:"minwonCode=" + minwonCode+"&siteCd="+siteCd
				,success: function(result) 
				{
					if(result.resultCode=="SUCCESS")
					{
						if(result.cnt>0)
						{
							$("#tmlmtDate").html(result.resultData.tmlmtDateKo);
						}
						else
						{
							$("#tmlmtDate").html("-");
						}
					}
					else
					{
						"처리기한일 조회중 오류가 발생하였습니다.".alert();
					}
				}
				,error : function(xhr,status,error)
				{
					"처리기한일 조회중 오류가 발생하였습니다.".alert();
				}
			});
		}
		else
		{
			"처리기한일 조회는 담당자 배정 이후에만 가능합니다.".alert();
		}
		
	}
}

//대리인 사용자일 경우에만 사용가능한 기능. 로그인한 대리인 회원의 회원정보를 끌어다 대리인으로 추가
function fnAddThisAgent()
{
	if(userType == 'DAU000020')
	{
		if(applicant.array.length==0)
		{
			"신청인 정보를 먼저 입력하세요.".alert();
			return false;
		}
		var _agentUserSeq = <%=user.getUserSeq()%>;
		var _minwoninUserSeq = applicant.array[0].userSeq;
		
		$.ajax({
			type:"POST"
			,async:false
			,url:contextBase + "minwonmgmt/selectAgentUser.json"
			,dataType:"json"
			,data:"agentUserSeq="+_agentUserSeq+"&minwoninUserSeq="+_minwoninUserSeq
			,success: function(result) 
			{
				if(result!=null)
				{
					result.diInpYn = "false";
					result.appNm = result.companyNm;
					result.cprYn=result.agentCprYn;
					result.identifyNo=((result.corporationNum!=null && result.corporationNum!=undefined&& result.corporationNum!=""&& (result.corporationNum.length==8||result.corporationNum.length==13))?result.corporationNum:'');
					result.corporationNum=result.identifyNo;
					result.presidentNm=result.agentNm;
					result.rdnmadr=result.businessAddr,
					result.rdnmadrDetail=fnNvl(result.businessAddrDetail);
					result.emailId=fnNvl(result.emailId);
					result.emailDomain=fnNvl(result.emailDomain);
					result.userSeq=result.agentUserSeq;
					result.telArea=fnNvl(result.agentTelArea);
					result.telPre=fnNvl(result.agentTelPre);
					result.telSuf=fnNvl(result.agentTelSuf);
					result.mobileArea=fnNvl(result.mobileArea);
					result.mobilePre=fnNvl(result.mobilePre);
					result.mobileSuf=fnNvl(result.mobileSuf);
					result.reprsntYn = true;
					result.agentYn = true;
					result.smsRtYn =(result.smsYn=="Y"?true:false);
					$("#agent").empty();
					agent.clear();
					tmpAgent.clear();
					agent.unshift(result);
					tmpAgent.unshiftIS(result);
				}
				
			}
			,error : function(xhr,status,error)
			{
				"대리인 사용자 조회 중 에러가 발생하였습니다. 확인 후 다시 시도하세요.".alert();
			}
		});
		
	}
}
function fnDelAgent()
{
	if(userType != 'DAU000010')
	{
		"대리인이 삭제는 신청인 사용자만 사용 가능한 기능입니다.".alert();
	}
	else if(agent.array.length==0 )
	{
		"대리인이 존재하지 않습니다.".alert();
	}
	else if($("#agent tr.highlight").length==0)
	{
		"삭제할 대리인을 선택하세요".alert();
	}
	else 
	{
		$("#agent").empty();
		agent.clear();
		tmpAgent.clear();
		$(".trAgent").hide();
	}
}
//민원 삭제
function fnDelMinwon()
{
	var _prmisnSeq = $("input[name=prmisnSeq]").val();
	var _competSeq = 0;
	
	"'확인' 버튼을 누르면 삭제가 진행됩니다. 삭제된 자료는 복구가 불가능합니다.".confirm(function(){
		$.ajax({
			type:"POST"
			,async:false
			,url:contextBase + "minwonmgmt/delMinwon.json"
			,dataType:"json"
			,data:"prmisnSeq="+_prmisnSeq+"&competSeq="+_competSeq
			,success: function(result) 
			{
				if(result.resultCode=="SUCCESS")
				{
					//목록으로 이동
					fnDoPost('minwonmgmt/viewSelectListMinwon.do');
				}
				else if(result.resultCode=="NOT-AGREED-PARAMETER")
				{
					"잘못된 파라미터가 입력되었습니니다.".alert();	
				}
				else if(result.resultCode=="CANT-DELETE-STTUS")
				{
					"삭제 불가능한 상태입니다. 민원 삭제는 임시저장 상태에서만 가능합니다.".alert();	
				}
				else if(result.resultCode=="EXIST-PAY-INFO")
				{
					"삭제 불가능한 상태입니다. 삭제되지 않은 결제정보가 존재합니다. 관리자에게 문의하세요.".alert();
				}
			}
			,error : function(xhr,status,error)
			{
				"민원 삭제 중 오류가 발생하였습니다.".alert();
			}
		});
	});	
}
function reCheckComplement() { // 서류보완 중일 때 주무관이 보완요청을 취소하였을 경우 디비 상태코드가 꼬이는 것을 방지하기 위함
	var prmisnVO = new Object();
	prmisnVO.prmisnSeq = parseInt("<c:out value='${seq}'/>");
	$.ajax({
		 type : "POST"
		, async : false
		, url : contextBase + "/minwonmgmt/reCheckComplement.json"
		, dataType : "json"
		, contentType: 'application/json'
		, data : JSON.stringify(prmisnVO)
		, success : function(response) {
			var liveReqstSttus = response.liveReqstSttus; // DUP000030 
			var liveReqstType = response.liveReqstType; // DUR000080
			if (liveReqstSttus != "DUP000030" || liveReqstType != "DUR000080") {
				reCheckComplementResult = "true";
			} else {
				reCheckComplementResult = "";
			}
		}
	});
}
</script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/commonMinwon.js"></script>
<style type="text/css">
.axi-arrow-drop-down, .axi-arrow-drop-up{font-size: 20px;}
.axi-arrow-drop-up{font-size: 20px;}
@media screen and (max-width: 990px) {.wrapDesign .simpleTable2 tr td {font-size:10px;padding:10px 10px;} .axi-arrow-drop-up{font-size: 16px;} .axi-arrow-drop-down, .axi-arrow-drop-up{font-size: 16px;} .wrapDesign .simpleTable2 tr th {font-size: 10px;} .wrapDesign .tableHeaderBar {font-size:12px !important;} .button {padding: .5em 2em .55em; font-size: 10px;}.dropper-dropzone{font-size:10px !important;}}
div.applyDateBox {background: #fdf8e6;border: 1px solid #e5e5e5; border-radius: 5px;-mo-border-radius: 5px;-webkit-border-radius: 5px;margin: 20px auto;}
div.applyDateBox > .dateTitle {width: 23.3%;color: #005596; text-align: center; font-weight: 600;box-sizing: border-box;display: inline-block;}
div.applyDateBox > .dateMsgBox {width: 75.7%;background: #fff;text-align: center;margin: 5px 0; padding: 15px 0;border: 1px solid #f0ebda;border-radius: 0 5px 0 5px;-mo-border-radius: 0 5px 0 5px;-webkit-border-radius: 0 5px 0 5px;box-sizing: border-box;display: inline-block;}
div.bottom_btn {margin-bottom: 25px; padding: 20px 0 20px;}
.w100per_20px {width: calc(100% - 20px);width: -moz-calc(100% - 20px);width: -webkit-calc(100% - 20px);}
.w100per_200px {width: calc(100% - 120px);width: -moz-calc(100% - 120px);width: -webkit-calc(100% - 120px);}
button.button.circleBt3 i.axi{color: #fff; margin: 0; position: static;}
#btUpCsv.button {margin: 0 5px;}
#dialog {font-size: 14px; width: 600px; margin: 0 auto;background:#fff;}
#dialog .btnBox {margin: 15px 0 0;}
#dialog .btnBox button {margin: 0 5px 0;}
.noticeMsgBox {min-height: 100%;border: 1px solid #ccc;border-radius: 5px;-o-border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;margin: 0 auto;padding: 10px;box-sizing: border-box;}
.noticeMsgBox .leftBox01 {width: calc(10% - 5px);width: -moz-calc(10% - 5px);width: -webkit-calc(10% - 5px);height: 100%;color: #ccc;font-size: 35px;text-align: right;vertical-align: top;display: inline-block;margin: 0 10px 0 -10px;}	
.noticeMsgBox .rightBox01 {width: calc(90% - 5px);width: -moz-calc(90% - 5px);width: -webkit-calc(90% - 5px);height: 100%;display: inline-block;}	
.noticeMsgBox .leftBox02 {width: calc(90% - 5px);width: -moz-calc(90% - 5px);width: -webkit-calc(90% - 5px);height: 100%;display: inline-block;}
.noticeMsgBox .rightBox02 {width: calc(10% - 5px);width: -moz-calc(10% - 5px);width: -webkit-calc(10% - 5px);height: 100%;color: #ccc;font-size: 50px;text-align: left;vertical-align: top;display: inline-block;margin: 0 10px 0 0;}
.rightBox01 p.contentsPara {margin: 0;}
.leftBox02 p.contentsPara {line-height: 1.2; margin: 5px 0 0;}
/* 레이아웃 요소 */
	/* info msg Box */
	.agree24Box {
		width: 530px;
		background: #fff;
		color: #444;
		font-size: 13px;
		margin: 15% auto;
		padding: 10px 15px;
	}
	.agree24Box h1 {
		width: 100%; height: 100%;
		background: #FDF8E6;
		color: #A7855D;
		text-align: justify;
		border: 1px solid #E7DBCD;
		border-radius: 0px 15px 0px 15px;
		box-sizing: border-box;
		box-shadow: 1px 1px 7px 0px lightgray;
		padding: 7px 10px 10px;
	}

	/* 수수료 납부 내역 */
	.payList {margin: 15px;}
	.payList legend {width: 140px; font-weight: 600; border-top: 3px solid #A9C4CD; padding: 10px 0;}
	.payList legend i {vertical-align: middle; padding: 0 10px;}
	.payList li {
		width: 100%;
		height: 30px;
		line-height: 2;					
		display: table-row;
	}
	
	.payList span:nth-child(1):before {content: '\2713'; padding: 0 10px 0 0;}				

	.payList li:first-child > span:nth-child(1) {border-top: 3px solid #A9C4CD;}				
	.payList li > span:nth-child(1) {
		width: 40%;
		background: #F0F4FD;
		color: #426E84;
		border-bottom: 1px dotted #A9C4CD;
		box-sizing: border-box;
		padding: 5px 50px 5px 20px;
		display: table-cell;
	}

	.payList li:first-child > span:nth-child(2) {border-top: 3px solid #A9C4CD;}
	.payList li > span:nth-child(2) {
		width: 60%;
		background: #fff;
		text-align: right;
		border-top: none;
		border-bottom: 1px dotted #A9C4CD;
		box-sizing: border-box;
		padding: 5px 20px;
		display: table-cell;
	}
	
	.payList li:last-child > span:nth-child(1) {border-top: 1px dotted #A9C4CD;}
	.payList li:last-child > span:nth-child(2) {border-top: 1px dotted #A9C4CD;}
	.payList li:last-child > span:nth-child(1) {font-weight: 600; text-align: center;}
	.payList li:last-child > span:nth-child(1):before {content: ''; padding: 10px 0 0;}

	/* 민원신청 동의 MSG */
	.applyAgreeMsg {width: 97%; margin: 0 0 15px;}
	.applyAgreeMsg label, .agree24Msg input {text-align: left;}

	/* 결제방식 선택 */
	.selectPayment {padding: 15px;}
	.payTypeSelect {margin: 15px 15px 5px;}
	.payTypeSelect .tiny {color: #fff; box-shadow: 1px 1px 2px 0px #888; padding: 3px 0;}
	.payTypeSelect .tiny:hover {border: 1px solid lightgray;}
	.payTypeSelect .tiny:active {outline: none; box-shadow: none;}

	/* 결제방식 출력 */				
	.payInfo {padding: 15px;}
	.payInfo li {
		width: 100%;
		height: 30px;
		line-height: 2;					
		display: table-row;
	}

	.payInfo li i {vertical-align: middle; padding: 0 5px 0 0;}
	
	.payInfo span:nth-child(1):before {content: '\2713'; padding: 0 10px 0 0;}				

	.payInfo li:first-child > span:nth-child(1) {border-top: 2px solid #A9C4CD;}				
	.payInfo li > span:nth-child(1) {
		width: 36%;
		background: #F0F4FD;
		color: #426E84;
		border-bottom: 1px dotted #A9C4CD;
		box-sizing: border-box;
		padding: 5px 50px 5px 20px;
		display: table-cell;
	}


	.payInfo li:first-child > span:nth-child(2) {border-top: 2px solid #A9C4CD;}
	.payInfo li > span:nth-child(2) {
		width: 53%;
		background: #fff;
		text-align: left;
		border-top: none;
		border-bottom: 1px dotted #A9C4CD;
		box-sizing: border-box;
		padding: 5px 20px;
		display: table-cell;
	}				
	
	.payInfo li:first-child > span:nth-child(1) {font-weight: 600; text-align: center;}
	.payInfo li:first-child > span:nth-child(1):before {content: ''; padding: 10px 0 0;}

/* 디자인 요소 */
	.dashed_line {border-top: 1px dashed #ccc;}
	
	#payInfoList td{text-align:center;}
	.boldText{
		font-weight : bold;
		color : red;
	}
</style>
<c:if test="${requestScope['javax.servlet.forward.servlet_path'].toString().endsWith('pop')}">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/minwonpop.css" />
</c:if>
</head>
<body>
	<section class="innerWrap">
		<div class="con_top">
			<div class="con_top_wrap">
				<h2>개발행위허가신청</h2>
				<span class="sectionDesc2"> 개발행위허가 신청서를 인터넷에서 작성할 수 있습니다.(문의전화 : 1522-4434(ARS 1))</span>
				<div class="nm_sub_util">
					<ul>
						<li><img src="/iuweb/images/home_ico.gif" alt="홈"></li>
						<li class="li_arrow"><img src="/iuweb/images/arrow_ico.gif" alt="홈"></li>
						<li>개발행위허가</li>
						<li class="li_arrow"><img src="/iuweb/images/arrow_ico.gif" alt="홈"></li>
						<li>허가신청</li>
					</ul>
				</div>
			</div>
		</div>
        <input type="hidden" name="recpPk">
        <input type="hidden" name="fctNo">
        <input type="hidden" name="mountProg">
        <div class="nm_con_wrap">
	        <div class="searchBox" style="font-size:13px;line-height:18px;margin-bottom:13px;padding:10px 0px;">
				<table style="width: 100%">
					<tbody>
						<tr>
						<td style="text-align: left;">
						<p class="mb10" style="text-indent: 15px;">
							* 인터넷 개발행위허가 민원신청 <span class="text_semibold">운영 지자체 : 
							대전광역시, 부산광역시, 인천광역시, 광주광역시, 울산광역시, 대구광역시, 제주특별자치도, 세종특별자치시, 경기도, 강원도, 충청북도, 충청남도, 전라북도, 전라남도, 경상북도, 경상남도</span><br/>
						</p>
						<p class="mb10" style="text-indent: 15px;">
							* 운영 지자체의 개발행위 민원접수는 방문접수와 인터넷 접수가 모두 가능합니다.
						</p>
						<!-- p style="text-indent: 15px;">
							* 통합인허가 <span class="text_semibold">운영 지자체 : 인천, 경기 양주시, 경기 평택시, 경기 광주시, 경기 이천시, 강원 화천군, 경북 영양군, 경북 봉화군, 전남 진도군, 제주 제주시</span> <a href="http://upis.go.kr/ipss/">바로가기</a>
						</p-->
						<p style="text-indent: 15px;" >
							* 개선의견 및 불편사항은 IPSS운영 사업단 1522-4434(ARS 1) 으로 문의 또는 <a href="/iuweb/view/boardmgmt/bbsList.html" style="text-decoration:underline; color:#539fd6;">이용문의 게시판</a>을 이용 바랍니다.
						</p>
						</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			
			<table  class="simpleTable2 verticalSpacer payInfoTb doc" style="clear:both; table-layout: fixed; border-top: none; border-right: none;  width:100%; border:0; display:none;">
				<colgroup>
					<col style="width:15%" />
					<col />
				</colgroup>
				<tbody>
					<tr class="titleCell_line">
						<td colspan="2" class="tableHeaderBar roundBoxBG">
							<span class="text_14 text_yellow"><i class="axi axi-arrow-circle-right"></i></span>
							<span class="text_16">결제정보</span> 
							
						</td>
					</tr>
				</tbody>
				
				<tbody id="payInfo" >				
					<tr>
						<th>결제정보</th>
						<td>
							<div>
								<p class="mb10" style="text-indent: 15px; color:red; font-weight: bold;">
									* 결제상태가 '결제완료' 상태인 결제정보가 존재하고 인허가 신청시 산정된 결제금액이 동일하면 인허가 신청시 결제 절차를 건너뜁니다.<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 결제상태가 '결제완료' 상태인 결제정보가 존재하나 인허가 신청시 산정된 결제 금액이 동일하지 않은 경우, 관리자에게 문의하여 결제취소 처리 후, 재결제해야 합니다.<br/>									
								</p>
							</div>
							<table style="clear:both; width: 99%; padding: 0px; margin: 0px; border: none;" class="collapse">
								<colgroup>
									<col style="width:2.5%" />
									<col style="width:15%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:15%" />
								</colgroup>
								<thead>
									<tr class="solid_blue">
										<th></th>
										<th>결제일시</th>
										<th>결제수단</th>
										<th>결제총액</th>
										<th>수수료</th>
										<th>결제자명</th>
										<th>결제결과</th>
									</tr>
								</thead>
								<tbody id="payInfoList">
								
								</tbody>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
			
			
			<table  class="simpleTable2 doc" style="clear:both; table-layout: fixed; border-top: none; border-right: none; width:100%; border:0; ">
				<colgroup>
					<col style="width:15%" />
					<col style="width:15%" />
					<col />
				</colgroup>
				<tbody>
					<tr class="titleCell_line">
						<td colspan="3" class="tableHeaderBar roundBoxBG">
							<span class="text_14 text_yellow"><i class="axi axi-arrow-circle-right"></i></span>
							<span class="text_16">기본정보</span> 
							<div id="mwInfoLink" style="float: right; margin-top: -5px; ">
								<button class="button flat txtWhite" onclick="showTable('mwInfo'); return false;" style="width:90px; height:30px; line-height: 0px;">모두 접기<i class='axi axi-ion-chevron-up'></i></button>
							</div>
						</td>
					</tr>
				</tbody>
				<tbody id="mwInfo">				
					<tr>
						<th>신청내용</th>
						<td colspan="2">
							<div id="spanChk" style="float: left;margin-top: 3px;">
								<span id="spanChkHandicraft"><input type="checkbox" id="chkHandicraft" style="vertical-align: middle;" class="type" value="10000"> 공작물 설치 &nbsp;</span>
								<span id="spanChkTranformation"><input type="checkbox" id="chkTranformation" style="vertical-align: middle;" class="type" value="00001"> 토지형질변경 &nbsp;</span>
								<span id="spanChkCollection"><input type="checkbox" id="chkCollection" style="vertical-align: middle;" class="type" value="01000"> 토석채취 &nbsp;</span>
								<span id="spanChkDivision"><input type="checkbox" id="chkDivision" style="vertical-align: middle;" class="type" value="00100"> 토지분할 &nbsp;</span>
								<span id="spanChkHeap"><input type="checkbox" id="chkHeap" style="vertical-align: middle;" class="type" value="00010"> 물건적치 &nbsp;</span>
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="2">
							신청인
						</th>
						<th>
							신청인 관리
						</th>
						<td>
							<button class="button blue02  " id="reqstAddApplicant" onClick="fnAddApplicant('insert');" >신청인 임의등록</button>
							<button class="button blue02  " id="reqstSelect" onClick="fnSelectApplicant('list');" >신청인 선택</button>
							<button class="button blue02  " id="reqstAdd" onClick="openPop('0')" >신청인 추가</button>
							<button class="button grayBlue" id="reqstInfo" onClick="openPop('2')">정보 보기</button>
							<!--button class="button grayBlue" id="reqstDel" onClick="deleteRowInApplicant();">선택 삭제</button-->
							<button class="button grayBlue" id="reqstDel" onClick="fnDeleteRowApplicant();">선택 삭제</button>
							<button class="button grayBlue" id="appointReprsntYn" onClick="appointReprsntYn();">대표 지정</button>
							<span id="spanChkSelf" style="visibility:hidden;"><input type="checkbox" checked="checked" id="chkSelf"> 신청인과 대리인이 동일</span>
							<button class="button blue02 topImg floatRight" onclick="javascript: window.open('http://www.law.go.kr/lsEfInfoP.do?lsiSeq=140246#', 'blank');">부동산개발업 등록기준?</button>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="center" style="padding: 0px !important;">
							<table style="clear:both; width: 99%; padding: 0px; margin: 0px; border: none;" class="collapse">

								<thead>
									<tr class="solid_blue">
										<th>대표</th>
										<th>번호</th>
										<th>성명(법인명)</th>
										<th>생년월일(법인등록번호)</th>
										<th style="width:45%">주소</th>
										<th>휴대폰 번호</th>
									</tr>
								</thead>
								<tbody id="applicant">
									
								</tbody>
							</table>
						</td>
					</tr>
					<tr class="trAgent">
						<th rowspan="4">
							대리인
						</th>
						<th>
							대리인 관리
						</th>
						<td>
							<button class="button blue02" id="btAddThisAgent" style="display:none;" onClick="fnAddThisAgent();" >대리인 정보 갱신</button>
							<button class="button blue02" id="btDelAgent" style="display:none;" onClick="btDelAgent();" >대리인 삭제</button>
							<button class="button blue02" id="agentAdd" style="display: inline-block;" onClick="openPop('1')" >대리인 입력</button>
							<button class="button grayBlue" id="agentInfo" style="display: inline-block;" onClick="openPop('3')">정보 보기</button>
							<button class="button grayBlue" id="agentReprsntYn" onClick="agentReprsntYn();">대표 지정</button>
							<div id="agentType" style="display: inline-block;">
								
							</div>
						</td>
					</tr>
					<tr class="trAgent">
						<td colspan="2" style="padding: 0px !important;">
							<table style="clear:both; width: 99%; padding: 0px; margin: 0px; border: none;" class="collapse">
								<colgroup>
									<col style="width:7%">
									<col style="width:3%">
									<col style="width:15%">
									<col style="width:10%">
									<col style="width:15%">
									<col style="width:35%">
									<col style="width:15%">
								</colgroup>
								<thead>
									<tr class="solid_blue">
										<th>대표</th>
										<th>번호</th>
										<th>성명(법인명)</th>
										<th>대표자명</th>
										<th>생년월일(법인등록번호)</th>
										<th>주소</th>
										<th>전화번호</th>
									</tr>
								</thead>
								<tbody id="agent">
									<%--tr>
										<th colspan="4">미입력</th>
									</tr--%>
								</tbody>
							</table>
						</td>
					</tr>				
					<tr class="trAgent" id="trAgentFile">
						<th rowspan="2">위임장관련파일
	<%-- 					<div class="right"><img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('attorneyFiles')"></div> --%>
						</th>
						<td>
							<form action="#" class="w98 h98">
								<div id="deligationFiles">
								<ol id="deligationFileList"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr class="getDeligationFiles" style="display:none;">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
								<ol></ol>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<table  class="simpleTable2 verticalSpacer doc" style="clear:both; table-layout: fixed; border-top: none; border-right: none; width:100%; border:0; ">
				<tbody>
					<tr class="titleCell_line">
						<td colspan="7" class="tableHeaderBar roundBoxBG">
							<span class="text_14 text_yellow"><i class="axi axi-arrow-circle-right"></i></span>
							<span class="text_16">신청위치</span>			
							<div id="jibunTbodyLink" style="float: right; margin-top: -5px;">
								<button class="button flat txtWhite" onclick="showTable('jibunTbody'); return false;" style="width:70px; height:30px; line-height: 0px;">접  기<i class='axi axi-ion-chevron-up'></i></button>
							</div>
						</td>
					</tr>
				</tbody>
				<tbody id= "jibunTbody">
				<tr>
					<th id="rowSpanner" rowspan="3"> 위치</th>
					<th> 주소</th>
					<td colspan="5">
						<input type="text" disabled="disabled" class="w100per_200px" style="height: 22px; margin-top: 1px; margin-left: 2px; padding-right : 10px;" id="txtAddr" name="slocPnuCd">
						<input type="hidden" id="riCd" name="riCd"/>
						<input type="hidden" id="siteCd" name="siteCd"/>
						<button class="button blue02 " style="float: left;" id="btFindAddr" onClick="event.preventDefault();doAjaxSubmit(contextBase+'minwonmgmt/viewSelectAddr.pop','param=upis', 'html', 'html', 'commonCallback');">주소찾기</button>
					</td>
				</tr>
				<tr>
					<th rowspan="2" id="rowSpannerJibun"> 지번</th>
					<td colspan="5" id="jibunTd">
						<button class="button blue02" style="float: left;" onclick="event.preventDefault();doAjaxSubmit(contextBase+'minwonmgmt/viewSelectJibun.pop', '', 'html', 'html', 'commonCallback');">지번추가</button>
						<!--button class="button grayBlue" style="float: left;" onclick="deleteRowInJibun()">선택 삭제</button-->
						<button class="button grayBlue" style="float: left;" onclick="fnDeleteRowInJibun();">선택 삭제</button>
						<button class="button blue02" style="float: left;" id="btCadastralInfo" onClick="selectCadastralInfo();">토지정보불러오기</button>
						<button class="button grayBlue btTxtInput" style="float: left;"  onClick="fnEnable('cadastral');">수동입력</button>
						<!--button class="button grayBlue" style="float: left;" id="btTxtInput" onClick="appointJibun();">대표 지정</button-->
						<button class="button grayBlue btTxtInput" style="float: left;" onClick="fnAppointJibun();">대표 지정</button>
						<button class="button blue02" style="float: left;" id="btViewPosition" onClick="fnLocation();">위치보기</button>
						<p style="line-height: 30px; padding-left: 10px; float: left;"><input name="radioInputJibun" type="radio" checked value="single" style="display:none;"><!--  단일필지 --></p>
						<p style="line-height: 30px; padding-left: 10px; float: left;"><input name="radioInputJibun" type="radio" value="all" style="display:none;"><!--  모두입력 --></p>
<%-- 						<button class="button grayBlue" style="float:right;" onclick="fnDownloadCsv();">양식받기</button><div style="float:right;"><form method="POST" action="<c:url value='/cmnmgmt/csvToTnLadInfo.json'/>"><input type="file" style="position: absolute; z-index: 100; width: 85px; height: 30px; opacity: 0;" name="file" onchange="fnAddFromCsv(this);"></form><button id="btUpCsv" style="" class="button blue02">파일추가</button></div> --%>
<!-- 						<p style="float: left; padding-left: 10px;line-height: 20px;"><input type="radio" name="radioInputJibun" value="multiple" /> 대표지번 외 <input type="text" style=" border: 0px;border-bottom: 1px solid #2F3031;"/> 필지</p> -->
					</td>
				</tr>
				<tr>
					<th>신청지번</th>
					<th>필지 면적 (㎡)</th>
					<th>지목</th>
					<th>용도지역</th>
					<th>용도지구</th>
				</tr>
			</tbody>
			</table>
			<table  class="simpleTable2 verticalSpacer doc" style="clear:both; table-layout: fixed; border-top: none; border-right: none; width:100%; border:0; ">
				<colgroup>
					<col style="width:10%"/>
					<col style="width:10%"/>
					<col style="width:10%"/>
					<col style="width:15%"/>
					<col style="width:20%"/>
					<col style="width:15%"/>
					<col style="width:20%"/>
				</colgroup>
				<tbody>
					<tr class="titleCell_line">
						<td colspan="7" class="tableHeaderBar roundBoxBG">
							<span class="text_14 text_yellow"><i class="axi axi-arrow-circle-right"></i></span>
							<span class="text_16">허가신청내용</span>
							<div id="mwContentLink" style="float: right; margin-top: -5px;">
								<button class="button white" onclick="showTable('mwContent'); return false;" style="width:77px; height:30px; line-height: 0px;">펼치기<i class='axi axi-ion-chevron-down' style="float:right;"></i></button>
							</div>
						</td>
					</tr>
				</tbody>
				<tbody id="mwContent">
					<tr>
						<th rowspan="14" class="mainTh">
							신청내용
							<input type="hidden" name="type">
							<input type="hidden" name="reqstType">
							<input type="hidden" name="reqstSttus">
							<input type="hidden" name="reqstDate">
							<input type="hidden" name="mountProg">
							<input type="hidden" name="updateUserSeq" value="<%=user.getUserSeq()%>">
							<input type="hidden" id="privacyUse" name="privacyUse" value="">
							<input type="hidden" id="privacyDeny" name="privacyDeny" value="">
						</th>
						<th colspan="2" rowspan="2">
							공작물 설치
						</th>
						<th><p class="handicraft nowrap">공작물구조 </p></th>
						<td><p class="handicraft"><input type="text" class="w80" name="atcnFabric" maxlength="100"></p></td>
						<th><p class="handicraft">부피</p></th>
						<td><p class="handicraft"><input type="text" class="w80 num132" title="공작물 설치-부피" name="atcnVl" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> ㎥</p></td>
					</tr>
					<tr>
						<th><p class="handicraft">신청면적</p></th>
						<td><p class="handicraft"><input type="text" class="w80 num132" title="공작물 설치-신청면적"  name="atcnArea" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> ㎡</p></td>
						<th><p class="handicraft">중량</p></th>
						<td><p class="handicraft"><input type="text" class="w80 num132" title="공작물 설치-중량"  name="atcnWt" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> kg</p></td>
					</tr>
					<tr>
						<th rowspan="6">
							 토지형질변경
						</th>
						<th rowspan="2">
							 토지현황
						</th>
						<th><p class="transformation">경사도</p></th>
						<td><p class="transformation"><input type="text" class="w80 num132" title="토지형질변경-경사도"   name="solGradient" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"></p></td>
						<th><p class="transformation">토질</p></th>
						<td><p class="transformation"><input type="text" class="w80" name="soil" maxlength="25"></p></td>
					</tr>
					<tr>
						<th><p class="transformation">토석매장량</p></th>
						<td colspan="3"><p class="transformation"><input type="text" class="w90 num132" title="토지형질변경-토석매장량"  name="landVl" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"></p></td>
					</tr>
					<tr>
						<th rowspan="2"> 입목식재현황</th>
						<th><p class="transformation">주요수종</p></th>
						<td colspan="3"><p class="transformation"><input type="text" class="w90" name="solSpecies"  maxlength="50"></p></td>
					</tr>
					<tr>
						<th><p class="transformation">입목지</p></th>
						<td><p class="transformation"><input type="text" class="w80 num132" title="토지형질변경-입목지" name="solTree" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"></p></td>
						<th><p class="transformation">무입목지</p></th>
						<td><p class="transformation"><input type="text" class="w80 num132" title="토지형질변경-무입목지" name="solNottree" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"></p></td>
					</tr>
					<tr>
						<th> 신청면적</th>
						<td colspan="4"><p class="transformation"><input type="text" class="w90 num132" title="토지형질변경-신청면적" name="solArea" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> ㎡</p></td>
					</tr>
					<tr>
						<th> 임목벌채</th>
						<th><p class="transformation">수종</p></th>
						<td><p class="transformation"><input type="text" class="w80" name="cutSpecies"  maxlength="50"></p></td>
						<th><p class="transformation">나무 수</p></th>
						<td><p class="transformation"><input type="text" class="w80 num132" title="토지형질변경-나무 수" name="cutNumber" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="10"> 그루</p></td>
					</tr>
					<tr>
						<th colspan="2">토석채취</th>
						<th><p class="collection">신청 면적</p></th>
						<td><p class="collection"><input type="text" class="w80 num132" title="토석채취-신청 면적" name="rockArea" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> ㎡</p></td>
						<th><p class="collection">부피</p></th>
						<td><p class="collection"><input type="text" class="w80 num132" title="토석채취-부피" name="rockVl" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> ㎥</p></td>
					</tr>
					<tr>
						<th colspan="2" rowspan="2">토지분할</th>
						<th>
							<p class="division">종전 면적</p>
						</th>
						<td id="divP">
							&nbsp;
						</td>
						<th><p class="division">분할 면적</p></th>
						<td id="divS">
							&nbsp;
						</td>
					</tr>
					<tr>
						<th><p class="division">병합 상세</p></th>
						<td colspan="3" style="padding-right: 75px;"><textarea rows="4" cols="100" name="sumDtl" style="display:inline-block;margin:0px;resize:none;"></textarea><a style="font-weight: bold; cursor: pointer; color: red; display: inline;" onclick="insertExamplePop();">입력방법 예시</a></td>
					</tr>
					<tr>
						<th rowspan="3" colspan="2">물건적치</th>
						<th><p class="heap">중량</p></th>
						<td><p class="heap"><input type="text" class="w80 num132" title="물건적치-중량"  name="thWt" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> kg</p></td>
						<th><p class="heap">부피</p></th>
						<td><p class="heap"><input type="text" class="w80 num132" title="물건적치-부피"  name="thVl" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"> ㎥</p></td>
					</tr>
					<tr>
						<th><p class="heap">품명</p></th>
						<td><p class="heap"><input type="text" class="w80" name="thNm"  maxlength="50"></p></td>
						<th><p class="heap">평균적치량</p></th>
						<td><p class="heap"><input type="text" class="w80 num132" title="물건적치-평균적치량"  name="thAvgHeap" placeholder="숫자" onkeydown='return isNumberKey(event)' onkeyup='isNumberKey(event)' style='ime-mode:disabled;' maxlength="14"></p></td>
						
					</tr>
					<tr>
						<th><p class="heap">적치기간</p></th>
						<td colspan="3"><p class="heap"><input type="text" id="txtHeapFrom" name="thHeapBgn">
						 ~ <input type="text" id="txtHeapTo" name="thHeapEnd"></p></td>
					</tr>
					<tr>
						<th colspan="3" style="text-align:center;padding-left: 10px;">개발행위목적</th>
						<td colspan="4"><input type="text" class="w100per_20px" name="prmisnPurpose" title="개발행위목적"  maxlength="100"></td>
					</tr>
					<tr>
						<th colspan="3">사업기간</th>
						<th>착공일자</th>
						<td >
							<input type="text" class="w100per_20px" id="txtConstructionStart" name="workDateBgn">
						</td>
						<th>준공일자</th>
						<td >
							<input type="text" class="w100per_20px" id="txtConstructionEnd" name="workDateEnd">
							<input type="hidden" name="fileGroupSeq">
							<input type="hidden" name="prmisnCode">
							<input type="hidden" name="prmisnSeq">
							<input type="hidden" name="prmisnType" value="DAB000010"> <!-- DAB000010 개발행위허가 신청 -->
							<input type="hidden" name="siteCode">
							<input type="hidden" name="eaisNo">
							<input type="hidden" name="femisNo">
						</td>
					</tr>
				</tbody>
			</table>
			<table  class="simpleTable2 verticalSpacer doc" style="clear:both; border-top: none; border-right: none; width:100%; border:0;">
				<tbody>
					<tr class="titleCell_line">
						<td class="tableHeaderBar roundBoxBG">
							<span class="text_14 text_yellow"><i class="axi axi-arrow-circle-right"></i></span>
							<span class="text_16">첨부서류</span>
							<div id="mwFileLink" style="float: right; margin-top: -5px;">
								<button class="button white" onclick="showTable('mwFile'); return false;" style="width:77px; height:30px; line-height: 0px;">펼치기<i class='axi axi-ion-chevron-down' style="float:right;"></i></button>
							</div>
							<button class="button blue02 topImg floatRight" style="margin-top: -5px;" onclick="javascript: window.open('http://www.law.go.kr/admRulBylInfoPLinkR.do?admRulSeq=2100000024606&admRulNm=개발행위허가운영지침&bylNo=0001&bylBrNo=00&bylCls=BE&bylClsCd=BE&joEfYd=&bylEfYd=', 'blank');">첨부서류 도움말</button>
						</td>
					</tr>
				</tbody>
			</table>
			<table  class="simpleTable2 doc" style="clear:both; table-layout: fixed; width:100%; border:0;">
				<colgroup>
					<col style="width:15%" />
					<col />
				</colgroup>
				<tbody id= "mwFile">
					<tr>
						<th>소유권관련 서류
							<!-- <br/><br/>					
							<span class="spanChk">
								설계도면 있음&nbsp;<input type="checkbox" style="vertical-align:middle;" onClick="fnAddInfo();" name="agendaFilesChkBox">
							</span> -->
						<!-- //
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('ownerShipFiles')">
							</div>
							// -->
						</th>
						<td>
							※토지대장등 토지 소유권 또는 사용권 증명 서류<br><br>
							<form action="#" class="w98 h98">
								<div id="ownerShipFiles">
								<ol id="ownerShipFileList" style="margin-top:2px;margin-left:20px;"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr style="display:none;" class="getOwnerShipFiles">
						
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>				
					<tr>
						<th>공사관련 도서서류
						<!-- //
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('constructionFiles')">
							</div>
							// -->
						</th>
						<td>
						※개요, 현장사진 등의 내용이 포함된 공사 또는 사업관련 도서<br><br>
							<form action="#" class="w98 h98">
								<div id="constructionFiles">
								<ol id="constructionFileList"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr style="display:none;" class="getConstructionFiles">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>		
					<tr>
						<th>설계도서서류 
						<!-- //
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('planFiles')">
							</div>
							// -->
						</th>
						<td>
						※공작물 설치에 해당하는 상세설계도서<br><br>
							<form action="#" class="w98 h98">
								<div id="planFiles">
								<ol id="planFileList"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr style="display:none;" class="getPlanFiles">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>	
					<tr>
						<th>건축물용도,규모서류 
						<!-- //
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('structureFiles')">
							</div>
							// -->
						</th>
						<td>
						※건축개요, 배치도, 평면도 등 개략 설계도서가 포함된 서류<br><br>
							<form action="#" class="w98 h98">
								<div id="structureFiles">
								<ol id="structureFileList"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr style="display:none;" class="getStructureFiles">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>	
					<tr>
						<th>도면,예산내역서류
						<!-- //
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('budgetFiles')">
							</div>
							// -->
						</th>
						<td>
						※각종 계획도, 공사내역 및 예산서 (공사관련 계획서에 포함된 경우 생략)<br><br>
							<form action="#" class="w98 h98">
								<div id="budgetFiles">
								<ol id="budgetFileList"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr style="display:none;" class="getBudgetFiles">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>	
					<tr>
						<th>위해/환경/경관/조경서류
						<!-- //
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('landscapeFiles')">
							</div>
							// -->
						</th>
						<td>
						※위해방지, 환경오염방지, 경관, 조경등을 위한 피해방지도, 복구계획도등 설계도서<br><br>
							<form action="#" class="w98 h98">
								<div id="landscapeFiles">
								<ol id="landscapeFileList"></ol>
								</div>
							</form>
						</td>
					</tr>
					<tr style="display:none;" class="getLandscapeFiles">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>	
					<tr>
						<th style="padding-top: 18px;">의제협의 
							<div class="right">
								<span class="spanChk"><input type="checkbox" style="vertical-align:middle;" name="agendaFilesChkBox"> 해당없음 &nbsp;</span>
								<!-- //
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('agendaFiles')">
								// -->
							</div>
						</th>
						<td id="agendaFilesButton">
	<!-- 						<div id="agendaFiles" class="bd_blk w98 h98" style="display: table;" onclick="fnAgendaOnClick();"> -->
	<!-- 							<p style="display: table-cell; text-align: left; vertical-align: middle; font-family: 돋움 extrabold; font-size: 16px; color: rgb(160,160,160);">여기를 눌러주세요</p> -->
	<!-- 						</div> -->
							<span><button style="width: calc(100% - 15px);" class="button blue02" onclick="fnAgendaOnClick();">의제협의 서류등록</button></span>
						</td>
					</tr>
					<tr>
						<th>기타서류<br>(CAD등 도면 전산원본파일)
						<!-- // 
							<div class="right">
								<img src="<c:url value='/resources/img/question.png' />" class="que_img" onClick="fnQuestionMark('etcFiles')">
							</div>
							// -->
						</th>
						<td>
							<form action="#" class="w98 h98">
								<div id="etcFiles">
								<ol id="etcFileList"></ol>
								</div>
							</form>
							<input type="hidden" name="fileType" value="00"/>
						</td>
					</tr>
					<tr style="display:none;" class="getEtcFiles">
						<td>
							<div style="width: calc(100% - 20px);  border: 1px solid rgb(125,125,125); text-align: left; vertical-align: middle; font-family: 나눔고딕 bold; height:51px;overflow:auto;">
							<ol></ol>
							</div>
						</td>
						<td style="display:none;"></td>
					</tr>	
				</tbody>
				<!-- 2015-10-30 ran //
				<tbody>
					<tr>
						<th colspan="3" class="center">신청일</th>
						<td colspan="4" id="regDate" class="center">
							<script type="text/javascript">document.write(new Date().format("yyyy년mm월dd일"));</script>
						</td>
					</tr>
					<tr>
						<td colspan="7" style="padding: 20px 0 20px; border: none;">
							<form action="<c:url value='/minwonmgmt/viewPrmisnDoc.do'/>" target="_blank" method="POST">
								<button id="btPrint" class="button black" style="min-width: 80px; float: right;">출력</button>--><!-- onclick="fnPrint();" -->
								<!-- 2015-10-30 ran //
							</form>
							<button id="btSubmit" class="button black" onclick="fnSubmit();" style="min-width: 80px; float: right;">신청</button>
							<button id="btSave" class="button blue" onclick="fnDoPost('minwonmgmt/viewSelectListMinwonAlert.do'); return false;" style="min-width: 80px; float: right;">임시 저장</button>
						</td>
					</tr>
				</tbody>
				// -->
			</table>
			<div class="applyDateBox">
				<div class="dateTitle">신청일</div>
				<div class="dateMsgBox">
					<script type="text/javascript">document.write(new Date().format("yyyy년mm월dd일"));</script>
				</div>
			</div>
			<div class="applyDateBox"  style="display:none;" id="tmlmtDateBox">
				<div class="dateTitle">처리기한</div>
				<div class="dateMsgBox">
					<span id="tmlmtDate" style="margin-left: 43%;color:red;"></span>
					<button id="btUpdateTmlmtDate" class="button blue02" onclick="fn_updateTmlmtDate();" style="min-width: 80px; float:right; margin-right:35%;">갱신</button>
				</div>
			</div>
			<div style="width:100%; height:15px;">
				<p class="mb10" style="text-indent: 15px; float:right; color:red; font-weight:bold;">* '신청' 버튼은 '임시저장'을 한 후에 활성화됩니다.</p>
			</div>
			<div class="bottom_btn">
				<button class="button gray" onclick="fnDoPost('minwonmgmt/viewSelectListMinwon.do');" style="min-width: 80px; float: right;">목록</button>
				<button id="btDelMinwon" class="button red" onclick="fnDelMinwon();" style="display:none; min-width: 80px; float: right;">삭제</button>
				<button id="btSubmit" class="button blue02" onclick="fnSubmitLast();" style="min-width: 80px; float: right; display:none;">신청</button>
				<button id="btSave" class="button grayBlue" onclick="fnTemporarySave();" style="min-width: 80px; float: right;">임시 저장</button>
				<button id="btComplement" class="button grayBlue" onclick="fnCommissionChek();" style="min-width:80px; float:right;">서류보완완료</button>
				<button id="btPrint" class="button grayBlue" onclick="fnPrint();" style="min-width: 80px; float: right;"><i class="axi axi-print"></i> 출력</button>
	<!-- 			<button id="btDelete" class="button red" onclick="fnDeletePrmisn();" style="min-width: 80px; float: right;"><i class="axi-delete2"></i> 삭제</button> -->
			</div>
		</div>
	</section>
	<div id="applicantList" class="wrapDesign_2 none" title="신청인선택">
		<div class="topAreaPopup">
		    <i class="axi axi-dvr titleIcon"></i>
		    <span class="sectionSubject">신청인선택</span>
		    <span class="sectionDesc" style="padding-left:10px;">개발행위허가 신청인을 선택합니다.</span>
	    </div>
	   <div class="dialogContent">
	    	<div class="shape icon" style="width: 140px;">
				<span style="font-weight: bold;font-size:1em;"> </span>
			</div>
			<form action="#" method="POST">
				<div class="appSearchBox" >
					<input type="hidden" id="loginUserSeq" value="<%=user.getUserSeq()%>"/>
					<table class="simpleTable2" style="width:100%; margin-bottom: 15px;">
						<colgroup>
							<col style="width:15%"/>
							<col style="width:25%"/>
							<col style="width:15%"/>
							<col style="width:45%"/>
						</colgroup>
						<tbody>
							<tr class="firstTr">
								<th>등록상태</th>
								<td style="padding : 10px;">
									<select id="abrrUserYn" style="width: 100%;">
										<option value="">전체</option>
										<option value="N" selected="selected">정상등록</option>
										<option value="Y">임의등록</option>
									</select>
								</td>
								<th>성명</th>
								<td style="padding : 10px;">
									<input type="text" name="appNm" id="appNm" maxlength="200" style="width :60%;margin: 7px 0px;">
									<span style="float: right;"><input type="button" value="검 색" class="button green" onClick="fnSelectApplicant('search');" style="width:105px;"></span>
								</td>
								
							</tr>
						</tbody>
					</table>
					<input type="hidden" id="cpttrUserSeq" name="cpttrUserSeq" value="${cpttrUserSeq}">
				</div>
			</form>
    		<div id="listAddApplicant">
    			
    		</div>
	    </div>
	    <div>
	    	<div style="text-align:center">
				<button onClick="fnAddToList();" class="button blue02"><span class="text_16"><i class="axi axi-ion-checkmark-circled"></i> 선택완료</span></button>
		  		<button onclick="modalPop.dialog('close');" class="button grayBlue"><span class="text_16"><i class="axi axi-ion-close-circled"></i> 닫기</span></button>
			</div>
		</div>
	</div>
</body>
</html>