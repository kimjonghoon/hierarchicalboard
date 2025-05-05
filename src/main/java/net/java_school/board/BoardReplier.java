package net.java_school.board;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.sql.*;

import net.java_school.db.dbpool.*;
import net.java_school.util.*;

public class BoardReplier extends HttpServlet {

	private static final long serialVersionUID = -7566062019730529502L;

	OracleConnectionManager dbmgr = null;

	String sql = "INSERT INTO hierarchy_article " + 
			"(articleno, parent, title, content, regdate) " + 
			"VALUES (seq_hierarchy_article.nextval, ?, ?, ?, sysdate)";

	@Override
	public void init() throws ServletException {
		ServletContext sc = getServletContext();
		dbmgr = (OracleConnectionManager)sc.getAttribute("dbmgr");
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		Log log = new Log();

		int parent = Integer.parseInt(req.getParameter("no"));

		String title = req.getParameter("title");
		String content = req.getParameter("content");

		String curPage = req.getParameter("curPage");
		String keyword = req.getParameter("keyword");

		Connection con = null;
		PreparedStatement stmt = null;

		try {
			con = dbmgr.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setInt(1, parent);
			stmt.setString(2, title);
			stmt.setString(3, content);
			stmt.executeUpdate();
		} catch (SQLException e) {
			log.debug("Error Source:BoardReplier.java : SQLException");
			log.debug("SQLState : " + e.getSQLState());
			log.debug("Message : " + e.getMessage());
			log.debug("Oracle Error Code : " + e.getErrorCode());
			log.debug("sql : " + sql);
		} finally {
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
			String path = req.getContextPath();
			keyword = java.net.URLEncoder.encode(keyword,"UTF-8");
			resp.sendRedirect(path + "/board/list.jsp?curPage=" + curPage + "&keyword=" + keyword);
		}

	}
}