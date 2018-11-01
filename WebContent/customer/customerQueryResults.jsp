<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
        
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="css/login.css">
  <link rel="stylesheet" type="text/css" href="css/textbox.css">
</head>
<body>

	<%
		String customer_account = session.getAttribute("customer_account").toString();
    		String customer_email = session.getAttribute("customer_email").toString();
		out.print( "<p class='message' > Welcome! Dear " + customer_email + "</p>");
	%>
		
<h2><%=request.getAttribute("querytype")%></h2>
<table border=1>
	<% 
	  List<String> columns = (List<String>)request.getAttribute("columns");
	  List<String[]> results = (List<String[]>)request.getAttribute("results"); 
	  out.println("<tr>");
	  for(String columnName: columns ){
	     out.println("<td>"+columnName+"</td>");
	  }
	  out.println("</tr>");
	  for(String[] rowData: results){
	     out.println("<tr>");
	     for(String data: rowData){
	        out.println("<td>"+data+"</td>");
	     }
	     out.println("</tr>");
	  }
	%>
</table>

<p class="message">Go back? <a href="customerHomePage.jsp">Go back</a></p>
<!-- <p class="message">Logout? <a href="/Rutgers-Online-Travel/index.jsp">Logout</a></p> -->
</body>
</html>
