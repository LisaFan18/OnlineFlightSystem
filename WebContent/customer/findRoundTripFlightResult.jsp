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
		
		String dpAirport = request.getParameter("dpAirport"); 
		String arAirport = request.getParameter("arAirport"); 
		String DomesticInter = request.getParameter("DomesticInter");
		String departCalendar = request.getParameter("departCalendar"); 
		String returnCalendar = request.getParameter("returnCalendar"); 
		
		if (dpAirport == null || dpAirport.length() != 3 || arAirport == null || arAirport.length() != 3) {
			%>
			<script>
				alert("Sorry, the Airport Id should be three-letter IDs");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}
		
		if (departCalendar == null || departCalendar.length() == 0 || returnCalendar == null || returnCalendar.length() == 0) {
			%>
			<script>
				alert("Sorry, Please choose a depart or return date");
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
		Date returnDate = df2.parse(returnCalendar);
		String departCalendarStr = df.format(departDate);
		String returnCalendarStr = df.format(returnDate);
				
		if(today.after(departDate)){
			%>
			<script>
				alert("Depart date must be after today");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}
		
		if(departDate.after(returnDate)){
			%>
			<script>
				alert("Return date must be after Depart Date");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}


		try {

				String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
	
				// 1. check whether the dpAirport_id exists
				String strQuery = " SELECT  *  FROM AIRPORT " + " WHERE  airport_id=?;";
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
				
				// 2. check whether the arAirport_id exists
				strQuery = " SELECT  *  FROM AIRPORT " + " WHERE  airport_id=?;";
				stm = con.prepareStatement(strQuery);
				stm.setString(1, arAirport);
				rs = stm.executeQuery();
				if(!rs.isBeforeFirst()){
					%>
					<script>
						alert("Sorry, the arrival Airport Id doesnot exists");
						window.location.href = "findCheapFlight.jsp";
					</script>
					<%
					con.close();
					return;
				}
				
				// To trip 
				strQuery = " SELECT FLIGHT.*, TICKET.depart_date,TICKET.Arrival_Date,TICKET.ticket,TICKET.fare "
						+ " FROM FLIGHT, TICKET, AIRPORT A1, AIRPORT A2 "
				        + " WHERE FLIGHT.from_air=? AND FLIGHT.to_air=? " 
					    + " AND FLIGHT.from_air=A1.airport_id AND FLIGHT.to_air=A2.airport_id	"
						+ " AND TICKET.depart_date=? AND TICKET.ticket>0 "
						+ " AND FLIGHT.flight_num=TICKET.flight_num AND FLIGHT.airline_id=TICKET.airline_id ";
				
// 				if(DomesticInter.equals("DOMESTIC")){
// 					strQuery += " AND A1.country='USA' AND A2.country='USA';";
// 				} 
// 				if(DomesticInter.equals("INTERNATIONAL")){
// 					strQuery += " AND A2.country<>'USA';";
// 				} 
				
				PreparedStatement	stmtTo = con.prepareStatement(strQuery);
				stmtTo.setString(1, dpAirport);
				stmtTo.setString(2, arAirport);
				stmtTo.setString(3, departCalendarStr);
				ResultSet rsTo = stmtTo.executeQuery();
				
				//If no any flight available on the user specific date, system should be able to provide close date available flights, i.e. next day or before a day
				if(!rsTo.isBeforeFirst()){
					out.println("<p style='color:black'> Sorry, the date you chose has no available flights, we provide the flight in the next day for you.<p>");
					calobj.setTime(departDate);
					calobj.add(Calendar.DATE, 1);
					String newDepartCalendar = df.format(calobj.getTime());
					stmtTo.setString(3, newDepartCalendar);
					rsTo = stmtTo.executeQuery();
					
					if(!rsTo.isBeforeFirst()){
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
						stmtTo = con.prepareStatement(strQuery);
						stmtTo.setString(1, departCalendarStr);
						stmtTo.setString(2, dpAirport);
						stmtTo.setString(3, arAirport);
						stmtTo.setString(4, departCalendarStr);
						//System.out.println(stm.toString());
						rsTo = stmtTo.executeQuery();
						if(!rsTo.isBeforeFirst()){
							out.println("<p style='color:red'> Ooops, no available multiple-stop flights.Try to book another trip<p>");	
							con.close();
							out.print("<p class='message'> <br><br>Go Back? <a href='findCheapFlight.jsp'>" + " Go Back</a></p>");
							return;
						} 
						out.println("<p style='color:red'> Good, we found several stops for you. You can book it through the Multiple Cities option. <p>");	
						
						// print table header for multiple-stop flight
						ResultSetMetaData md = rsTo.getMetaData();
						out.print("<table><tr>");
						int rowCount = md.getColumnCount();
						for (int i = 1; i <= rowCount; i++) {
							out.print("<td>" + md.getColumnName(i) + "</td>");
						}
						out.print("</tr>");
						 // print the result
						while(rsTo.next()){
							out.print("<tr>");
							for (int i = 1; i <= rowCount; i++) {
								String columnName = md.getColumnName(i);
								String columnValue = rsTo.getString(columnName);
								
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
				// non-stop flights (To)
				ResultSetMetaData md = rsTo.getMetaData();
				List<String> columns = new ArrayList<String>();
				int rowCount = md.getColumnCount();
				for (int i = 1; i <= rowCount; i++) {
					columns.add(md.getColumnName(i));
				}

				List<String[]> resultsTo = new ArrayList<String[]>();
				while (rsTo.next()) {
					String[] row = new String[rowCount];
					for (int i = 1; i <= rowCount; i++) {
						row[i - 1] = rsTo.getString(columns.get(i - 1));
					}
					resultsTo.add(row);
				}
			
				
				// Back Trip
				PreparedStatement stmtBack = con.prepareStatement(strQuery);
				// switch the departure airport and arrival airport 
				stmtBack.setString(1, arAirport);
				stmtBack.setString(2, dpAirport);
				stmtBack.setString(3, returnCalendarStr);
				//System.out.println(stmtBack.toString());

				ResultSet rsBack = stmtBack.executeQuery();
				List<String[]> resultsBack = new ArrayList<String[]>();
				while (rsBack.next()) {
					String[] row = new String[rowCount];
					for (int i = 1; i <= rowCount; i++) {
						row[i - 1] = rsBack.getString(columns.get(i - 1));
					}
					resultsBack.add(row);
				}
				
				// print out the roundTrip choice
				out.println("<h2>Your choice: </h2>");
				
				int index = 1;
				for (int s = 0; s<resultsTo.size(); s++){
					for (int t = 0; t<resultsBack.size(); t++){
						out.print("<h3> Flight Choice_" + index + "</h3>");
						out.print("<form action='makeRoundTripReservation.jsp' id='makeResForm' >");
						out.print("<input type='hidden' name='customer_account' value='"  + customer_account + "'/>");
						
						out.print("<table id='makeResTable"+ index + "'>");
						
						// print table header
						out.print("<tr>");
						for (int i = 0; i < columns.size(); i++) {
							out.print("<td>" + columns.get(i) + "</td>");
						}
						out.print("<td>You Pay</td>");
						out.print("</tr>");
						
						// print one flight (To)
						String[] rowDataTo = resultsTo.get(s);
						out.print("<tr>");
						for(int i = 0; i < columns.size(); i++){
							String name = columns.get(i);
							String value = rowDataTo[i];
							out.print("<td>" + value);
							out.print("<input type='hidden' name='to_" + name + "' value='"  + value + "'/>");
							out.print("</td>");
						}
						
						
						double bookingFeeTo = computeFlexibleDiscount(today, departDate)*Integer.parseInt(rowDataTo[10]);
						out.print("<td>" + bookingFeeTo);
						out.print("<input type='hidden' name='" + "to_booking_fee" + "' value='"  + bookingFeeTo + "'/>");
						out.print("</td>");
						out.print("</tr>");
						
						// print one flight (Back)
						String[] rowDataBack = resultsBack.get(t);
						out.print("<tr>");
						for(int i = 0; i < columns.size(); i++){
							String name = columns.get(i);
							String value = rowDataBack[i];
							out.print("<td>" + value);
							out.print("<input type='hidden' name='back_" + name + "' value='"  + value + "'/>");
							out.print("</td>");
						}

						double bookingFeeBack = computeFlexibleDiscount(today, returnDate)*Integer.parseInt(rowDataBack[10]);
						out.print("<td>" + bookingFeeBack);
						out.print("<input type='hidden' name='" + "back_booking_fee" + "' value='"  + bookingFeeBack + "'/>");
						out.print("</td>");
						
						out.print("<td><input type='submit' value='Book Now'></td>");
						out.print("</tr>");
						
						out.print("</table>");
						index++;
					}
				}
				
				 out.print("<p class='message'> <br><br>Go Back? <a href='findCheapFlight.jsp'>" + " Go Back</a></p>");
				 con.close();

			} catch (Exception e) {
				out.println("failed in findRoundTripResult.jsp" + e.toString());
				e.printStackTrace();
			}
		%>
		
		<%!
			double computeFlexibleDiscount(Date today, Date departDate) {
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