<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.PreparedStatement" %>
<%
//요청값에 대한 유효성 검사
	if(request.getParameter("noticeNum") == null
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeNum").equals("")
		|| request.getParameter("noticePw").equals("")) {
	//response - 돌아가
	response.sendRedirect("./noticeList.jsp");
	return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 
	
	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));
	String noticePw = request.getParameter("noticePw");

	// set int = 숫자, set string = 문자
	// delete from notice where notice_num=? and notice_pw='?'
	
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "delete from notice where notice_num=? and notice_pw=?";
	
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setInt(1, noticeNum);
	stmt.setString(2, noticePw);
	//디버깅
	System.out.println(stmt + "<--delete noticeAction sql");
	
	//반환값
	int row = stmt.executeUpdate();
	
		//디버깅
		System.out.println(row + "<--deleteNoticeAction row");
		
	if(row == 0) {//비밀번호가 틀려서 삭제행이 0
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNum=" + noticeNum);
	} else {
		response.sendRedirect("./noticeList.jsp");
	}
%>