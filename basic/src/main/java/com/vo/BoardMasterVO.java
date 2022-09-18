package com.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardMasterVO {
	private int    b_no      =0; 
	private String b_title   =""; 
	private String b_writer  =""; 
	private String b_content =""; 
	private int    b_hit     =0; 
	private int    b_group   =0; 
	private int    b_pos     =0; 
	private int    b_step    =0; 
	private String b_date    =""; 
	private String b_pw      =""; 
}
