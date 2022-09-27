package com.example.demo.vo;

import lombok.Data;

@Data//(@Setter, Getter를 포함하고 있다) 롬북을 사용하고 있기 때문에..
public class MemberVO {
// ctrl + shift + y = 대문자를 -> 소문자
	 private int	mem_no      = 0;
	 private String mem_id      = null;
	 private String mem_pw      = null;
	 private String mem_name    = null;
	 private String mem_zipcode = null;
	 private String mem_address = null;
	 // member테이블에는 없는 칼럼이지만 업무처리릉 위해 필요한 변수선언 - 기능적으로... 필요함
	 // 눈에 보이지 않는 컬럼 혹은 변수 찾아내서 처리할 수 있어야 한다.
	 private int count = 0;

}
