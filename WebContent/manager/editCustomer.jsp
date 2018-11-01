<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		String email = request.getParameter("email");
		try {
			//Create a connection string

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String strQuery = "SELECT C.*, A.credit" 
							+ " FROM CUSTOMERS C, ACCOUNT A"
							+ " WHERE C.email = A.email " + " AND C.email = ? ";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, email);
			
			ResultSet rs = stm.executeQuery();
			ResultSetMetaData md = rs.getMetaData();

			int rowCount = md.getColumnCount();
			while (rs.next()) {
				String[] row = new String[rowCount];
				for (int i = 1; i <= rowCount; i++) {
					String columnName = md.getColumnName(i); 
					request.setAttribute(columnName, rs.getString(columnName));
				}
			}

			con.close();
			
			 RequestDispatcher rd = request.getRequestDispatcher("updateCustomer.jsp"); 
			 rd.forward(request, response);
				%>
				<script> 
					alert("Congratulation! edit customer is success");
			    		window.location.href = "manageCustomer.jsp";
				</script>
				<%

		} catch (Exception e) {
			System.out.println("update customer error:" + e.toString());
			
			%>
			<script> 
				 alert("Sorry, something went wrong on our server, failed to update a customer");
				 window.location.href = "manageCustomer.jsp";
			</script>
			<%
			return;
		}
	%>

</body>
</html>