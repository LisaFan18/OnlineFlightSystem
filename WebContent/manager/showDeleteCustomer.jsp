<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<body>


<div class="panel panel-default">
<div class="panel-heading">
<h3 class="panel-title"><%=request.getAttribute("querytype")%></h3>
</div>
<div class="panel-body">

<table border=1>
<%
	List<String> columns = (List<String>)request.getAttribute("columns");
	List<String[]> results = (List<String[]>)request.getAttribute("results"); 
  
    // output table header
	out.println("<tr>");
	out.println("<tr bgcolor='#E6E6E6'>");
	for (String columnName : columns) {
		out.println("<td>" + columnName + "</td>");
	}
	out.println("<td>Operation</td>");
	out.println("</tr>");

	// output rows
	for (int i = 0; i < results.size(); i++) {
		String[] rowData = results.get(i);
		if (i % 2 == 0) {
			out.println("<tr>");
			for (String data : rowData) {
				out.println("<td>" + data + "</td>");
			}
			out.println("<td><a href='deleteCustomer.jsp?email=" + rowData[8] + "'>Delete</a></td>");
			out.println("</tr><tr>");
			out.println("</tr>");
		} else {
			out.println("<tr bgcolor = '#F2F2F2'>");
			for (String data : rowData) {
				out.println("<td>" + data + "</td>");
			}
			out.println("<td><a href='deleteCustomer.jsp?email=" + rowData[8] + "'>Delete</a></td>");
			out.println("</tr><tr>");
			out.println("</tr>");

		}
	}
%>
</table>
<br><br> Go back? <a href="manageCustomer.jsp"> go back </a>
</body>
</html>
