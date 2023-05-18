<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//요청값에 대한 유효성 검사
	if(request.getParameter("noticeNum") == null) {
	//response - 돌아가
	response.sendRedirect("./noticeList.jsp");
	return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 

	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));
	String noticePw = request.getParameter("noticePw");
	//디버깅★
	System.out.println(noticeNum + "<--deleteNoticeForm param noticeNum");
	System.out.println(noticePw + "<--deleteNoticeForm param noticePw");
	
%>
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
		<a href="./noticeList.jsp" class="btn btn-outline-dark">공지 리스트</a>&nbsp;
		<a href="./home.jsp" class="btn btn-outline-dark">&#x1F3E0</a>&nbsp;&nbsp;
		<a href="./scheduleList.jsp" class="btn btn-outline-dark">일정 리스트</a>
	</div>
	<br>
	<h1>공지 삭제</h1>
	<hr>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<td class="table-info">공지 번호</td>
					<!-- hidden= 보이지 않음 or readonly -->
				<td>
					<input type="text" name="noticeNum" value="<%=noticeNum%>" readonly="readonly">
				</td>
			</tr>
			
			<tr>
				<td class="table-info">비밀번호 입력</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-dark btn-sm">삭제</button>
		<a href="./noticeOne.jsp?noticeNum=<%=noticeNum%>" class="btn btn-outline-dark btn-sm">취소 </a>
		
	</form>
</div>
</body>
</html>