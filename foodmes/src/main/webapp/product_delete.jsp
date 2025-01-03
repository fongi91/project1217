<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.company1.DBManager" %>

<%
   //한글 처리
	request.setCharacterEncoding("UTF-8");
    String login_id = request.getParameter("login_id");
	
	// 파라미터 값 확인: <input class = input_in id="id" name="id" autofocus value .... 의 name에서 가져왔습니다.)
	String itemCd = request.getParameter("item_cd");
	System.out.println(itemCd);

	Connection conn = DBManager.getDBConnection();
	
	String sql = "DELETE FROM MEITEM WHERE ITEM_CD = ?";
	int rows = 0;
	try{
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, itemCd);
		
		rows = pstmt.executeUpdate();
		DBManager.dbClose(conn, null, null);
	} catch(Exception e){
		e.printStackTrace();
	}
%>
<script>
	if(<%= rows %> == 1){
		alert("<%= itemCd %> 이(가) 삭제되었습니다.");
	} else{
		alert("삭제 실패하였습니다.");
	}
	window.location.href = './product_manage.jsp?login_id=<%= login_id %>';
</script>

