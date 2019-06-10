<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String curPage = request.getParameter("curPage");
String keyword = request.getParameter("keyword");
if (keyword == null) keyword = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>New</title>
<script>
function goList(curPage, keyword) {
	location.href="list.jsp?curPage=" + curPage + "&keyword=" + keyword;
}
</script>
</head>
<body>
<h1>New</h1>
<form action="../servlet/BoardWriter" method="post">
<table>
<tr>
	<td>Title</td>
	<td><input type="text" name="title" size="50"></td>
</tr>
<tr>
	<td colspan="2">
		<textarea name="content" rows="10" cols="50"></textarea>
	</td>
</tr>
<tr>
	<td colspan="2">
		<input type="submit" value="Submit" />
		<input type="reset" value="Reset" />
		<input type="button" value="Back to the List" onclick="javascript:goList('<%=curPage %>','<%=keyword %>')" />
	</td>
</tr>
</table>
</form>  
</body>
</html>