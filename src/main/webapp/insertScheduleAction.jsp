<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");	
	
	if(request.getParameter("scheduleDate")==null
	|| request.getParameter("scheduleTime")==null
	|| request.getParameter("scheduleColor")==null
	|| request.getParameter("scheduleMemo")==null
	|| request.getParameter("schedulePw")==null

	
	|| request.getParameter("scheduleDate").equals("")
	|| request.getParameter("scheduleTime").equals("")
	|| request.getParameter("scheduleColor").equals("")
	|| request.getParameter("scheduleMemo").equals("")
	|| request.getParameter("schedulePw").equals("")
	)
	{
	response.sendRedirect("./scheduleListByDate.jsp");
	return;
	}

	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
		System.out.println(scheduleDate + " <--insertScheduleAction scheduleDate");
		System.out.println(scheduleTime + " <--insertScheduleAction scheduleTime");
		System.out.println(scheduleColor + " <--insertScheduleAction scheduleColor");
		System.out.println(scheduleMemo + " <--insertScheduleAction scheduleMemo");
		System.out.println(schedulePw + " <--insertScheduleAction schedulePw");

		
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	//쿼리입력
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_color, schedule_memo, schedule_pw, createdate, updatedate) values(?,?,?,?,?,now(),now())";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setString(5, schedulePw);
		//디버깅
		System.out.println(stmt + "<--insertScheduleAction stmt");
	
	int row = stmt.executeUpdate();
	
		//디버깅
		System.out.println(row+"<--1이면 1행입력성공, 0이면 입력된 행이 없다");
	
	if(row==1) { //비밀번호 오류
		System.out.println("insertScheduleAction 정상 입력");	
	} else{
		System.out.println("insertScheduleAction 오류");	
	}
	
	//자르기
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7)) - 1 ;
	String d = scheduleDate.substring(8);
	
	System.out.println(y + " <--insertScheduleAction y ");
	System.out.println(m + " <--insertScheduleAction m ");
	System.out.println(d + " <--insertScheduleAction d ");

	response.sendRedirect("./scheduleListByDate.jsp?y="+y +"&m="+m +"&d="+d);
%>
