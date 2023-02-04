/* 	function isNumberKey(event) {

	} */
  const readline = require("readline");

  const rl = readline.createInterface({
    // 모듈을 이용해 입출력을 위한 인터페이스 객체 생성
    input: process.stdin,
    output: process.stdout,
  });
  
  rl.on("close", (line) => {
    const number = line; // 소수점 세째 자리에서 내림하여 1.00으로 만들고 싶음
    const temp1 = number * 100;
    const temp2 = Math.floor(temp1);
    const result = temp2 / 100;
  
    console.log(result);
    rl.close();
  });
  