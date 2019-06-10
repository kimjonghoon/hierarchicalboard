<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="net.java_school.util.*" %>
<%@ page import="net.java_school.db.dbpool.*" %>
<jsp:useBean id="dbmgr" scope="application" class="net.java_school.db.dbpool.OracleConnectionManager" />
<%
int no = Integer.parseInt(request.getParameter("no"));
String curPage = request.getParameter("curPage");
String keyword = request.getParameter("keyword");
if (keyword == null) keyword = "";

Log log = new Log();

Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String title = null;
String content = null;
String sql = "SELECT title, content FROM hierarchy_article WHERE articleno = ?";

try {
	con = dbmgr.getConnection();
	stmt = con.prepareStatement(sql);
	stmt.setInt(1, no);
	rs = stmt.executeQuery();
	
	if (rs.next()) {
		title = rs.getString("title");
		content = rs.getString("content");
		if (content == null) content = "";
	}
} catch (SQLException e) {
	log.debug("Error Source: board/modify_form.jsp : SQLException");
	log.debug("SQLState: " + e.getSQLState());
	log.debug("Message: " + e.getMessage());
	log.debug("Oracle Error Code: " + e.getErrorCode());
	log.debug("sql: " + sql);
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Modify Article</title>
<script>
function goView(no,curPage,keyword) {
	location.href="view.jsp?no=" + no + "&curPage=" + curPage + "&keyword=" + keyword;
} 
</script>
</head>
<body>
<h1>Modify Article</h1>
<form action="../servlet/BoardModifier" method="post">
<input type="hidden" name="no" value="<%=no %>">
<input type="hidden" name="curPage" value="<%=curPage %>">
<input type="hidden" name="keyword" value="<%=keyword %>">
<table>
<tr>
	<td>Title</td>
	<td><input type="text" name="title" size="50" value="<%=title %>" /></td>
</tr>
<tr>
	<td colspan="2">
		<textarea name="content" rows="10" cols="50"><%=content %></textarea>
	</td>
</tr>
<tr>
	<td colspan="2">
		<input type="submit" value="Submit">
		<input type="reset" value="Reset">
		<input type="button" value="View Details" onclick="javascript:goView('<%=no %>','<%=curPage %>','<%=keyword %>')" />
	</td>
</tr>
</table>
</form>
</body>
</html>