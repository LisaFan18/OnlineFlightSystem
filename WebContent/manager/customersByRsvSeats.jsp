<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.time.LocalTime"%>
<%@ page import="java.text.*, java.util.Date" %> 
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>flightReports</title>
</head>
<body>
	<%
		String flightNo = request.getParameter("custFlightNumber");
	    String flydateCalendar = request.getParameter("flydateCalendar");
 	    //System.out.print(flydateCalendar);
		if (flightNo == null || flightNo.length() < 3 || flydateCalendar == null) {
			%>
			<script>
				alert("Please input correct flight number or fly date");
				window.location.href = "flightReports.jsp";
			</script>
			<%
			return;
		}

		String airlineId = flightNo.substring(0, 2);
		Integer flightNum = Integer.parseInt(flightNo.substring(2));

			try {
			//Create a connection string

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
			// 1. check whether flightNo exits
			String strQuery = "SELECT * FROM FLIGHT WHERE airline_id =? AND flight_num=?";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, airlineId);
			stm.setInt(2, flightNum);
			ResultSet rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, the flightNumber does not exist");
					window.location.href = "flightReports.jsp";
				</script>
				<%
				con.close();
				return;
			} 
			
			strQuery = " SELECT C.firstname, C.lastname, C.email,A.acct_num "
					+ " FROM CUSTOMERS C, ACCOUNT A, RESERVATION R, LEG L"
					+ " WHERE L.seat_num IS NOT NULL  " 
					+ " AND  L.airline_id = ? AND L.flight_num = ? AND L.fly_date=?"
					+ " AND C.email = A.email AND A.acct_num = R.acct_num AND L.reserve_num = R.reserve_num;";

			stm = con.prepareStatement(strQuery);
			stm.setString(1, airlineId);
			stm.setInt(2, flightNum);
			
			DateFormat df = new SimpleDateFormat("yyyyMMdd");
			DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
			Date flydDate = df2.parse(flydateCalendar); 
			String flydateCalendarStr = df.format(flydDate);
			stm.setString(3, flydateCalendarStr);

 			//System.out.println(" debuggable statement= " + stm.toString());
			rs = stm.executeQuery();
			ResultSetMetaData md = rs.getMetaData();

			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, no reservation under this Flight Number and Fly Date!");
					window.location.href = "flightReports.jsp";
				</script>
				<%
				con.close();
				return;
			} 
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
			
			String queryType = "List all Customers by reserved seats: ";
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