<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<% //1. request 인코딩 설정
	request.setCharacterEncoding("utf8");

	//2. form에서 넘긴 수 만큼의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeNum")
			+"<--updateNoticeAction param noticeNum");
	System.out.println(request.getParameter("noticeTitle")
			+"<--updateNoticeAction param noticeTitle");
	System.out.println(request.getParameter("noticeContent")
			+"<--updateNoticeAction param noticeContent");
	System.out.println(request.getParameter("noticePw")
			+"<--updateNoticeAction param noticePw");
	
	//3. 2번 유효성검정 -> 잘못된 결과 -> 묻기 -> 리다이렉션(액션을 요청한 웹 브라우저한테 다른 곳으로 가라고-updateNoticeForm.jsp?noticeNum=&msg=로 다시)
	//ex.num이 null이라면? form으로 이동 -> 만일 form에서도 리다이렉션이 존재할 경우 -> list로
	//response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg=error");
	
	//null다음에 equals를 해야함 - or 은 앞에서 참일경우에는 뒤에를 실행하지 않음
	/*if(request.getParameter("noticeNum") == null
		||request.getParameter("noticeNum").equals("")) {
			return;}*/ 
	if(request.getParameter("noticeNum")==null) {
        response.sendRedirect("./noticeList.jsp");
        return;
    }

    String msg = null;
    if(request.getParameter("noticeTitle")==null 
			|| request.getParameter("noticeTitle").equals("")) {
			msg = "noticeTitle is required";
	} else if(request.getParameter("noticeContent")==null 
			|| request.getParameter("noticeContent").equals("")) {
			msg = "noticeContent is required";
	} else if(request.getParameter("noticePw")==null 
			|| request.getParameter("noticePw").equals("")) {
			msg = "noticePw is required";
	}
	if(msg != null) { // noticeNo가 null or 위의 ifelse문에 하나라도 해당된다
		response.sendRedirect("./updateNoticeForm.jsp?noticeNum="
								+request.getParameter("noticeNum")
								+"&msg="+msg);
        return;
	}		

	//4. 요청값들을 변수에 할당(형변환)
	int noticeNum = Integer.parseInt(request.getParameter("noticeNum"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	
	System.out.println(request.getParameter("noticeNum")
			+"<--updateNoticeAction 변수 noticeNum");
	System.out.println(request.getParameter("noticeTitle")
			+"<--updateNoticeAction 변수 noticeTitle");
	System.out.println(request.getParameter("noticeContent")
			+"<--updateNoticeAction 변수 noticeContent");
	System.out.println(request.getParameter("noticePw")
			+"<--updateNoticeAction 변수 noticePw");
	
	//5. mariadb RDBMS에 update문을 전송한다
	
	//드라이브 로딩 - 접속
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 2) mariadb에 로그인 후 접속정보 반환
	java.sql.Connection conn = DriverManager.getConnection
	("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	//쿼리입력(update notice set 이름 = '123';)
	String sql = "UPDATE notice SET notice_title=?, notice_content=?, updatedate=now() where notice_num =? and notice_pw=?";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNum);
	stmt.setString(4, noticePw);
		//디버깅
		System.out.println(stmt + "<--updateAction stmt");
	
	//행의 결과물
	int row = stmt.executeUpdate(); // 적용된 행의 수
	
	//6. 5번 결과에 페이지(View)를 분기한다
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNum="
				+request.getParameter("noticeNum")
				+"&msg=incorrect noticePw");
	} else if(row == 1) {
		response.sendRedirect("./noticeOne.jsp?noticeNum="+noticeNum);
	} else {
		// update문 실행을 취소(rollback)해야 한다
		System.out.println("error row값 : "+row);
	}	
%>