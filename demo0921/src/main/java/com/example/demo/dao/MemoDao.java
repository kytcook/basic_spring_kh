package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

// 모델 계층에 붙이는 @Component의 자손 어노테이션이다.
@Service
public class MemoDao {
	Logger logger = LoggerFactory.getLogger(MemoDao.class);
	@Autowired(required = false)
	private SqlSessionTemplate sqlSessionTemplate = null;
	
	// 받은쪽지 중 읽지 않은 쪽지 카운트
	public int noReadMemo(Map<String, Object> pMap) {
		logger.info("noReadMemo 호출 성공 ==> "+ pMap);//pMap에 to_id가 있어야 해
		int cnt = 0;
		cnt = sqlSessionTemplate.selectOne("noReadMemo", pMap);
		logger.info("cnt ==> "+ cnt);// 배달 사고가 어디서 발생한건지 체크 하기 위한 코드 추가 필요함.
		return cnt;
	}

	public int memoinsert(Map<String, Object> pMap) {
		logger.info("memoinsert 호출 성공 ==> "+ pMap);//101
		int result = 0;
		try {
			result = sqlSessionTemplate.update("memoInsert", pMap);
			logger.info("result : "+result);
		} catch (DataAccessException e) {
			logger.info("Exception : "+e.toString());
		} 
		return result;
	}

	public List<Map<String, Object>> sendMemoList(Map<String, Object> pMap) {
		logger.info("sendMemoList 호출 성공 ==> "+pMap);//101
		List<Map<String, Object>> sendMemoList = null;
		sendMemoList = sqlSessionTemplate.selectList("sendMemoList", pMap);
		logger.info(sendMemoList.toString());//101
		return sendMemoList;
	}
	
	public List<Map<String, Object>> receiveMemoList(Map<String, Object> pMap) {
		logger.info("receiveMemoList 호출 성공 ==> "+pMap);//101
		List<Map<String, Object>> receiveMemoList = null;
		receiveMemoList = sqlSessionTemplate.selectList("receiveMemoList", pMap);
		logger.info(receiveMemoList.toString());//101
		return receiveMemoList;
	}

	public Map<String, Object> memoContent(Map<String, Object> pMap) {
		Map<String, Object> rMap = null;
		rMap = sqlSessionTemplate.selectOne("memoContent", pMap);
		logger.info(rMap.toString());
		logger.info("으으아아아"+rMap);
		return rMap;
	}

	public void readYnUpdate(Map<String, Object> pMap) {
		sqlSessionTemplate.update("readYnUpdate", pMap);
		
	}

}
