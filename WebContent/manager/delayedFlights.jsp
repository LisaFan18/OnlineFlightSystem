<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Storing request</title>
</head>
<body>
	<%
		String delayOntime = request.getParameter("delayOntime");
		if (delayOntime == null || delayOntime.length() == 0 ) {
			%>
			<script>
				alert("Please choose the option: delay or ontime");
				window.location.href = "flightReports.jsp";
			</script>
			<%
			return;
		}

		try {

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
			
			String strQuery = " SELECT F.*,T.depart_date "
					+ " FROM FLIGHT F, TICKET T "
					+ " WHERE F.airline_id=T.airline_id AND F.flight_num=T.flight_num AND T.delay=?"
					+ " ORDER BY T.depart_date DESC;";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, delayOntime);
			ResultSet rs = stm.executeQuery();
			ResultSetMetaData md = rs.getMetaData();

			List<String> columns = new ArrayList<String>();
			int rowCount = md.getColumnCount();
			for (int i = 1; i <= rowCount; i++) {
				columns.add(md.getColumnName(i));
			}
			
			List<String[]> results = new ArrayList<String[]>();
			while (rs.next()) {
				String[] row = new String[rowCount];
				for (int i = 1; i <= rowCount; i++) {
					row[i - 1] = rs.getString(columns.get(i - 1));
				}
				results.add(row);
			}

			String queryType = "List Flights by Delays: ";
			request.setAttribute("columns", columns);
			request.setAttribute("results", results);
			request.setAttribute("querytype", queryType);

			con.close();

			RequestDispatcher rd = request.getRequestDispatcher("mgrQueryResults.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			out.println(e);
			e.printStackTrace();
		}

		response.setContentType("text/html");
	%>

</body>
</html>