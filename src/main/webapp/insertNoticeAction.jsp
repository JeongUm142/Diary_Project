<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement"%>
<%
	//post방식 인코딩 처리
	request.setCharacterEncoding("utf8");

	// validation(요청 피라미터값 유효성 검사)
	// 하나라도 공백이거나 null인 경우
		
	if(request.getParameter("noticeTitle")==null
		|| request.getParameter("noticeContent")==null
		|| request.getParameter("noticeWriter")==null
		|| request.getParameter("noticePw")==null
		|| request.getParameter("noticeTitle").equals("")
		|| request.getParameter("noticeContent").equals("")
		|| request.getParameter("noticeWriter").equals("")
		|| request.getParameter("noticePw").equals(""))
	{
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	//변수설정 
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	
	//1) mariadb 프로그램이 사용가능하도록 장치드라이버를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 2) 접속정보 반환
	Connection conn = null;	
	conn = DriverManager.getConnection
			("jdbc:mariadb://127.0.0.1:3306/diary",
				"root",//id
				"java1234"); // pw
				
	conn.setAutoCommit(true); //이게 있으면 아래 conn.commit 생략가능
	
	System.out.println("접속성공"+conn);
				
	/* 
	insert into notice(notice_title, notice_content, notice_writer, notice_pw, creatdate, updatedate
	) values(?,?,?,?,now,now)
	*/
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 4개(1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	
	int row = stmt.executeUpdate(); // 디버깅 1(ex:2)이면 1행(ex:2행)입력성공, 0이면 입력된 행이 없다
	
	//row값을 이용한 디버
	
	//conn.commit(); // 메모리에만 데이터 입력을 했기에 최종 반영을 위함
	
	// 값들을 DB 테이블 입력
	
	
	//redirection
	response.sendRedirect("./noticeList.jsp");
%>