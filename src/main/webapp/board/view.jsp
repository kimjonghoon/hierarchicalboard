<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="net.java_school.util.*"%>
<%@ page import="net.java_school.db.dbpool.*"%>
<%
String curPage = request.getParameter("curPage");
String keyword = request.getParameter("keyword");
if (keyword == null) keyword = "";
%>
<jsp:useBean id="dbmgr" scope="application" class="net.java_school.db.dbpool.OracleConnectionManager" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Detailed</title>
<script type="text/javascript">
function goList(curPage, keyword) {
	location.href="list.jsp?curPage=" + curPage + "&keyword=" + keyword;
}
function goReply(no, curPage, keyword) {
	location.href="reply_form.jsp?no=" + no + "&curPage=" + curPage + "&keyword=" + keyword;
}
function goModify(no, curPage, keyword) {
	location.href="modify_form.jsp?no=" + no + "&curPage=" + curPage + "&keyword=" + keyword;
}
function goDelete(no, curPage, keyword) {
	var check = confirm('Are you sure you want to delete this item?');
	if (check) {
		location.href="../servlet/BoardDeleter?no=" + no + "&curPage=" + curPage + "&keyword=" + keyword;
	}
}
</script>
</head>
<body>
<h1>View Details</h1>
<%
int no = Integer.parseInt(request.getParameter("no"));
Log log = new Log();
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;
String sql = "SELECT articleno, title, content, regdate FROM hierarchy_article WHERE articleno = ?";
try {
	con = dbmgr.getConnection();
	stmt = con.prepareStatement(sql);
	stmt.setInt(1, no);
	rs = stmt.executeQuery();

	while (rs.next()) {
		String title = rs.getString("title");
		String content = rs.getString("content");
		Date regdate = rs.getDate("regdate");
		if (content == null) content = "";
%>

<h2>Title: <%=title%>, Creation: <%=regdate.toString()%></h2>

<p>
<%=content = content.replaceAll(System.getProperty("line.separator"), "<br />")%>
</p>
<%
	}
} catch (SQLException e) {
	log.debug("Error Source : board/view.jsp : SQLException");
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
%>
<div>
	<input type="button" value="List" onclick="javascript:goList('<%=curPage%>','<%=keyword%>')" />
	<input type="button" value="Reply" onclick="javascript:goReply('<%=no%>','<%=curPage%>','<%=keyword%>')" />
	<input type="button" value="Modify" onclick="javascript:goModify('<%=no%>','<%=curPage%>','<%=keyword%>')" />
	<input type="button" value="Delete" onclick="javascript:goDelete('<%=no%>','<%=curPage%>','<%=keyword%>')" />
</div>
</body>
</html>