package com.kh.test.board.model.vo;

public class Board {
	private int bid;
	private String title;
	private String writer;
	private String content;
	private String bDate;
	public Board() {}
	public Board(int bid, String title, String writer, String content, String bDate) {
		this.bid = bid;
		this.title = title;
		this.writer = writer;
		this.content = content;
		this.bDate = bDate;
	}
	public int getBid() {
		return bid;
	}
	public void setBid(int bid) {
		this.bid = bid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getbDate() {
		return bDate;
	}
	public void setbDate(String bDate) {
		this.bDate = bDate;
	}
}
