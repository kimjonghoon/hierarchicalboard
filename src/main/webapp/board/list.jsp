<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="net.java_school.util.*" %>
<%@ page import="net.java_school.db.dbpool.*" %>
<jsp:useBean id="dbmgr" scope="application" class="net.java_school.db.dbpool.OracleConnectionManager" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>List</title>
</head>
<body style="font-size: 11px;">
<h1>List</h1>
<%
Log log = new Log();

request.setCharacterEncoding("UTF-8");
String keyword = request.getParameter("keyword");
if (keyword == null) keyword = "";

Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String sql = null;

//1. totalRecord
int totalRecord = 0;
try {
	con = dbmgr.getConnection();
	if (keyword.equals("")) {
		sql = "SELECT count(*) FROM hierarchy_article";
	} else {
		sql = "SELECT count(*) FROM hierarchy_article WHERE title LIKE '%" + keyword + "%' " + "OR content LIKE '%" + keyword + "%'";
	}
	stmt = con.prepareStatement(sql);
	rs = stmt.executeQuery();
	rs.next();
	totalRecord = rs.getInt(1);
} catch (SQLException e) {
	log.debug(e.getMessage());
} finally {
	if (rs != null) {
		try {
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	if (stmt != null) {
		try {
			stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	if (con != null) {
		dbmgr.freeConnection(con);
	}    
}
//2. totalPage
int numPerPage = 10; //max record per page
int totalPage = 0;
if (totalRecord != 0) {
	if (totalRecord % numPerPage == 0) {
		totalPage = totalRecord / numPerPage;
	} else {
		totalPage = totalRecord / numPerPage + 1;
	}
}
//3. startRow and endRow
int curPage = request.getParameter("curPage") == null ? 1 : Integer.parseInt(request.getParameter("curPage"));
int start = (curPage - 1) * numPerPage + 1;
int end = start + numPerPage - 1;
//4. list
try {
	con = dbmgr.getConnection();
	sql = "SELECT articleno,indent,parent,title,regdate " +
			"FROM (SELECT ROWNUM R, A.* FROM (" +
			"SELECT articleno,level as indent,parent,title,regdate FROM hierarchy_article ";
	if (!keyword.equals("")) {
		sql += " WHERE title LIKE '%" + keyword + "%' OR content LIKE '%" + keyword + "%' ";
	}	
	sql += "START WITH parent = 0 " +
		    "CONNECT BY PRIOR articleno = parent " + 
		    "ORDER SIBLINGS BY articleno DESC) A) " + 
			 "WHERE R BETWEEN ? AND ?";
		
	stmt = con.prepareStatement(sql);
	stmt.setInt(1, start);
	stmt.setInt(2, end);
	rs = stmt.executeQuery();

	while (rs.next()) {
		int no = rs.getInt("articleno");
		String title = rs.getString("title");
		Date regdate = rs.getDate("regdate");
		int indent = rs.getInt("indent");
		for (int i = 0; i < indent; i++) {
			out.println("&nbsp;&nbsp;");
		}
		if (indent != 1) {
			out.println("┗");
		}
%>
<%=no %> <a href="view.jsp?no=<%=no %>&curPage=<%=curPage %>&keyword=<%=keyword %>"><%=title %></a> <%= regdate.toString() %><br />
<hr />
<%
  }
} catch(SQLException e) {
	log.debug("Error Source : board/list.jsp : SQLException");
	log.debug("SQLState : " + e.getSQLState());
	log.debug("Message : " + e.getMessage());
	log.debug("Oracle Error Code : " + e.getErrorCode());
	log.debug("sql : " + sql);
} finally {
	if (rs != null) {
		try {
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }
	if (stmt != null) {
		try {
			stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	if (con != null) {
		dbmgr.freeConnection(con);
	}
	log.close();
}

//4. current block
int block = 1;
int pagePerBlock = 5;
if (curPage % pagePerBlock == 0) {
	block = curPage / pagePerBlock;
} else {
	block = curPage / pagePerBlock + 1;
}
// firstPage 
int firstPage = (block - 1) * pagePerBlock + 1;
// totalBlock 
int totalBlock = 0;
if (totalPage > 0) { 
	if (totalPage % pagePerBlock == 0) {
		totalBlock = totalPage / pagePerBlock;
	} else {
		totalBlock = totalPage / pagePerBlock + 1;
	}
}
//lastPage
int lastPage =  block * pagePerBlock;
if (block >= totalBlock) {
	lastPage = totalPage;
}
//if block > 1, make [Prev]
int prevPage = 0;
if(block > 1) {
	prevPage = firstPage - 1;
%>
	<a href="list.jsp?curPage=<%=prevPage %>&keyword=<%=keyword %>">[Prev]</a>
<%
}
for (int i = firstPage; i <= lastPage; i++) {
%>
	<a href="list.jsp?curPage=<%=i%>&keyword=<%=keyword %>">[<%=i%>]</a>
<%
}
// if block < totalBlock, make [Next]  
if(block < totalBlock) {
	int nextPage = lastPage + 1;
%>
	<a href="list.jsp?curPage=<%=nextPage %>&keyword=<%=keyword %>">[Next]</a>
<%
}
%>
<p>
<a href="write_form.jsp?curPage=<%=curPage %>&keyword=<%=keyword %>">New</a>
</p>
<form action="list.jsp" method="post">
	<input type="text" size="10" maxlength="30" name="keyword" />
	<input type="submit" value="Search" />
</form>
</body>
</html>