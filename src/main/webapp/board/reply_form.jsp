<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="net.java_school.util.*"%>
<%@ page import="net.java_school.db.dbpool.*"%>
<jsp:useBean id="dbmgr" scope="application"
	class="net.java_school.db.dbpool.OracleConnectionManager" />
<!DOCTYPE html>
<%!static final String LINE_SEPARATOR = System.getProperty("line.separator");%>
<%
	request.setCharacterEncoding("UTF-8");
	Log log = new Log();

	int family = 0;
	int indent = 0;
	int depth = 0;

	String title = null;
	String content = null;
	Date regdate = null;

	int no = Integer.parseInt(request.getParameter("no"));
	String curPage = request.getParameter("curPage");
	String keyword = request.getParameter("keyword");

	Connection con = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT articleno, title, content, regdate "
			+ "FROM hierarchy_article WHERE articleno = ?";

	try {
		con = dbmgr.getConnection();
		stmt = con.prepareStatement(sql);
		stmt.setInt(1, no);
		rs = stmt.executeQuery();

		rs.next();
		no = rs.getInt("articleno");
		title = rs.getString("title");
		content = rs.getString("content");
		if (content == null) content = "";
		if (!content.equals("")) {
			content = content.replaceAll(LINE_SEPARATOR, LINE_SEPARATOR 	+ ">");
			content = LINE_SEPARATOR + LINE_SEPARATOR + ">" + content;
		}	
		regdate = rs.getDate("regdate");
	} catch (SQLException e) {
		log.debug("Error Source : board/modify_form.jsp : SQLException");
		log.debug("SQLState : " + e.getSQLState());
		log.debug("Message : " + e.getMessage());
		log.debug("Oracle Error Code : " + e.getErrorCode());
		log.debug("sql : " + sql);
	} finally {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
			}
		}
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
			}
		}
		if (con != null) {
			try {
				con.close();
			} catch (SQLException e) {
			}
		}
	}
%>
<html>
<head>
<meta charset="UTF-8" />
<title>Reply</title>
<script>
function goView(no, curPage, keyword) {
	 location.href="view.jsp?no=" + no + "&curPage=" + curPage + "&keyword=" + keyword;
}
</script>
</head>
<body>
<h1>Reply</h1>
<form action="../servlet/BoardReplier" method="post">
<input type="hidden" name="no" value="<%=no%>" /> 
<input type="hidden" name="family" value="<%=family%>" />
<input type="hidden" name="indent" value="<%=indent%>" />
<input type="hidden" name="depth" value="<%=depth%>" />
<input type="hidden" name="curPage" value="<%=curPage%>" />
<input type="hidden" name="keyword" value="<%=keyword%>" />
<div>Title: <input type="text" name="title" size="45" value="<%=title%>" /></div>
<div><textarea name="content" rows="10" cols="60"><%=content%></textarea></div>
<div>
<input type="submit" value="Submit" />
<input type="reset" value="Reset" />
<input type="button" value="Back to View Details" onclick="javascript:goView('<%=no%>','<%=curPage%>','<%=keyword%>')" />
</div>
</form>
</body>
</html>