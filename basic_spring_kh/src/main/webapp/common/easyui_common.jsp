<%	
	/*
	• JS를 통해서 풀스택을 체험 - FireBase가 지원사격 탕탕
	
	• 서로 이야기로 엮어준다. 한 그림으로.
	• 스크립틀릿안에 메소드 선언할 수 있다|없다★
	• 확장자를  jsp로 해야 스크립틀릿 사용이 가능함
	• CSS : 멋부리기 / JS : Get과 Post - 정적인 애(HTML)를 동적으로 바꿔준다. => 서버와 동기화가 안되어있다.
	• jsp = html + CSS + JS (브라우저가 처리주체이다-인터프리터-로컬-다운로드)(프론트) / + JAVA (백앤드 - 톰캣서버가 주체이다 - 서버측처리된 결과가 다운로드됨)
	• 왜 중요한 걸까? - 시간차(인스턴스화-위치-싱글톤패턴-서블릿은 싱글톤으로 관리된다. ) : 브라우저와 서버간의 응답시에 발생하는 시점차이/ 위치차이
	• ※톰캣 : 서블릿을 관리한다. 라이프 사이클을 관리한다.
	• 서블릿의 라이프 사이클 -> 스레드로 관리한다. 관리되는 주체는 객체(서블릿)
	• 위 3가지 중에서 개발자는? 서비스를 책임진다. init(), - service(req,res) ※ doGet,doPost(구분할 수 있다) : 서비의 다른 버전 - destroy()
	• 톰캣 서버가 init()과 destroy() 책임진다 - 개발자 책임이 아니다.
	• a.jsp -> a_jsp.java -> a_jsp.class -> 브라우저 쓰기
	• jsp컨테이너(엔진), servlet-api.jar(서블린엔진)
	• 왜 서블릿이어야 하는가?
	• 서블릿이어야 웹서비스가 가능하다
	• 웹서비스는 요청으로 시작하여 응답으로 끝난다.
	• 요청객체와 응답객체 객체주입이 필요하다.
	• 누가 누구에게 주입을 해주나? 요청시 전송방식 - GET / POST
	• 서비스를 제공하는 백엔드단에서 전송방식에 매칭되는 메소드가 필요함
	• doGET, doPost - 메소드 이름이 일치해야 하고 
	• init() - service() - destroy() 태어나서 사라지는 과정
	• 프로젝트 이름마다 경로가 다를 수 있다.
	• 매번 그때마다 경로를 수정한다???
	• -> WAS에서 관리하는 server.xml문서에서 Context에 정보를 가져오는 메소드 호출임.
	• java -> compile -> (class.서블릿)은 브라우저에 쓴다 -> jsp
	
	• 리액트 : 데이터를 가지고 돔을 조작한다.
	*/
	
	// 지역변수이다. jsp가 서블릿 코드로 전환이 되니까->서비스메소드 안에 들어간다 ->스크립틀릿 안에
    StringBuilder path = new StringBuilder(request.getContextPath());
    path.append("/");
%>   
<!-- 재사용성이 높다. (강의다시보기)  -->
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>demo/demo.css">
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/icon.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>