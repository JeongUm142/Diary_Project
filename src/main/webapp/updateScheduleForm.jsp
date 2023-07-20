<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>

<%
	if(request.getParameter("scheduleNo") == null
	|| request.getParameter("scheduleNo").equals("")) {
	//response - 돌아가
	response.sendRedirect("./scheduleList.jsp");
	return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
		System.out.println(scheduleNo + "<--updatescheduleForm scheduleNo");
	String scheduleDate = request.getParameter("scheduleDate");
		System.out.println(scheduleDate + "<--updatescheduleForm scheduleDate");

	//일별 스케줄 리스트
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	//번호에 맞는 정보를 보여주기 위해  ? 처리
	String sql = "select schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, schedule_date scheduleDate from schedule where schedule_no=?";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	
		System.out.println(stmt + "<--updatescheduleForm stmt");
		
	ResultSet rs = stmt.executeQuery();
		
	//값이 한개라서 ArrayList 사용X
	rs.next();
		Schedule s = new Schedule();
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleColor = rs.getString("scheduleColor");

		
	// y, m, d 나누기
	String y = s.scheduleDate.substring(0, 4);
	int m = Integer.parseInt(s.scheduleDate.substring(5, 7));
	int d = Integer.parseInt(s.scheduleDate.substring(8));
	
	// m 과 d 는 문자형으로 나타낼때 1~9일때 앞에 0이 붙어야해서 분기줌
	String strM = m + "";
	if(m<10) {
		strM = "0" + strM;
	}
	String strD = d + "";
	if(d<10) {
		strD = "0" + strD;
	}
	
	System.out.println(strM + " <-- scheduleListByDate strM");

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
	<h1>스케줄 수정</h1>
<hr>
	<form action="./updateScheduleAction.jsp?scheduleNo=<%=scheduleNo%>" method="post">
	<table class="table table-bordered">
			<tr>
				<td class="table-danger"  style="width: 10%">일자</td>
				<td><input type = "date" name ="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly"></td>
			</tr>
			
			<tr>
				<td class="table-danger">시간</td>
				<td><input type = "time" name ="scheduleTime" value="<%=s.scheduleTime%>"></td>
			</tr>
			
			<tr>
				<td class="table-danger">분류색상</td>
				<td><input type = "color" name ="scheduleColor" value="#000000"></td>
			</tr>
	
			<tr>
				<td class="table-danger">내용</td>
				<td><textarea rows="3" cols="80" name="scheduleMemo"><%=s.scheduleMemo%></textarea></td>
			</tr>
			
			<tr>
				<td class="table-danger">비밀번호</td>
				<td><input type = "password" name ="schedulePw"></td>
			</tr>
		</table>		

		<button type="submit" class="btn btn-outline-dark btn-sm">수정</button>
		<a href="./scheduleListByDate.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-outline-dark btn-sm">취소 </a>
	</form>
	

</div>
</body>
</html>