<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>bestSellerFlights</title>
</head>
<body>
	<%
		
		String customer_account = session.getAttribute("customer_account").toString();

		try {
			//Create a connection string
			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
			String strQuery = "SELECT R.reserve_num, F.airline_id,F.flight_num,F.from_air,F.to_air,F.depart_time,T.depart_date,F.arrival_time,T.arrival_date "
					+ " FROM RESERVATION R, FLIGHT F,LEG L, TICKET T "
					+ " WHERE R.acct_num=? AND R.reserve_num=L.reserve_num AND L.airline_id=F.airline_id"
					+ " AND L.flight_num=F.flight_num AND T.airline_id=F.airline_id AND T.flight_num=F.flight_num AND L.fly_date=T.depart_date "
					+ " ORDER BY T.depart_date DESC;";

		    PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, customer_account);

// 			System.out.println(" debuggable statement= " + stm.toString());
			ResultSet rs = stm.executeQuery();
			ResultSetMetaData md = rs.getMetaData();

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

			String queryType = "Reservation History: ";
			request.setAttribute("columns", columns);
			request.setAttribute("results", results);
			request.setAttribute("querytype", queryType);

			con.close();

			RequestDispatcher rd = request.getRequestDispatcher("customerQueryResults.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			%>
			<script> 
		    	alert("Sorry, unexcepted error happens.");
		    	window.location.href = "customerHomePage.jsp";
			</script>
			<%			
			System.out.println("Failed!" + e.toString());
		}

		response.setContentType("text/html");
	%>

</body>
</html>