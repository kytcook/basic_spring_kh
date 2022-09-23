package com.example.demo.vo;

import lombok.Data;

@Data
public class MemberVO {
// ctrl + shift + y = 대문자를 -> 소문자
	 private int	mem_no      = 0;
	 private String mem_id      = null;
	 private String mem_pw      = null;
	 private String mem_name    = null;
	 private String mem_zipcode = null;
	 private String mem_address = null;

}
