<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	//년 or 월이 요청값에 넘어오지 않으면 오늘 년/월값으로
	if(request.getParameter("targetYear") == null
			||request.getParameter("targetMonth") == null) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);// 0~11이라고해서 여기서 +1을 하면 안됨(출력시에 +1 )
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
		System.out.println(targetYear + "<-- scheduleList param targetYear");
		System.out.println(targetMonth + "<-- scheduleList param targetMonth");
	
	//오늘날짜 - today = 년월일
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
		System.out.println(todayDate + "<-- scheduleList param todayDate");

	//targetMonth 1일의 요일
	Calendar firstDay = Calendar.getInstance(); // 2023년 4월 24일
	firstDay.set(Calendar.YEAR, targetYear); // 2023년
	firstDay.set(Calendar.MONTH, targetMonth); // 4월
	firstDay.set(Calendar.DATE, 1); // 2023년 4월 1일

	//12가 들어가면 API가 자동으로 이후 년 1월로 변경, -1을 입력시 이전 년 12월로 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	int firstYoil =  firstDay.get(Calendar.DAY_OF_WEEK); // 2023.4.1 몇번째 요일인지, 일요일1, 토요일7
		System.out.println(firstYoil + "<-- scheduleList param firstYoil");
	
	//1일 앞에 빈 공백수
	int startBlank = firstYoil - 1;
		System.out.println(startBlank + "<-- scheduleList param startBlank");

	
	//targetMonth 마지막일
	//달이 가지고 있는 가장 큰 숫자
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
		System.out.println(lastDate + "<-- scheduleList param lastDate");	

	//전체 TD 나누기 7  나머지값은 0
	//lastDate날짜 뒤 공백칸의 수
	int endBlack = 0;
	if((startBlank + lastDate) % 7 != 0) {
		endBlack = 7 - (startBlank + lastDate)%7;
	}
		System.out.println(endBlack + "<-- scheduleList param endBlack");

	//전체 td의 개수
	int totalTD = startBlank + lastDate + endBlack;
		System.out.println(totalTD + "<-- scheduleList param totalTD");
		
	// 출력하는 전월 년/월/마지막 날짜 출력 
	
	// 전월 년/월/마지막 날짜 추출
	Calendar preDate = Calendar.getInstance();
	preDate.set(Calendar.YEAR, targetYear);
	preDate.set(Calendar.MONTH, targetMonth -1); // 전월 
	// 전월에 마지막 날
	int preEndDateNum = preDate.getActualMaximum(Calendar.DATE);
	
	System.out.println(preEndDateNum + "<-- preEndDateNum");
	
	//db date를 가져오는 알고리즘
	// 1) mariadb 프로그램이 사용가능하도록 장치드라이버를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("드라이버 로딩 성공");
	
	// 2) mariadb에 로그인 후 접속정보 반환받아야 한다
	Connection conn = null;	
	conn = DriverManager.getConnection
			("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234"); // pw
		System.out.println("접속성공"+conn);
	
	/*
		select schedule_no scheduleNo, 
		substr(schedule_memo, 1, 5) scheduleMemo,
		schedule_color schedleColor,
		month(schedule_date) scheduleDate,
		from schedule
		where year(schedule_date) = ? and month(schedule_date) = ?
		order by month(schedule_date) asc;
	*/
			
	// 3) 쿼리 실행	
	//문자열을 쿼리로 바꿔주는 명령어
	PreparedStatement stmt = conn.prepareStatement(
			"select schedule_no scheduleNo, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor, day(schedule_date) scheduleDate from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc");
	
	stmt.setInt(1,targetYear);
	stmt.setInt(2,targetMonth + 1);
	System.out.println(stmt + "<--stmt");
	//출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	
	//ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");//전체 날짜가 아닌 값
		s.scheduleMemo = rs.getString("scheduleMemo");//메모에서 5자만
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
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
	<!-- 출력하고자하는 달력을 입력 -->
	
	<h1 style="text-align: center;">
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>" style="text-decoration: none; text-align: center; color: #FFA7A7">&#9665;</a>
		<%=targetYear%>년 <%=targetMonth+1%>월
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>" style="text-decoration: none; text-align: center; color: #FFA7A7">&#9655;</a>
	</h1>
	<hr>
	<table class="table table-bordered" style="table-layout: fixed;">
			<tr class ="table-danger">
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		<tr>
			<% 
				for(int i=0; i<totalTD; i+=1) {
					int num = i-startBlank+1;
					
					if(i !=0 && i%7==0) {
					
			%>
					</tr><tr>
			<% 
					}
					//오늘날짜이면
					String tdStyle = "";
					if(num>0 && num<=lastDate) {
						//오늘날짜이면
						if(today.get(Calendar.YEAR) == targetYear 
								&& today.get(Calendar.MONTH) == targetMonth
								&& today.get(Calendar.DATE) == num) {
							tdStyle = "border: solid 2px #FFD8D8; background-color:rgba(255, 216, 216, 0.2); font-weight:bold;";
						}
			%>
								<td style="<%=tdStyle%>">
									<div><!-- 날짜 숫자 -->
										<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>" class="text-dark" style="font-size: 20px"><%=num%></a>
									</div>
									<div><!-- 일정 memo(5글자만) -->
										<%
											for(Schedule s : scheduleList) {
												if(num == Integer.parseInt(s.scheduleDate)) {
										%>
													<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
										<%	
														
												}
											}
										%>
									</div>
								</td>
			<%
					} else {
			%>
					<td>&nbsp;</td>
			<%
					}
				}	
			%>
		</tr>
	</table>
</div>
</body>
</html>