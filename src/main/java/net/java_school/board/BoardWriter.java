package net.java_school.board;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;

import net.java_school.db.dbpool.*;
import net.java_school.util.*;

public class BoardWriter extends HttpServlet {

	private static final long serialVersionUID = 2808479929377045573L;

	OracleConnectionManager dbmgr = null;

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

		String title = req.getParameter("title");
		String content = req.getParameter("content");

		Connection con = dbmgr.getConnection();
		PreparedStatement stmt = null;

		String sql = "INSERT INTO hierarchy_article (articleno,title,content,regdate,parent) "
				+ "VALUES (seq_hierarchy_article.nextval, ?, ?, sysdate, 0)";

		try {
			stmt = con.prepareStatement(sql);
			stmt.setString(1, title);
			stmt.setString(2, content);
			stmt.executeUpdate();
		} catch (SQLException e) {
			log.debug("Error Source: BoardWriter.java : SQLException");
			log.debug("SQLState: " + e.getSQLState());
			log.debug("Message: " + e.getMessage());
			log.debug("Oracle Error Code: " + e.getErrorCode());
			log.debug("sql: " + sql);
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
			resp.sendRedirect(path + "/board/list.jsp");
		}
	}
}