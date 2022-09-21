package com.example.demo.vo;

public class BoardMain {

	public static void main(String[] args) {
		BoardMasterVO bmVO = new BoardMasterVO();
		BoardSubVO bsVO = new BoardSubVO();
		bsVO.setBs_file("공정표");
		bsVO.setBs_size("5.5");
		System.out.println(bsVO);
		bmVO.setB_no(10);
		bmVO.setB_writer("이성계");
		bmVO.setBoardSubVO(bsVO);
		System.out.println(bmVO.getBoardSubVO());

	}

}
