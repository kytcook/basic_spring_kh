<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>초성유무 체크하기</title>
</head>
<body>
<script type="text/javascript">
	let code;
	const cho = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ",
        "ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
        "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ",
        "ㅋ","ㅌ","ㅍ","ㅎ"];	
	code = "혼".charCodeAt(0);
	console.log(code);
	code = "혼".charCodeAt(0)-44032;
	console.log(code);
	code = 	Math.floor(code/588);
	console.log(code);
	console.log(cho[code])
</script>
</body>
</html>