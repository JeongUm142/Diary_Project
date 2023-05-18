<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%
	// select 쿼리를 maria db에 전송 후 결과셋을 받아서 출력하는 페이지 
	
	// 1) mariadb 프로그램이 사용가능하도록 장치드라이버를 로딩
		//풀네임으로 작성할 것
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환받아야 한다
	Connection conn = null;	
	conn = DriverManager.getConnection
			("jdbc:mariadb://127.0.0.1:3306/homework",
				"root",//id
				"java1234"); // pw
	System.out.println("접속성공"+conn);
				
	// 3) 쿼리 실행
	String sql = "select student_num, student_name, student_age from student";
	//문자열을 쿼리로 바꿔주는 명령어
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//배열의 한 종류
	ResultSet rs = stmt.executeQuery();
	
	System.out.println("쿼리실행성공"+rs);
	
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
<div class ="container">
	<table class ="table table-bordered">
		<tr>
			<th>student_num</th>
			<th>student_name</th>
			<th>student_age</th>
		</tr>
		
		<%// while은 아래 조건이 참일때까지 무한반복
			while(rs.next()) {
				
		%>
			<tr>
				<td><%=rs.getInt("student_num")%></td>
				<td><%=rs.getString("student_name")%></td>
				<td><%=rs.getInt("student_age")%></td>
			</tr>
		<%
			}	
		%>
	</table>
</div>
</body>
</html>