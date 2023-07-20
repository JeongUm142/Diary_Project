<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	//유효성 검사 -> 분기 -> return
	if(request.getParameter("noticeNum") == null) {
		//response - 돌아가
		response.sendRedirect("./noticeList.jsp");
		return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
		} 
	
	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));

	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) mariadb에 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection
		("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	//쿼리
	String sql = "select notice_num noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, notice_pw noticePw, createdate, updatedate from notice where notice_num =?";
	
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setInt(1, noticeNum);
		//디버깅
		System.out.println(stmt + "<--updateForm stmt");
	
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Notice> notice = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticePw = rs.getString("noticePw");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		notice.add(n);
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
<div class="container">
<br>
	<div style="text-align: center"><!-- 메인메뉴 --> 
		<a href="./noticeList.jsp" class="btn btn-outline-dark">공지 리스트<sup>&#x2B50</sup></a>&nbsp;
		<a href="./home.jsp" class="btn btn-outline-dark">&#x1F3E0</a>&nbsp;&nbsp;
		<a href="./scheduleList.jsp" class="btn btn-outline-dark">일정 리스트 <sup>&#x1F338</sup></a>
	</div>
<br>
	<h1>공지 수정</h1>
<hr>
	<form action="./updateNoticeAction.jsp" method="post">
	<%
	for(Notice n : notice) {
	%>
		<table class="table table-bordered">
			<tr>
				<td class="table-info"  style="width: 10%">공지번호</td>
				<td>
					<input type="number" name="noticeNum" value="<%=n.noticeNo%>" readonly="readonly">
				</td>
			</tr>
			
			<tr>
				<td class="table-info">비밀번호</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
			
			<tr>
				<td class="table-info">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
				<td>
					<input type="text" name="noticeTitle" value="<%=n.noticeTitle%>">
				</td>
			</tr>
			
			<tr>
				<td class="table-info">내&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용</td>
				<td>
					<textarea rows="7" cols="80" name="noticeContent"><%=n.noticeContent%></textarea>
				</td>
			</tr>
			
			<tr>
				<td class="table-info">작&nbsp;&nbsp;성&nbsp;&nbsp;자</td>
				<td>
					<%=n.noticeWriter%>
				</td>
			</tr>
			
			<tr>
				<td class="table-info">작&nbsp;&nbsp;성&nbsp;&nbsp;일</td>
				<td>
					<%=n.createdate%>
				</td>
			</tr>
			
			<tr>
				<td class="table-info">수&nbsp;&nbsp;정&nbsp;&nbsp;일</td>
				<td>
					<%=n.updatedate%>
				</td>
			</tr>
		</table>
	
		<div>
			<button type="submit" class="btn btn-outline-dark btn-sm">수정</button>
			<a href="./noticeOne.jsp?noticeNum=<%=n.noticeNo%>" class="btn btn-outline-dark btn-sm">취소 </a>
		</div>
	</form>
	<%
	}
	%>
</div>
</body>
</html>