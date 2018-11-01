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
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		if (firstName == null || firstName.length() == 0 ||
			lastName == null  || lastName.length() == 0) {
			%>
			<script>
				alert("Please input customer's first name and last name");
				window.location.href = "flightReports.jsp";
			</script>
			<%
			return;
		}

		try {
			//Create a connection string

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
			// 1. check whether customer's name exists
			String strQuery = " SELECT *  FROM CUSTOMERS " + " WHERE  firstname=? AND lastname=?;";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, firstName);
			stm.setString(2, lastName);
			ResultSet rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, the customer name does not exist!");
					window.location.href = "flightReports.jsp";
				</script>
				<%
				con.close();
				return;
			} 

			strQuery = " SELECT R.acct_num, R.reserve_num, R.date, R.ticket_num, R.booking_fee, R.total_fee, L.airline_id, L.flight_num, L.fly_date, L.seat_num, L.class, L.meal"
					+ " FROM CUSTOMERS C, ACCOUNT A, RESERVATION R,LEG L  "
					+ " WHERE C.firstname = ? AND C.lastname = ? AND C.email = A.email AND A.acct_num = R.acct_num AND R.reserve_num = L.reserve_num;";
			stm = con.prepareStatement(strQuery);
			stm.setString(1, firstName);
			stm.setString(2, lastName);

// 			System.out.println(" debuggable statement= " + stm.toString());
			rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, no reservation under this customer!");
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
			
			//Data structure to hold result set
			List<String[]> results = new ArrayList<String[]>();
			while (rs.next()) {
				String[] row = new String[rowCount];
				for (int i = 1; i <= rowCount; i++) {
					row[i - 1] = rs.getString(columns.get(i - 1));
				}
				results.add(row);
			}

			String queryType = "List Reservations by Customer '" + firstName + " " + lastName + "': ";
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

	%>

</body>
</html>