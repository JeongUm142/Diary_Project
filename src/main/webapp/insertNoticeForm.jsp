<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>	
</head>
<body>
<div class="container">
<br>
	<div style="text-align: center"><!-- 메인메뉴 --> 
		<a href="./noticeList.jsp" class="btn btn-outline-dark">공지 리스트<sup>&#x2B50</sup></a>&nbsp;
		<a href="./home.jsp" class="btn btn-outline-dark">&#x1F3E0</a>&nbsp;&nbsp;
		<a href="./scheduleList.jsp" class="btn btn-outline-dark">일정 리스트 <sup>&#x1F338</sup></a>
	</div>
	<h1>공지 입력</h1>
<hr>
	<form action="./insertNoticeAction.jsp" method="post">
	<table class="table table-bordered">
		<tr>
			<td class="table-info" style="width: 10%">제&nbsp;&nbsp;&nbsp;목</td>
			<td>
				<input type="text" name="noticeTitle">
			</td>
		</tr>
		<tr>
			<td class="table-info">내&nbsp;&nbsp;&nbsp;용</td>
			<td>
				<textarea rows="5" cols="80" name="noticeContent"></textarea>
			</td>
		</tr>
		<tr>
			<td class="table-info">작성자</td>
			<td>
				<input type="text" name="noticeWriter">
			</td>
		</tr>
		<tr>
			<td class="table-info">비밀번호</td>
			<td>
				<input type="password" name="noticePw">
			</td>
		</tr>
	</table>
	<button type="submit" class="btn btn-outline-dark btn-sm">입력</button>
	<a href="./noticeList.jsp" class="btn btn-outline-dark btn-sm">취소 </a>
	</form>
</div>
</body>
</html>