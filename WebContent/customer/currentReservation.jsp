<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.*, java.util.Date" %> 
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
	    String customer_email = session.getAttribute("customer_email").toString();
		String customer_account = session.getAttribute("customer_account").toString();
		out.print( "<p class='message' > Welcome! Dear " + customer_email + "</p>");
		
		try {

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");

			String strQuery = " SELECT R.reserve_num, F.airline_id,F.flight_num,F.from_air,F.to_air,F.depart_time,T.depart_date,F.arrival_time,T.arrival_date "
					+ " FROM RESERVATION R, FLIGHT F,LEG L, TICKET T "
					+ " WHERE R.acct_num=? AND R.reserve_num=L.reserve_num AND L.airline_id=F.airline_id "
					+ " AND L.flight_num=F.flight_num AND T.airline_id=F.airline_id AND T.flight_num=F.flight_num AND L.fly_date=T.depart_date AND T.depart_date>=?"
					+ " ORDER BY T.depart_date DESC;";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, customer_account);
			
			TimeZone.setDefault(TimeZone.getTimeZone("EST"));
			DateFormat df = new SimpleDateFormat("yyyyMMdd");
			Calendar calobj = Calendar.getInstance();
			Date today = calobj.getTime();
			String todayStr = df.format(today);
			stm.setString(2, todayStr);
			
			ResultSet rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, you don't have current reservation");
					window.location.href = "customerHomePage.jsp";
				</script>
				<%
				return;
			}

			out.println("<h2>Current Reservation List  and Retrieve itinerary: </h2>");
			out.print("<table border=1 id='itineraryTable'>");
			out.print("<tr>");

			// print table header
			ResultSetMetaData md = rs.getMetaData();
			int rowCount = md.getColumnCount();
			for (int i = 1; i <= rowCount; i++) {
				out.print("<td>" + md.getColumnName(i) + "</td>");
			}
			out.print("<td>Operation</td>");
			out.print("</tr>");
			
	        // print the result
			while(rs.next()){
			 	out.print("<form action='searchItinerary.jsp' id='itineraryForm' >");
				out.print("<input type='hidden' name='customer_account' value='"  + customer_account + "'/>");
				out.print("<input type='hidden' name='reserve_num'"  + "' value='"  + rs.getString("reserve_num") + "'/>");
				out.print("<tr>");
				for (int i = 1; i <= rowCount; i++) {
					String columnName = md.getColumnName(i);
					String columnValue = rs.getString(columnName);
					
					out.print("<td>" + columnValue);
					out.print("</td>");
				}
				
				out.print("<td><input type='submit' style='color: blue' value='Get Itinerary'></td>");
				out.print("</tr>");
			}

		   out.print("</table>");
			con.close();

		} catch (Exception e) {
			%>
			<script> 
		    	alert("Sorry, unexcepted error happens.");
		    	window.location.href = "customerHomePage.jsp";
			</script>
			<%			
			System.out.println("Failed!" + e.toString());
		}

	%>
  
  <br><br>Go Back? <a href= "customerHomePage.jsp"> Go Back</a>
</body>
</html>