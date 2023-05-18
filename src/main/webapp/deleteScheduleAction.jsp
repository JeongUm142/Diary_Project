<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%
	if(request.getParameter("scheduleNo") == null
		|| request.getParameter("schedulePw") == null
		|| request.getParameter("scheduleNo").equals("")
		|| request.getParameter("schedulePw").equals("")) {
	//response - 돌아가
	response.sendRedirect("./scheduleList.jsp");
	return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
		System.out.println(scheduleNo + "<--deletescheduleAction scheduleNo");
		System.out.println(schedulePw + "<--deletescheduleAction schedulePw");


	//1) 드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) 접속정보 반환	
	Connection conn = DriverManager.getConnection
			("jdbc:mariadb://127.0.0.1:3306/diary",
				"root",//id
				"java1234"); // pw	
	
	String sql ="delete from schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
		System.out.println(stmt + "<--deletescheduleAction stmt");
	
	int row = stmt.executeUpdate();
	
		//디버깅
		System.out.println(row + "<--deletescheduleAction row");
	
	if(row == 0) {//비밀번호가 틀려서 삭제행이 0
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo);
	} else {
		response.sendRedirect("./scheduleList.jsp");
	}

%>
