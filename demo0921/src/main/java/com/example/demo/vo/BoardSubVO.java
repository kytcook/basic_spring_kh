package com.example.demo.vo;

import lombok.Data;

@Data
public class BoardSubVO {
	private String 	b_file 	= "";
	private String 	bs_size = "";
	private int		b_no 	= 0;
	private int	 	bs_seq	= 0;
	public String getB_file() {
		return b_file;
	}
	public void setB_file(String b_file) {
		this.b_file = b_file;
	}
	public String getBs_size() {
		return bs_size;
	}
	public void setBs_size(String bs_size) {
		this.bs_size = bs_size;
	}
	public int getB_no() {
		return b_no;
	}
	public void setB_no(int b_no) {
		this.b_no = b_no;
	}
	public int getBs_seq() {
		return bs_seq;
	}
	public void setBs_seq(int bs_seq) {
		this.bs_seq = bs_seq;
	}
}
