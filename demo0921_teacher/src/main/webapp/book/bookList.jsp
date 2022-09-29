<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../common/easyui_common.jsp" %>
<style type="text/css">
	#d_search {
		position: absolute;
	}
</style>
<script type="text/javascript">
	function choseongCheck(str){
		//alert(str);
		const cho = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ",
	                 "ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
	                 "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ",
	                 "ㅋ","ㅌ","ㅍ","ㅎ"];
		let result="";
		let code;
		for(let i=0;i<str.length;i++){
			code = str.charCodeAt(i)-44032;
			console.log(code);
			if(code > -1 && code <11172) result += cho[Math.floor(code/588)];
		}
		return result;
	}// end of choseongCheck
</script>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function(){// 익명함수 - 리액트 -리덕스공부
			const t = $('#bk_title');
			t.textbox('textbox').bind('keyup', function(e){
				// 사용자가 입력한 책제목 담기
				let word = $('#_easyui_textbox_input1').val();
				//console.log(word);
				//입력받은 책제목중 한글에 대해 초성만 추출하기
				let choKeyword = choseongCheck(word);
				let choMode;
				if(choKeyword === ""){
					choMode = "Y";
				}else{
					choMode = "N";					
				}
				console.log("choKeyword : "+choKeyword);
				let param = "bk_title="+word+"&choMode="+choMode
				// 초성검색 구분
				// get방식은 브라우저에 의해 같은 요청일 경우 인터셉트를 당하게 됨 -  Restful API, 
				// get방식이지만 인터셉트를 피할 수 있는 방법은 쿼리스트링을 추가하는 것이다.
				$.ajax({
					  method: "POST",
					  url: "./bookList",
					  data: param,
					  success:function(result) {// result -> searchResult.jsp -> html태그들이다.
					   console.log(result);
					   $("#d_search").css("border","#000000 1px solid");
					   $("#d_search").css("left",$("#_easyui_textbox_input1").offset().left+"px");
					   $("#d_search").html(result);
					  }//end of success
					 ,error:function(e){
						 $("#d_search").text(e.responseText);//에러메시지 출력됨 - 힌트 - 디버깅
					 }
				});// end of ajax 
			});			
		});
	</script>
	검색어 : <input id="bk_title" name="bk_title" class="easyui-textbox" style="width:200px" />
	<div id="d_search"></div>
</body>
</html>