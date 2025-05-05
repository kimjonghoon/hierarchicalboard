package net.java_school.board;

import java.io.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.sql.*;

import net.java_school.db.dbpool.*;
import net.java_school.util.*;

public class BoardModifier extends HttpServlet {

	private static final long serialVersionUID = -971206071575571573L;

	OracleConnectionManager dbmgr = null;

	@Override
	public void init() throws ServletException {
		ServletContext sc = getServletContext();
		dbmgr = (OracleConnectionManager)sc.getAttribute("dbmgr");
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		Log log = new Log();

		int no = Integer.parseInt(req.getParameter("no"));
		String curPage = req.getParameter("curPage");

		String title = req.getParameter("title");
		String content = req.getParameter("content");

		Connection con = dbmgr.getConnection();
		PreparedStatement stmt = null;

		String sql = "UPDATE hierarchy_article SET title = ?, content = ? WHERE articleno = ?";

		try {
			stmt = con.prepareStatement(sql);
			stmt.setString(1, title);
			stmt.setString(2, content);
			stmt.setInt(3, no);
			stmt.executeUpdate();
		} catch (SQLException e) {
			log.debug("Error Source: BoardModifier.java : SQLException");
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
			resp.sendRedirect( path + "/board/view.jsp?no=" + no + "&curPage=" + curPage);
		}
	}
}