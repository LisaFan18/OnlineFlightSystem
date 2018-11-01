<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.*, java.util.Date" %> 
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>find the possible flight path</title>
</head>
<body>

	<%
   		String customer_email = session.getAttribute("customer_email").toString();
		String customer_account = session.getAttribute("customer_account").toString();
		
		String DomesticInter = request.getParameter("DomesticInter");
		String dpAirport = request.getParameter("dpAirport"); 
		String arAirport = request.getParameter("arAirport"); 
		String departCalendar = request.getParameter("departCalendar"); 
// 		System.out.println(departCalendar);
		
		//1. check air port 
		if (dpAirport == null || dpAirport.length() != 3 || arAirport == null || arAirport.length() != 3) {
			%>
			<script>
				alert("Sorry, the Airport Id should be three-letter IDs");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}
		// 2. check date 
		if (departCalendar == null || departCalendar.length() == 0) {
			%>
			<script>
				alert("Sorry, Please choose a depart date");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}
		
		TimeZone.setDefault(TimeZone.getTimeZone("EST"));
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calobj = Calendar.getInstance();
		Date today = calobj.getTime();
		String todayStr = df.format(today);// for flexible booking fee
		Date departDate = df2.parse(departCalendar); // for flexible Date flights
		String departCalendarStr = df.format(departDate);

		if(today.after(departDate)){
			%>
			<script>
				alert("Sorry, depart date must be after today");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}

		try {

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");

			// check whether the airport_id exists
			String strQuery = " SELECT  *  FROM AIRPORT WHERE  airport_id=?;";
			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, dpAirport);
			ResultSet rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, the depart Airport Id doesnot exists");
					window.location.href = "findCheapFlight.jsp";
				</script>
				<%
				con.close();
				return;
			}
			
			// check whether the airport_id exists
			strQuery = " SELECT  *  FROM AIRPORT WHERE  airport_id=?;";
			stm = con.prepareStatement(strQuery);
			stm.setString(1, arAirport);
			rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, the arrival Airport Id doesnot exist");
					window.location.href = "findCheapFlight.jsp";
				</script>
				<%
				con.close();
				return;
			}
			
			strQuery = " SELECT FLIGHT.*, TICKET.depart_date,TICKET.Arrival_Date,TICKET.ticket,TICKET.fare "
					+ " FROM FLIGHT, TICKET, AIRPORT A1, AIRPORT A2 "
			        + " WHERE FLIGHT.from_air=? AND FLIGHT.to_air=? " 
				    + " AND FLIGHT.from_air=A1.airport_id AND FLIGHT.to_air=A2.airport_id	"
					+ " AND TICKET.depart_date=? AND TICKET.ticket>0 "
					+ " AND FLIGHT.flight_num=TICKET.flight_num AND FLIGHT.airline_id=TICKET.airline_id ";
			
			if(DomesticInter.equals("DOMESTIC")){
				strQuery += " AND A1.country='USA' AND A2.country='USA';";
			} 
			if(DomesticInter.equals("INTERNATIONAL")){
				strQuery += " AND A2.country<>'USA';";
			} 
			
			stm = con.prepareStatement(strQuery);
			stm.setString(1, dpAirport);
			stm.setString(2, arAirport);
			stm.setString(3, departCalendarStr);

			//System.out.println("debug sql:" + stm.toString());
			rs = stm.executeQuery();

			out.println("<h2>Your choice: </h2>");
			out.println("<br>depart Airport: " + dpAirport);
			out.println("<br>arrive Airport: " + arAirport);
			out.println("<br>departure Calendar: " + departCalendar);
			out.println("<br><br>");
			
			out.println("<h2>You can choose one flight from : </h2>");
			out.print("<table id='makeResTable'>");
			out.print("<tr>");
			
			//If no any flight available on the user specific date, system should be able to provide close date available flights, i.e. next day or before a day
			if(!rs.isBeforeFirst()){
				out.println("<p style='color:black'> Sorry, the date you chose has no available flights, we provide the flight in the next day for you.<p>");
				calobj.setTime(departDate);
				calobj.add(Calendar.DATE, 1);
				String newDepartCalendar = df.format(calobj.getTime());
				stm.setString(3, newDepartCalendar);
				rs = stm.executeQuery();
				
				if(!rs.isBeforeFirst()){
					out.println("<p style='color:blue'> Sorry, the next day you chose has no available flights either, we try to find multiple-stop flights for you.<p>");
					// find multiple-stop flight
					strQuery = "SELECT S1.from_air, S1.stop_air, S2.to_air"
							+ " FROM (select F1.from_air, F1.to_air AS stop_air,F1.airline_id,F1.flight_num,F1.depart_time,F1.arrival_time,T1.depart_date,T1.arrival_date "
							+ "		 from FLIGHT F1, TICKET T1 "
							+ "		where  T1.depart_date=? and F1.from_air=? " 
							+ "    AND F1.flight_num=T1.flight_num AND F1.airline_id=T1.airline_id) S1,"
							+ "		(select F2.from_air, F2.to_air,F2.airline_id,F2.flight_num,F2.depart_time,F2.arrival_time,T2.depart_date,T2.arrival_date "
							+ "         from FLIGHT F2, TICKET T2 "
							+ "         where F2.to_air=? AND T2.depart_date>=?"
							+ "        AND F2.flight_num=T2.Flight_num AND F2.airline_id=T2.airline_id ) S2 "
							+ " where S1.stop_air=S2.from_air "
							+ " and  S1.arrival_time < S2.depart_time and S1.arrival_date=S2.depart_date "
							+ " ORDER BY S2.depart_date;";
					stm = con.prepareStatement(strQuery);
					stm.setString(1, departCalendarStr);
					stm.setString(2, dpAirport);
					stm.setString(3, arAirport);
					stm.setString(4, departCalendarStr);
					//System.out.println(stm.toString());
					rs = stm.executeQuery();
					if(!rs.isBeforeFirst()){
						out.println("<p style='color:red'> Ooops, no available multiple-stop flights.Try to book another trip<p>");	
						con.close();
						out.print("<p class='message'> <br><br>Go Back? <a href='findCheapFlight.jsp'>" + " Go Back</a></p>");
						return;
					} 
					out.println("<p style='color:red'> Good, we found several stops for you. You can book it through the Multiple Cities option. <p>");	
					
					// print table header for multiple-stop flight
					ResultSetMetaData md = rs.getMetaData();
					out.print("<table><tr>");
					int rowCount = md.getColumnCount();
					for (int i = 1; i <= rowCount; i++) {
						out.print("<td>" + md.getColumnName(i) + "</td>");
					}
					out.print("</tr>");
					 // print the result
					while(rs.next()){
						out.print("<tr>");
						for (int i = 1; i <= rowCount; i++) {
							String columnName = md.getColumnName(i);
							String columnValue = rs.getString(columnName);
							
							out.print("<td>" + columnValue + "</td>");
						}
						out.print("</tr>");
					}
			
				   out.print("</table>");
			 	   out.print("<p class='message'> <br><br>Go Back? <a href='findCheapFlight.jsp'>" + " Go Back</a></p>");
					
				   con.close();
					return;
					
				}
			}
	
			// print table header for non-stop flights
			out.print("<table><tr>");
			ResultSetMetaData md = rs.getMetaData();
			int rowCount = md.getColumnCount();
			for (int i = 1; i <= rowCount; i++) {
				out.print("<td>" + md.getColumnName(i) + "</td>");
			}
			out.print("<td>You Pay</td>");
			out.print("</tr>");
			
	        // print the result
			while(rs.next()){
			 	out.print("<form action='makeReservation.jsp' id='makeResForm' >");
				out.print("<input type='hidden' name='customer_account' value='"  + customer_account + "'/>");
				out.print("<tr>");
				for (int i = 1; i <= rowCount; i++) {
					String columnName = md.getColumnName(i);
					String columnValue = rs.getString(columnName);
					
					out.print("<td>" + columnValue);
					out.print("<input type='hidden' name='" + columnName + "' value='"  + columnValue + "'/>");
					out.print("</td>");
				}
				
				double bookingFee = computeFlexibleDiscount(today, departDate)*Integer.parseInt(rs.getString("fare"));
				out.print("<td>" + bookingFee);
				out.print("<input type='hidden' name='" + "booking_fee" + "' value='"  + bookingFee + "'/>");
				out.print("</td>");
				
				out.print("<td><input type='submit' value='Book Now'></td>");
				out.print("</tr>");
			}
	
		   out.print("</table>");
	 	   out.print("<p class='message'> <br><br>Go Back? <a href='findCheapFlight.jsp'>" + " Go Back</a></p>");
			
		con.close();

	} catch (Exception e) {
		out.println(e);
		e.printStackTrace();
	}

	%>

	<%!double computeFlexibleDiscount(Date today, Date departDate) {
		double discount = 1.0;

		int days = (int) (Math.abs((departDate.getTime() - today.getTime())) / (1000 * 3600 * 24)); // only for test data
		//int days = (int) ((departDate.getTime() - today.getTime()) / (1000*3600*24));

		if (days < 3) {
			discount = 1.0;
		} else if (days < 7) {
			discount = 0.95;
		} else if (days < 14) {
			discount = 0.9;
		} else if (days < 21) {
			discount = 0.8;
		} else if (days < 30) {
			discount = 0.75;
		} else if (days < 60) {
			discount = 0.7;
		} else {
			discount = 0.6;
		}
		return discount;
	}
  %>
</body>
</html>