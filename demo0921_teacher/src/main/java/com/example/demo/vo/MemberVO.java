package com.example.demo.vo;

import lombok.Data;

@Data//(@Setter, @Getter)
public class MemberVO {
	private int    mem_no       =0;//
	private String mem_id       =null;//
	private String mem_pw       =null;//
	private String mem_name     =null;//
	private String mem_zipcode  =null;//
	private String mem_address  =null;//
	//member테이블에는 없는 컬럼이지만 업무처리를 위해 필요한 변수선언 - 기능적으로...필요함
	//눈에 보이지 않는 컬럼 혹은 변수 찾아내서 처리할 수 있는 개발자 - good
	private int count = 0;
}
