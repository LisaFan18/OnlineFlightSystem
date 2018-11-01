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
// 		String DomesticInter = request.getParameter("DomesticInter");
		
		String dpAirport = request.getParameter("dpAirport"); 
		String arAirport = request.getParameter("arAirport"); 
		String departCalendar = request.getParameter("departCalendar"); 
		
		String dpAirport2 = request.getParameter("dpAirport2"); 
		String arAirport2 = request.getParameter("arAirport2"); 
		String departCalendar2 = request.getParameter("departCalendar2"); 
		
		// check air port whether exisits
		if (dpAirport == null || dpAirport.length() != 3 || arAirport == null || arAirport.length() != 3 ||
			dpAirport2 == null || dpAirport2.length() != 3 || arAirport2 == null || arAirport2.length() != 3) {
			%>
			<script>
				alert("Sorry, the Airport Id should be three-letter IDs");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}
		
		if (departCalendar == null || departCalendar.length() == 0 || departCalendar2 == null || departCalendar2.length() == 0 ) {
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
		Date departDate2 = df2.parse(departCalendar2); 
		String departCalendarStr = df.format(departDate);
		String departCalendarStr2 = df.format(departDate2);	
		
		if(today.after(departDate)){
			%>
			<script>
				alert("Depart date must be after today");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}
		
		if(departDate.after(departDate2)){
			%>
			<script>
				alert("Flight2 depart date must be after Filght1 Depart Date");
				window.location.href = "findCheapFlight.jsp";
			</script>
			<%
			return;
		}


		try {

				String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
				
				// trip 1
				String strQuery = " SELECT FLIGHT.*, TICKET.depart_date,TICKET.Arrival_Date,TICKET.ticket,TICKET.fare "
						+ " FROM FLIGHT, TICKET, AIRPORT A1, AIRPORT A2 "
				        + " WHERE FLIGHT.from_air=? AND FLIGHT.to_air=? " 
					    + " AND FLIGHT.from_air=A1.airport_id AND FLIGHT.to_air=A2.airport_id	"
						+ " AND TICKET.depart_date=? AND TICKET.ticket>0 "
						+ " AND FLIGHT.flight_num=TICKET.flight_num AND FLIGHT.airline_id=TICKET.airline_id ";
//		 				if(DomesticInter.equals("DOMESTIC")){
//	 					strQuery += " AND A1.country='USA' AND A2.country='USA';";
//	 				} 
//	 				if(DomesticInter.equals("INTERNATIONAL")){
//	 					strQuery += " AND A2.country<>'USA';";
//	 				} 
				
				PreparedStatement	stmt1 = con.prepareStatement(strQuery);
				stmt1.setString(1, dpAirport);
				stmt1.setString(2, arAirport);
				stmt1.setString(3, departCalendarStr);
				//System.out.println(stmt1.toString());
				ResultSet rs1 = stmt1.executeQuery();
				
				//no avalailable flight, system recommends one 
				if(!rs1.isBeforeFirst()){
					out.println("<p style='color:blue'> Ooops, the departure date you chose has no available flights, we provide the flight in the next day for you.<p>");
					calobj.setTime(departDate);
					calobj.add(Calendar.DATE, 1);
					String newDepartCalendar = df.format(calobj.getTime());
					stmt1.setString(3, newDepartCalendar);
					rs1 = stmt1.executeQuery();
				}
				
				ResultSetMetaData md = rs1.getMetaData();
				
				List<String> columns = new ArrayList<String>();
				int rowCount = md.getColumnCount();
				for (int i = 1; i <= rowCount; i++) {
					columns.add(md.getColumnName(i));
				}

				List<String[]> results1 = new ArrayList<String[]>();
				while (rs1.next()) {
					String[] row = new String[rowCount];
					for (int i = 1; i <= rowCount; i++) {
						row[i - 1] = rs1.getString(columns.get(i - 1));
					}
					results1.add(row);
				}
			
				
				// Trip2
				PreparedStatement stmt2 = con.prepareStatement(strQuery);
				stmt2.setString(1, dpAirport2);
				stmt2.setString(2, arAirport2);
				stmt2.setString(3, departCalendarStr2);
				//System.out.println(stmt2.toString());
				ResultSet rs2 = stmt2.executeQuery();
				//no avalailable flight, system recommends one 
				if(!rs2.isBeforeFirst()){
					out.println("<p style='color:blue'> Ooops, the return date you chose has no available flights, we provide the flight in the next day for you.<p>");
					calobj.setTime(departDate2);
					calobj.add(Calendar.DATE, 1);
					String newReturnCalendar2 = df.format(calobj.getTime());
					stmt2.setString(3, newReturnCalendar2);
					rs2 = stmt2.executeQuery();
				}
			
				List<String[]> results2 = new ArrayList<String[]>();
				while (rs2.next()) {
					String[] row = new String[rowCount];
					for (int i = 1; i <= rowCount; i++) {
						row[i - 1] = rs2.getString(columns.get(i - 1));
					}
					results2.add(row);
				}
				
				// print out the multiCity choice
				out.println("<h2>Your choice: </h2>");
				
				int index = 1;
				for (int s = 0; s<results1.size(); s++){
					for (int t = 0; t<results2.size(); t++){
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
						
						// print one row from flight1
						String[] rowData1 = results1.get(s);
						out.print("<tr>");
						for(int i = 0; i < columns.size(); i++){
							String name = columns.get(i);
							String value = rowData1[i];
							out.print("<td>" + value);
							out.print("<input type='hidden' name='to_" + name + "' value='"  + value + "'/>");
							out.print("</td>");
						}
						
						
						double bookingFeeTo = computeFlexibleDiscount(today, departDate)*Integer.parseInt(rowData1[10]);
						out.print("<td>" + bookingFeeTo);
						out.print("<input type='hidden' name='" + "to_booking_fee" + "' value='"  + bookingFeeTo + "'/>");
						out.print("</td>");
						out.print("</tr>");
						
						// print one row flight2 
						String[] rowData2 = results2.get(t);
						out.print("<tr>");
						for(int i = 0; i < columns.size(); i++){
							String name = columns.get(i);
							String value = rowData2[i];
							out.print("<td>" + value);
							out.print("<input type='hidden' name='back_" + name + "' value='"  + value + "'/>");
							out.print("</td>");
						}

						double bookingFeeBack = computeFlexibleDiscount(today, departDate)*Integer.parseInt(rowData2[10]);
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
				out.println("failed in findMultiCityResult.jsp" + e.toString());
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