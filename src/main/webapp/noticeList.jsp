<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//요청 분석
	//현재페이지
	int currentPage = 1;
		//currentPage가 null이 아닐경우 아래 실행(else문을 만들지 않기위해)
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "<--curr");
	
	//페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	//시작 행번호
	int startRow = (currentPage -1) * rowPerPage; // 1페이지일때만 
	
		/*
		currentPage		startRow(rowPerPage 10일때)
		1				0 <-- (currentPage -1) * rowPerPage
		2				10
		3				20
		4				30
		*/	
	
	// select 쿼리를 maria db에 전송 후 결과셋을 받아서 출력하는 페이지 
	// select notice_num, notice_title from notice order by notice_no desc
	
	// 1) mariadb 프로그램이 사용가능하도록 장치드라이버를 로딩
		//풀네임으로 작성할 것
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환받아야 한다
	Connection conn = null;	
	conn = DriverManager.getConnection
			("jdbc:mariadb://127.0.0.1:3306/diary",
				"root",//id
				"java1234"); // pw
	System.out.println("접속성공"+conn);
				
	// 3) 쿼리 실행
	// 쿼리가 ?로 바뀔 수 있는건 값 뿐 
	// limit ?, ?
	
	//문자열을 쿼리로 바꿔주는 명령어
	PreparedStatement stmt = conn.prepareStatement("select notice_num noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?,?");
	//?값 지정하는 메소드 - PreparedStatement
	//10개씩 매페이지 나오기 위한 설정
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowPerPage);
	//출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	//자료구조 ResultSet타입을 일반적인 타입(자바배열 또는 기본 api 자료구조타입 - List, Set, Map) 으로 변경 
	//ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	//마지막 페이지
	//select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	System.out.println("노티스 총 숫자 stmt2 실행 성공 ="+ stmt2);

	int totalRow = 0;
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
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
<div class="container-fluid">
<br>
	<div style="text-align: center"><!-- 메인메뉴 --> 
		<a href="./noticeList.jsp" class="btn btn-outline-dark">공지 리스트<sup>&#x2B50</sup></a>&nbsp;
		<a href="./home.jsp" class="btn btn-outline-dark">&#x1F3E0</a>&nbsp;&nbsp;
		<a href="./scheduleList.jsp" class="btn btn-outline-dark">일정 리스트 <sup>&#x1F338</sup></a>
	</div>
	<br>
	<h1>공지사항</h1>
	<hr>
	
	<table class="table table-bordered">
		<tr>
			<th class="table-info" style="width: 70%">제목</th>
			<th class="table-info">작성일</th>
		</tr>
		<%
			for(Notice n : noticeList) {
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
	<div style="text-align: right">
		<a href="./insertNoticeForm.jsp" class="btn btn-outline-dark">공지 입력</a>
	</div>
	
	<div style="text-align: center;">
		<%
			if(currentPage > 1) {
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>"  class="btn btn-info">이전</a>
		<%
			}
			
		%>	
			&nbsp;<span style="text-decoration: underline; font-size: 18px"><%=currentPage%></span>&nbsp;
		<%
			if (currentPage < lastPage)	{
		%>
			<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>"  class="btn btn-info">다음</a>
		<%
			}
		%>
	</div>
</div>
</body>
</html>