<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	if(request.getParameter("scheduleNo") == null) {
		
	response.sendRedirect("./scheduleList.jsp");
	return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 

	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	
	System.out.println(scheduleNo + "<--deleteScheduleForm param scheduleNo");
	System.out.println(schedulePw + "<--deleteScheduleForm param schedulePw");

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Diary</title>
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
<br>
	<h1>스케줄 삭제</h1>
<hr>
	<form action="./deleteScheduleAction.jsp" method="post">
	<table class="table table-bordered" style="text-align: center;">
		<tr>
			<td class="table-danger">번호</td>
			<td>
				<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
			</td>
		</tr>
		
		<tr>
			<td class="table-danger">비밀번호</td>
			<td><input type="password" name="schedulePw"></td>
		</tr>
	</table>
		<button type="submit" class="btn btn-outline-dark btn-sm">삭제</button>
		<a href="./scheduleListByDate.jsp?scheduleNo=<%=scheduleNo%>" class="btn btn-outline-dark btn-sm">취소 </a>
	</form>
</div>
</body>
</html> 