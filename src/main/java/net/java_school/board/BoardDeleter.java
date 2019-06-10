package net.java_school.board;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;

import net.java_school.db.dbpool.*;
import net.java_school.util.*;

public class BoardDeleter extends HttpServlet {

	private static final long serialVersionUID = 2629174970960863624L;

	private OracleConnectionManager dbmgr;

	private static final String SQL1 = "SELECT count(*) FROM hierarchy_article WHERE parent = ?";
	private static final String SQL2 = "DELETE FROM hierarchy_article WHERE articleno = ?";

	@Override
	public void init() throws ServletException {
		ServletContext sc = getServletContext();
		dbmgr = (OracleConnectionManager) sc.getAttribute("dbmgr");
	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		Log log = new Log();

		int no = Integer.parseInt(req.getParameter("no"));
		String curPage = req.getParameter("curPage");
		String keyword = req.getParameter("keyword");

		Connection con = dbmgr.getConnection();
		PreparedStatement stmt1 = null;
		PreparedStatement stmt2 = null;
		ResultSet rs = null;

		boolean check = false;

		try {
			stmt1 = con.prepareStatement(SQL1);
			stmt1.setInt(1, no);
			rs = stmt1.executeQuery();
			rs.next();
			int num = rs.getInt(1);
			if (num == 0) {
				check = true;
			}
			if (check == true) {
				stmt2 = con.prepareStatement(SQL2);
				stmt2.setInt(1, no);
				stmt2.executeUpdate();
			}
		} catch (SQLException e) {
			log.debug("Error Source : BoardDeleter.java : SQLException");
			log.debug("SQLState : " + e.getSQLState());
			log.debug("Message : " + e.getMessage());
			log.debug("Oracle Error Code : " + e.getErrorCode());
			log.debug("sql1 : " + SQL1);
			log.debug("sql2 : " + SQL2);
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (stmt1 != null) {
				try {
					stmt1.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (stmt2 != null) {
				try {
					stmt2.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (con != null) {
				dbmgr.freeConnection(con);
			}
			log.close();
			String path = req.getContextPath();
			keyword = java.net.URLEncoder.encode(keyword, "UTF-8");
			resp.sendRedirect(path + "/board/list.jsp?curPage=" + curPage + "&keyword=" + keyword);
		}
	}
}