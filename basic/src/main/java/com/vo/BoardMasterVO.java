package com.vo;

public class BoardMasterVO {
	private int    bm_no     =0;// 
	private String bm_title  ="";// 
	private String bm_writer ="";// 
	private String bm_email  ="";// 
	private String bm_content="";// 
	private int    bm_hit    =0;// 
	private String bm_date   ="";// 
	private int    bm_group  =0;// 
	private int    bm_pos    =0;// 
	private int    bm_step   =0;// 
	private String bm_pw     ="";// 
	//조건 검색시 필요한 변수 선언
	private String cb_search ="";//bm_title or bm_content or bm_writer
	private String keyword = "";//사용자가 입력한 문자열
	//페이지 네이션 처리시 필요한 변수 선언
	private int    pageNumber = 0;
	private int    pageSize = 0;
	private int    start     =0;//페이지네이션 처리시 시작번호
	private int    end       =0;//페이지네이션 처리시 끝번호
	//업무처리 구분 - 상세조회시 detail
	private String gubun     =null;
	public int getBm_no() {
		return bm_no;
	}
	public void setBm_no(int bm_no) {
		this.bm_no = bm_no;
	}
	public String getBm_title() {
		return bm_title;
	}
	public void setBm_title(String bm_title) {
		this.bm_title = bm_title;
	}
	public String getBm_writer() {
		return bm_writer;
	}
	public void setBm_writer(String bm_writer) {
		this.bm_writer = bm_writer;
	}
	public String getBm_email() {
		return bm_email;
	}
	public void setBm_email(String bm_email) {
		this.bm_email = bm_email;
	}
	public String getBm_content() {
		return bm_content;
	}
	public void setBm_content(String bm_content) {
		this.bm_content = bm_content;
	}
	public int getBm_hit() {
		return bm_hit;
	}
	public void setBm_hit(int bm_hit) {
		this.bm_hit = bm_hit;
	}
	public String getBm_date() {
		return bm_date;
	}
	public void setBm_date(String bm_date) {
		this.bm_date = bm_date;
	}
	public int getBm_group() {
		return bm_group;
	}
	public void setBm_group(int bm_group) {
		this.bm_group = bm_group;
	}
	public int getBm_pos() {
		return bm_pos;
	}
	public void setBm_pos(int bm_pos) {
		this.bm_pos = bm_pos;
	}
	public int getBm_step() {
		return bm_step;
	}
	public void setBm_step(int bm_step) {
		this.bm_step = bm_step;
	}
	public String getBm_pw() {
		return bm_pw;
	}
	public void setBm_pw(String bm_pw) {
		this.bm_pw = bm_pw;
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
