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

%>    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>사조떡볶이</title>
<link rel="stylesheet" href="./css/main_style.css"> 
<style>      
</style> 
</head>
<body>
    <div class="sidebar">
        <h3><a href="./main.jsp">사조떡볶이 제조시스템</a></h3>
        <div class = "sidebar1">
        	<a href="./user_manage.jsp">사용자관리</a>
        	<a href="./product_manage.jsp">제품기준관리</a>
        	<a href="./material_manage.jsp">자재기준관리</a>
        	<a href="#contact">Version</a>
        </div>
    </div>
    <div class="content">
    	<div>
        	<h1>사용자관리</h1>
        	<div class = button>
        		<button id = "user_add_button">사용자생성</button>
        	</div> 	
        </div>
        
        <script>
        document.addEventListener("DOMContentLoaded", function() {   // 웹 페이지가 로딩되면 실행
            const button = document.getElementById("user_add_button");  // 버튼 요소 가져오기
            button.addEventListener("click", function () {  // 버튼을 클릭하면 실행
              	window.open("./user_add.jsp", "팝업창이름", "width=650, height=500, left=100, top=200");
              	// newRegister();   // 새로운 주제를 등록하는 함수 호출  
            	});
        });
        </script>
        
        
        
        <hr>
        
        
        
	    <div class="right-side">
<form action="user_manage2.jsp" method="POST">
    show
    <select name="numb" id="numb" onchange="this.form.submit()">
        <option value="10" <% if ("10".equals(request.getParameter("numb"))) out.print("selected"); %>>10</option>
        <option value="20" <% if ("20".equals(request.getParameter("numb"))) out.print("selected"); %>>20</option>
        <option value="30" <% if ("30".equals(request.getParameter("numb"))) out.print("selected"); %>>30</option>
    </select>
    entries
</form>
	      
	      <!-- ******************** 이부분 추가하시면 됩니다.(각 구역별 select 모두 출력되는 코드에서 수정하시는겁니다.)******************** 
	      form 태그 생성 후 action="./검색결과 출력 할 페이지" method="POST" 
	      input 태그 작성 간 name을 잘 써주세요. 출력페이지에서 받아와야됩니다. -->
	        <form id ="search-form" action="./user_search.jsp" method="POST">
	        	 <span class="search">
					<input class="searchbox" type="search" id="search" name="search1" placeholder="이름을 입력하세요">
					<button class="search-button"></button>
				</span>
            </form>	
	        
	     
	    </div>
	</div>
	   


	<div class="table_contain">
    	<table>
    <tr>
        <th>NO</th>
        <th>ID</th>
        <th>이름</th>
        <th>사원번호</th>
        <th>부서</th>
        <th>직급</th>
        <th>mobile</th>
        <th>등록자</th>
        <th>등록일시</th>
    </tr>
    
    <%
        // 페이지 크기 설정 (기본값 25)
        String postCountStr = request.getParameter("numb");
        int postCount = (postCountStr != null) ? Integer.parseInt(postCountStr) : 10;  // 기본값은 25
        
        // DB 연결
        Connection conn = DBManager.getDBConnection();
        
        // SQL 쿼리 (ROWNUM을 사용해 결과를 제한)
        String sql = "SELECT rownum AS ROWNO, LOGIN_ID, LOGIN_NAME, SABUN_ID, DEPART_NM, JIK_NM, MOBILE_NO, "
                     + " WRITE_ID, to_char(write_dt, 'YYYY/MM/DD HH24:MI:SS') AS WRITE_DT "
                     + " FROM MEUSER WHERE rownum <= ?";
        
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postCount);  // 선택한 개수만큼 결과 제한
            ResultSet rs = pstmt.executeQuery();
            
            // 데이터 출력
            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("ROWNO") %></td>
        <td><%= rs.getString("LOGIN_ID") %></td>
        <td><%= rs.getString("LOGIN_NAME") %></td>
        <td><%= rs.getString("SABUN_ID") %></td>
        <td><%= rs.getString("DEPART_NM") %></td>
        <td><%= rs.getString("JIK_NM") %></td>
        <td><%= rs.getString("MOBILE_NO") %></td>
        <td><%= rs.getString("WRITE_ID") %></td>
        <td><%= rs.getString("WRITE_DT") %></td>
    </tr>
    <%
            }
            // 자원 정리
            DBManager.dbClose(conn, pstmt, rs);
        } catch (SQLException se) {
            se.printStackTrace();
            System.err.println("테이블 조회 에러");
        }
    %>
</table>
    </div>

</body>
</html>