package com.vo;

public class BoardMasterVO {
	private int    b_no     =0;// 
	private String b_title  ="";// 
	private String b_writer ="";// 
	private String b_email  ="";// 
	private String b_content="";// 
	private int    b_hit    =0;// 
	private String b_date   ="";// 
	private int    b_group  =0;// 
	private int    b_pos    =0;// 
	private int    b_step   =0;// 
	private String b_pw     ="";// 
	//조건 검색시 필요한 변수 선언
	private String cb_search ="";//b_title or b_content or b_writer
	private String keyword = "";//사용자가 입력한 문자열
	//페이지 네이션 처리시 필요한 변수 선언
	private int    pageNumber = 0;
	private int    pageSize = 0;
	private int    start     =0;//페이지네이션 처리시 시작번호
	private int    end       =0;//페이지네이션 처리시 끝번호
	//업무처리 구분 - 상세조회시 detail
	private String gubun     =null;
	public int getb_no() {
		return b_no;
	}
	public void setb_no(int b_no) {
		this.b_no = b_no;
	}
	public String getb_title() {
		return b_title;
	}
	public void setb_title(String b_title) {
		this.b_title = b_title;
	}
	public String getb_writer() {
		return b_writer;
	}
	public void setb_writer(String b_writer) {
		this.b_writer = b_writer;
	}
	public String getb_email() {
		return b_email;
	}
	public void setb_email(String b_email) {
		this.b_email = b_email;
	}
	public String getb_content() {
		return b_content;
	}
	public void setb_content(String b_content) {
		this.b_content = b_content;
	}
	public int getb_hit() {
		return b_hit;
	}
	public void setb_hit(int b_hit) {
		this.b_hit = b_hit;
	}
	public String getb_date() {
		return b_date;
	}
	public void setb_date(String b_date) {
		this.b_date = b_date;
	}
	public int getb_group() {
		return b_group;
	}
	public void setb_group(int b_group) {
		this.b_group = b_group;
	}
	public int getb_pos() {
		return b_pos;
	}
	public void setb_pos(int b_pos) {
		this.b_pos = b_pos;
	}
	public int getb_step() {
		return b_step;
	}
	public void setb_step(int b_step) {
		this.b_step = b_step;
	}
	public String getb_pw() {
		return b_pw;
	}
	public void setb_pw(String b_pw) {
		this.b_pw = b_pw;
	}
	public int getStart() {
		return start;
	}
	public void setStart(int start) {
		this.start = start;
	}
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}
	public int getPageNumber() {
		return pageNumber;
	}
	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public String getCb_search() {
		return cb_search;
	}
	public void setCb_search(String cb_search) {
		this.cb_search = cb_search;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
}
