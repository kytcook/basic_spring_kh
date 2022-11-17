// 자스는 일급함수. 함수도 객체취급 - ES6 -> const or let -> 생성부의 이름으로 객체를 생성됨
let main = {
	//여기서의 this값과 on이벤트 함수내 this가 동일한 값을 가리키도록 하기 위해 4번에서 arrow function사용함
	init: function(){
		$("#btn-send").on("click", () => {// this를 바인딩하기 위해서 arrow function사용함
			this.send();
		});
		$("#btn-send2").on("click", () => {// this를 바인딩하기 위해서 arrow function사용함
			this.send2();
		});
	},
	send: function(){
		console.log("main.jsp의 send함수 호출 성공");
		// form 전송 key=value&key1=value1
		// RestController === @ResponseBody
		// 아래와 같이 쿼리스트링으로 넘기면 모든 값을 문자열 취급을 하니까
		// 아래 JSON포맷객체는 깨져서 브라우저에 전달됨 -> 이걸 찍으면{Object, Object}
		let data = { // 데이터를 오브젝트로 묶음 -> 왜냐면 JSON으로 전송 -> @RequestBody -> POST방식 -> form 없이
			mem_name: $("#mem_name").val(),
			mem_id: $("#mem_id").val(),
		}
		console.log(data);
		//ajax호출시 default가 비동기 호출임
		//ajax 통신을 이용해서  3개의 데이터를 json으로 변경하여 insert요청함
		//ajax가 통신을 성공하고 서버가 json을 리턴해주면 자동으로 자바오브젝트로 변환해 줌
		$.ajax({
			type: "post",
			url:"/home/ajaxPost",
			data:JSON.stringify(data),
			contentType: "application/json; charset=utf-8",//body데이터가 어떤 타입인지
			dataType:"json",//요청에 대한 응답이 왔을 때 타입적음(기본은 버퍼로 오니까 문자열임)
		}).
		done(function(result){
			console.log(result);//{status: 200, data: 1}가 출력됨 - location.href가 없어야 확인가능
			alert("전송 되었습니다.");
			//location.href="/auth/loginForm";
		}).
		fail(function(error){
			console.log(JSON.stringify(error));
		});//ajax 통신을 통해 3개의 데이터를 json으로 변경하여 insert요청
	},
	send2: function(){
		console.log("main.jsp의 send2함수 호출 성공");
		$.ajax({
			type: "get",
			url:"/home/ajaxPost2?mem_id=apple&mem_name=사과",
		}).
		done(function(result){
			console.log(result);//{status: 200, data: 1}가 출력됨 - location.href가 없어야 확인가능
			alert("전송 되었습니다.");
			//location.href="/auth/loginForm";
		}).
		fail(function(error){
			console.log(JSON.stringify(error));
		});//ajax 통신을 통해 3개의 데이터를 json으로 변경하여 insert요청
	},
}

main.init();