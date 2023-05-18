<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//noticeNum이 null일 경우 홈으로
	if(request.getParameter("noticeNum") == null) {
		//response - 톰캣꺼
		response.sendRedirect("./noticeList.jsp");
		return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 

	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));
	
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "select notice_num noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_num =?";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	// ?때문에 미완성 된 스테이트먼트 생성
			//몇번째 물음표, 뭐로 바꿀거다 - 물음표가 많아지면 앞에서부터 1, 2 ~
	stmt.setInt(1, noticeNum);
	System.out.println(stmt + "<--stmt");
	
	ResultSet rs = stmt.executeQuery();
	
	// 한개일때 -int totalcnt;, 
	// 한 행에 여러 열 - Notice noitce = null; notice.noticeNo = rs...(모델데이터)
	// 행,열이 여러개면 - ArrayList<Notice> list - 배열을 대신하며 원하는 순서로 변경 가능 
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);
	}
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
		<a href="./noticeList.jsp" class="btn btn-outline-dark">공지 리스트<sup>&#x2B50</sup></a>&nbsp;
		<a href="./home.jsp" class="btn btn-outline-dark">&#x1F3E0</a>&nbsp;&nbsp;
		<a href="./scheduleList.jsp" class="btn btn-outline-dark">일정 리스트 <sup>&#x1F338</sup></a>
	</div>
	<br>
	<h1>공지 상세</h1>
	<hr>
	<%
		for(Notice n : noticeList) {
	%>
		<table class="table table-bordered">
				<tr>
					<td class="table-info"  style="width: 10%">No.</td>
					<td><%=n.noticeNo%></td>
				</tr>
				<tr>
					<td class="table-info">제&nbsp;&nbsp;&nbsp;목</td>
					<td><%=n.noticeTitle%></td>
				</tr>
				<tr>
					<td class="table-info">내&nbsp;&nbsp;&nbsp;용</td>
					<td><%=n.noticeContent%></td>
				</tr>
				<tr>
					<td class="table-info">작성자</td>
					<td><%=n.noticeWriter%></td>
				</tr>
				<tr>
					<td class="table-info">작성일</td>
					<td><%=n.createdate%></td>
				</tr>
				<tr>
					<td class="table-info">수정일</td>
					<td><%=n.updatedate%></td>
				</tr>	
			</table>
	<div>
		<a href="./updateNoticeForm.jsp?noticeNum=<%=n.noticeNo%>" class="btn btn-outline-dark btn-sm">수정</a>
		<a href="./deleteNoticeForm.jsp?noticeNum=<%=n.noticeNo%>" class="btn btn-outline-dark btn-sm">삭제</a>
	</div>
	<%
		}
	%>
</div>
</body>
</html>