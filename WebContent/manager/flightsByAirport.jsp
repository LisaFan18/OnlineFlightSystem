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
		String airPort = request.getParameter("airPortId");
		if (airPort == null || airPort.length() != 3) {
			%>
			<script>
				alert("Sorry, the Airport Id should be three-letter IDs");
				window.location.href = "flightReports.jsp";
			</script>
			<%
			return;
		}

		try {

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");

			// 1. check whether the airport_id exists
			String strQuery = " SELECT *  FROM AIRPORT " + " WHERE  airport_id=?;";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, airPort);
			ResultSet rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, the Airport Id does not exist");
					window.location.href = "flightReports.jsp";
				</script>
				<%
				con.close();
				return;
			}
			
			
			strQuery = " SELECT *  FROM FLIGHT  WHERE  from_air=? OR to_air=?;";
			stm = con.prepareStatement(strQuery);
			stm.setString(1, airPort);
			stm.setString(2, airPort);

// 			System.out.println("debug sql:" + stm.toString());
			rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, no flight in this Airport!");
					window.location.href = "flightReports.jsp";
				</script>
				<%
				con.close();
				return;
			} 
			
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

			String queryType = "List Flights By Airport: ";
			request.setAttribute("columns", columns);
			request.setAttribute("results", results);
			request.setAttribute("querytype", queryType);

			con.close();

			RequestDispatcher rd = request.getRequestDispatcher("mgrQueryResults.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			out.println("Failed!");
			e.printStackTrace();
		}

	%>

</body>
</html>