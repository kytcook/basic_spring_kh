package com.example.demo.vo;

import lombok.Data;
//@Getter
//@Setter
//@NoArgXXX 이 3개를 한번에 해결하는거 @Data
@Data
public class DeptVO {
	private int deptno;
	private String dname;
	private String loc;
}
