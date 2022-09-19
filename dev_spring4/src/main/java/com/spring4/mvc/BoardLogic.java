package com.spring4.mvc;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

public class BoardLogic {
	Logger logger = Logger.getLogger(BoardLogic.class);		
	private BoardDao boardDao = null;
	public void setBoardDao(BoardDao boardDao) {
		this.boardDao = boardDao;
	}
	//로직에서는 그대로 모두 사용함 - RequestParam이나 RequestMapping, Model모두 필요없음
	//공통된 관심사는 트랜잭션 처리 - 하나의 메소드에서 Dao에 두 개 메소드 호출
	//board_master_t, board_sub_t
	public List<Map<String,Object>> boardDetail(Map<String, Object> pMap){
		logger.info("boardDetail 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = boardDao.boardList(pMap);
		if(boardList!=null && boardList.size()==1) {
			boardDao.hitCount(pMap);
		}
		return boardList; 
	}
	public List<Map<String, Object>> boardList(Map<String, Object> pMap) {
		logger.info("boardList 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = boardDao.boardList(pMap);
		return boardList;
	}
	// 하나의 메소드 안에서 DAO의 여러 메소드를 호출할 수 있음 - 트랜잭션처리 공통된 관심사를 갖는 부분
	// 로직은 여러 가지의 처리를 할 수 있고 이에 따른 선택기준이 필요한 부분
	public int boardInsert(Map<String, Object> pMap) {
		logger.info("boardInsert 호출 성공");
		int result = 0;
		int b_no = 0;
		int b_group = 0;
		//글번호 채번 - 한번
		b_no = boardDao.getBNo();
		pMap.put("b_no", b_no);
		if(pMap.get("b_group")!=null) {
			b_group = Integer.parseInt(pMap.get("b_group").toString());
		}
		//댓글쓰기
		if(b_group > 0) {
			// 아래 코드는 내 뒤에 댓글이 있을 때만 처리가 된다
			// 내 뒤에 댓글있으면 두번
			boardDao.bStepUpdate(pMap);
			pMap.put("b_pos", Integer.parseInt(pMap.get("b_pos").toString())+1);
			pMap.put("b_step", Integer.parseInt(pMap.get("b_step").toString())+1);
		}
		//새글쓰기
		else {
			//새글쓰기에서는 댓글쓰기와는 다르게 그룹번호를 새로 채번해야 함
			//새글일때 그룹번호 채번할 때 세번
			b_group = boardDao.getBGroup();
			pMap.put("b_group", b_group);
			pMap.put("b_pos", 0);
			pMap.put("b_step", 0);
		}
		result = boardDao.boardMInsert(pMap);// 새글쓰기, 댓글쓰기 동시
		//첨부파일이 있는 경우에만 board_sub_t 추가함
		//첨부 파일이 있니?
		if(pMap.get("bs_file")!=null && pMap.get("bs_file").toString().length()>1) {
			pMap.put("b_no", b_no);
			pMap.put("bs_seq", 1);
			int result2 = boardDao.boardSInsert(pMap);
			//logger.info("result2가 1이면 등록 성공===> "+result2);
		}
		return result;
	}
	public int boardUpdate(Map<String, Object> pMap) {
		int result = 0;
		result = boardDao.boardMUpdate(pMap);
		return result;
	}
	public int boardDelete(Map<String, Object> pMap) {
		int result = 0;
		result = boardDao.boardMDelete(pMap);
		return result;
	}


}
