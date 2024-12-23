<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException, java.sql.ResultSet" %>
<%@ page import="com.company1.DBManager" %>

<%
    // 한글 처리
    request.setCharacterEncoding("UTF-8");

    // 페이지 크기와 현재 페이지 번호 받기
    String postCountStr = request.getParameter("numb");
    int postCount = (postCountStr != null) ? Integer.parseInt(postCountStr) : 10; // 기본값 10
    String pageStr = request.getParameter("page");
    int currentPage = (pageStr != null) ? Integer.parseInt(pageStr) : 1;

    // 검색어 받기 (GET 방식으로 전달된 검색어)
    String search = request.getParameter("search1");
    if (search == null) {
        search = "";  // 기본값 빈 문자열
    }

    // DB 연결
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int totalCount = 0;
    int totalPages = 0;

    try {
        conn = DBManager.getDBConnection();

        // 1. 총 데이터 개수 계산 쿼리 (검색어가 있으면 필터링)
        String countSql = "SELECT COUNT(*) FROM MEUSER WHERE LOGIN_NAME LIKE ?";
        pstmt = conn.prepareStatement(countSql);
        pstmt.setString(1, "%" + search + "%");
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalCount = rs.getInt(1);
        }

        // 2. 전체 페이지 수 계산
        totalPages = (int) Math.ceil((double) totalCount / postCount);

        // 3. 시작 인덱스와 끝 인덱스 계산
        int startIndex = (currentPage - 1) * postCount + 1;
        int endIndex = currentPage * postCount;

        // 4. 실제 데이터 가져오기 쿼리 (검색어에 맞춰서 필터링)
        String sql = "SELECT * FROM ("
	               + "SELECT rownum AS ROWNO, LOGIN_ID, LOGIN_NAME, SABUN_ID, DEPART_NM, JIK_NM, MOBILE_NO, "
	               + "WRITE_ID, to_char(write_dt, 'YYYY/MM/DD HH24:MI:SS') AS WRITE_DT "
	               + "FROM MEUSER "
                   + "WHERE LOGIN_NAME LIKE ?) "
                   + "WHERE ROWNO BETWEEN ? AND ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + search + "%");
        pstmt.setInt(2, startIndex);
        pstmt.setInt(3, endIndex);
        rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사조떡볶이</title>
    <link rel="stylesheet" href="./css/main_style.css">
    <style>
        .button {
            margin: 20px;
        }

        .button-container {
            position: fixed;
            top: 80px;
            right: 20px;
        }

        .pagination {
            margin-top: 20px;
            text-align: center;
        }

        .pagination a {
            margin: 0 5px;
            padding: 5px 10px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #000;
        }

        .pagination a.active {
            background-color: #575757;
            color: white;
        }
    </style>
</head>

<body>
    <div class="sidebar">
        <h3><a href="./main.jsp">사조떡볶이 제조시스템</a></h3>
        <div class="sidebar1">
            <a href="./user_manage.jsp">사용자관리</a>
            <a href="./product_manage.jsp">제품기준관리</a>
            <a href="./material_manage.jsp">자재기준관리</a> 
            <a href="#contact">Version</a>
        </div>
    </div>

    <div class="content">
        <h1>사용자관리</h1>

        <!-- 생성 버튼을 <hr> 위쪽으로 이동 -->
        <div class="button-container">
            <button id="user_add_button" class = "create-button">생성</button>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const button = document.getElementById("user_add_button");
                button.addEventListener("click", function () {
                    window.location.href = "./material_add.jsp"; // 자재 추가 페이지로 이동
                });
            });
        </script>

        <hr>

        <div class="right-side">
            <form action="material_manage.jsp" method="GET">
                show
                <select name="numb" id="numb" onchange="this.form.submit()">
                    <option value="10" <% if ("10".equals(request.getParameter("numb"))) out.print("selected"); %>>10</option>
                    <option value="20" <% if ("20".equals(request.getParameter("numb"))) out.print("selected"); %>>20</option>
                    <option value="30" <% if ("30".equals(request.getParameter("numb"))) out.print("selected"); %>>30</option>
                </select>
                entries
            </form>

            <form id="search-form" action="material_manage.jsp" method="GET">
                <span class="search">
                    <input class="searchbox" type="search" id="search" name="search1" placeholder="자재검색" value="<%= search %>">
                    <button class="search-button" type="submit"></button>
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
    			<th>부서번호</th>
    			<th>직급</th>
    			<th>mobile</th>
    			<th>등록자</th>
    			<th>등록일시</th>
            </tr>

            <%
                // 데이터 출력
                while (rs.next()) {
            %>
	    	<tr>
	    	    <td><%= rs.getInt("ROWNO") %></td>
	    		<td> <a href="user_change.jsp?login_id=<%= rs.getString("LOGIN_ID") %>"> <%= rs.getString("LOGIN_ID") %> </a> </td>	
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
            %>
        </table>
    </div>

    <!-- 페이지 내비게이션 -->
    <div class="pagination">
        <%
            for (int i = 1; i <= totalPages; i++) {
                String activeClass = (i == currentPage) ? "active" : "";
        %>
        <a href="?page=<%= i %>&numb=<%= postCount %>&search1=<%= search %>" class="<%= activeClass %>"><%= i %></a>
        <%
            }
        %>
    </div>
</body>
</html>

<%
    } catch (SQLException se) {
        se.printStackTrace();
    } finally {
        // 자원 정리 (finally 블록에서 반드시 닫아야 함)
        DBManager.dbClose(conn, pstmt, rs);
    }
%>
