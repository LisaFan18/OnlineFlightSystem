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
		// get data from manageCustomer.jsp
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");

		try {
			//Create a connection string

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String strQuery = "SELECT A.acct_num, C.*, A.credit" 
							+ " FROM CUSTOMERS C, ACCOUNT A"
							+ " WHERE C.firstname = ? AND C.lastname = ? " + " AND C.email = A.email";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, firstName);
			stm.setString(2, lastName);
			ResultSet rs = stm.executeQuery();
			ResultSetMetaData md = rs.getMetaData();

			//Data structure to hold column names
			List<String> columns = new ArrayList<String>();
			int rowCount = md.getColumnCount();
			for (int i = 1; i <= rowCount; i++) {
				columns.add(md.getColumnName(i));
			}

			//Data structure to hold result set
			List<String[]> results = new ArrayList<String[]>();
			while (rs.next()) {
				String[] row = new String[rowCount];
				for (int i = 1; i <= rowCount; i++) {
					row[i - 1] = rs.getString(columns.get(i - 1));
				}
				results.add(row);
			}

			String queryType = "Delete Customer List (A customer may have one or more accounts):";
			request.setAttribute("columns", columns);
			request.setAttribute("results", results);
			request.setAttribute("querytype", queryType);

			con.close();

			RequestDispatcher rd = request.getRequestDispatcher("showDeleteCustomer.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			out.print("failed! " + e.toString());

		}
	%>

</body>
</html>