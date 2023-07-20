<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
	if(request.getParameter("y")==null
	|| request.getParameter("m")==null
	|| request.getParameter("d")==null
	
	|| request.getParameter("y").equals("")
	|| request.getParameter("m").equals("")
	|| request.getParameter("d").equals(""))
	{
	response.sendRedirect("./scheduleList.jsp");
	return;
	}
	
	int y = Integer.parseInt(request.getParameter("y"));
	//자바 API 12월 ->11, 마리아 12 -> 12
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
		System.out.println(y + "<--scheduleListByDate param y");
		System.out.println(m + "<--scheduleListByDate param m");
		System.out.println(d + "<--scheduleListByDate param d");
	
	//m ,d가 숫자이기에 스트링이 먹지 않아 뒤에 공백을 붙여줌
	String strM = m + "";
	if(m<10) {
		strM = "0" + strM;
	}
	String strD = d + "";
	if(d<10) {
		strD = "0" + strD;
	}
	
	//일별 스케줄 리스트
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_color scheduleColor, schedule_memo scheduleMemo, schedule_pw schedulePw, createdate, updatedate from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y + "-" +strM + "-" + strD);
	
		System.out.println(stmt + "<--scheduleListByDate stmt");
		
	ResultSet rs = stmt.executeQuery();
	
	//ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> schedule = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");//전체 날짜가 아닌 값
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleColor = rs.getString("scheduleColor");
		s.scheduleMemo = rs.getString("scheduleMemo");//메모에서 5자만
		s.schedulePw = rs.getString("schedulePw");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		schedule.add(s);
	}
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
	<h1>스케줄 입력</h1>
<hr>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<td class="table-danger">일자</td>
				<td><input type = "date"name ="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly"></td>
			</tr>
			
			<tr>
				<td class="table-danger">시간</td>
				<td><input type = "time" name ="scheduleTime"></td>
			</tr>
			
			<tr>
				<td class="table-danger">분류색상</td>
				<td><input type = "color" name ="scheduleColor" value="#000000"></td>
			</tr>
	
			<tr>
				<td class="table-danger">내용</td>
				<td><textarea rows="3" cols="80" name="scheduleMemo"></textarea></td>
			</tr>
			
			<tr>
				<td class="table-danger">비밀번호</td>
				<td><input type = "password" name ="schedulePw"></td>
			</tr>
		</table>	
		<div style="text-align: right;">
		<button type ="submit" class="btn btn-outline-dark btn-sm">스케줄 입력</button>
		</div>
	</form>	
	<br>
	<h1><%=y%>년<%=m%>월<%=d%>일</h1>
	<hr>
	<table class="table table-bordered" style="text-align: center;">
		<tr>
			<th class="table-danger">시간</th>
			<th class="table-danger">내용</th>
			<th class="table-danger">작성일</th>
			<th class="table-danger">수정일</th>
			<th style="width:130px;" colspan="2">&nbsp;</th>
		</tr>
		<%
			for(Schedule s : schedule) {
		%>
				<tr>
					<td><%=s.scheduleTime.substring(0,5)%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate%></td>
					<td><%=s.updatedate%></td>
					<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-outline-dark btn-sm">수정</a></td>
					<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-outline-dark btn-sm">삭제</a></td>
				</tr>
		<%
				
			}
		%>
	</table>
</div>
</body>
</html>