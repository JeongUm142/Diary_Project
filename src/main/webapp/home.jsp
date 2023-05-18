<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
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
<div class="container-fluid">
<br>
	<div style="text-align: center"><!-- 메인메뉴 --> 
		<a href="./noticeList.jsp" class="btn btn-outline-dark">공지 리스트<sup>&#x2B50</sup></a>&nbsp;
		<a href="./home.jsp" class="btn btn-outline-dark">&#x1F3E0</a>&nbsp;&nbsp;
		<a href="./scheduleList.jsp" class="btn btn-outline-dark">일정 리스트 <sup>&#x1F338</sup></a>
	</div>
	<% 
	//날짜순 최근 공지 5개
	//select //보고싶은거 notice_tilte, createdate //어디로부터 from notice
	//어디서부터 order by createdate desc
	//어디까지 limit 0, 5(0번부터 5개)
	
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");

	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
			("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	//실행할 수 있는 쿼리로 변경 
	String sql1="select notice_num noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0,5";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);

	System.out.println(stmt1 + "<--stmt1");
	
	ResultSet rs = stmt1.executeQuery();
	//arrayList에 rs 데이터 이동(why? rs의 데이터가 복잡해서)
	ArrayList<Notice> notice = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		notice.add(n);
	}
	
	// 오늘 일정
	/*
      SELECT schedule_no, schedule_date, schedule_time, substr(schedule_memo,1,10) memo
      FROM SCHEDULE
      WHERE schedule_date = CURDATE()
      ORDER BY schedule_time ASC;
	*/
	
	String sql2 = "select schedule_no scheduleNo , schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) scheduleMemo from schedule where schedule_date= CURDATE() order By schedule_time asc";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2 + "<--stmt2");
	
	ResultSet rs2 = stmt2.executeQuery();
	
	ArrayList<Schedule> schedule = new ArrayList<Schedule>();
	while(rs2.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs2.getInt("scheduleNo");
		s.scheduleDate = rs2.getString("scheduleDate");//전체 날짜가 아닌 값
		s.scheduleTime = rs2.getString("scheduleTime");
		s.scheduleMemo = rs2.getString("scheduleMemo");//메모에서 5자만
		schedule.add(s);
	}
	%>
	<Br>
	<h1 >공지사항</h1>
	<hr>
	<table class="table table-bordered">
		<tr>
			<th class="table-info">제목</th>
			<th class="table-info">작성일</th>
		</tr>
		<%	//커스가 움직이는 곳이 true인 경우 계속 내려가면서 읽음
			for(Notice n : notice) {
		%>
			<tr>
				<td>
					<a href="./noticeOne.jsp?noticeNum=<%=n.noticeNo%>">
						<%=n.noticeTitle%>
					</a>
				</td>
				<td><%=n.createdate.substring(0,10)%></td>
			</tr>
		<%	
			}
		%>
	</table>
	<br>
	
	<h1>오늘 일정</h1>
	<hr>
	<table class="table table-bordered">
		<tr>
			<th class="table-danger">시간</th>
			<th class="table-danger">내용</th>
		</tr>
		<%
			for(Schedule s : schedule) {
		%>
			<tr>
				<td><%=s.scheduleTime%></td>
				<td><%=s.scheduleMemo%></td>
			</tr>
		<%	
			}
		%>
	</table>
</div>
</body>
</html>