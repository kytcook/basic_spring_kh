package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// static > js > main.js에서 ajax 통신시 응답객체로 사용함
// HomeController @PostMapping("ajaxPost") 에서 사용함

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AjaxResponseVO<T> {
	int status;
	T data;
}
