<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>회원가입</title>
    <script>
      function memberInsert(event) {
        event.preventDefault();
        document.getElementById("f_member").submit();
      }
    </script>
  </head>
  <body>
    <h1>회원가입 페이지</h1>
    <hr />
    <form id="f_member" action="./memberInsert" method="get">
      이름 : <input type="text" name="username" /><br />
      비번 : <input type="password" name="password" /><br />
      이메일 : <input type="email" name="email" value="test@hot.com" /><br />
      <button onclick="memberInsert()">저장</button>
    </form>
  </body>
</html>
