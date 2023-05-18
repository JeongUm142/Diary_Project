<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	//request 인코딩 설정
	request.setCharacterEncoding("utf8");
	//요청값에 대한 유효성 검사
	if(request.getParameter("scheduleDate") == null
			|| request.getParameter("scheduleTime") == null
			|| request.getParameter("scheduleDate").equals("")
			|| request.getParameter("scheduleTime").equals("")) {
	//response - 돌아가
	response.sendRedirect("./scheduleList.jsp");
	return; //현재 진행중인 메소드를 종료 + 반환값을 남기고 싶을 때는 뒤에 값을 입력
	} 
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String scheduleColor = request.getParameter("scheduleColor");
	String schedulePw = request.getParameter("schedulePw");
		System.out.println(scheduleNo + "<--updatescheduleAction scheduleNo");
		System.out.println(scheduleDate + "<--updatescheduleAction scheduleDate");
		System.out.println(scheduleTime + "<--updatescheduleAction scheduleTime");
		System.out.println(scheduleMemo + "<--updatescheduleAction scheduleMemo");
		System.out.println(scheduleColor + "<--updatescheduleAction scheduleColor");
		System.out.println(schedulePw + "<--updatescheduleAction schedulePw");
	
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "UPDATE schedule SET schedule_time=?, schedule_memo=?, schedule_color=?, schedule_pw=?, updatedate=now() where schedule_no=? and schedule_pw=?";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, scheduleTime);
	stmt.setString(2, scheduleMemo);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, schedulePw);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	//디버깅
		System.out.println(stmt + "<--updateScheduleAction sql");
	
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	
	//반환값
	int row = stmt.executeUpdate();
		//디버깅
		System.out.println(row + "<--updateScheduleAction row");
		
	if(row == 0) {//비밀번호가 틀려서 삭제행이 0
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo);
	} else {
		response.sendRedirect("./scheduleList.jsp");
	}
		
		
%>