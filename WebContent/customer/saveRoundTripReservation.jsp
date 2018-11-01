<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.*, java.util.Date, java.util.Enumeration" %> 
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Storing request</title>
</head>
<body>
	<%
		String customer_account = request.getParameter("customer_account");
		String to_airline_id = request.getParameter("to_airline_id");
		String to_flight_num = request.getParameter("to_flight_num");
		String to_booking_fee = request.getParameter("to_booking_fee");
		String to_depart_date = request.getParameter("to_depart_date");
		
		String back_airline_id = request.getParameter("back_airline_id");
		String back_flight_num = request.getParameter("back_flight_num");
		String back_booking_fee = request.getParameter("back_booking_fee");
		String back_depart_date = request.getParameter("back_depart_date");
		
		String ticket_num = request.getParameter("ticket_num");
		String seat_num = request.getParameter("seat_num");
		String meal = request.getParameter("meal");
		String flightClass = request.getParameter("class");
		String representative = request.getParameter("representative");
		

		try {

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			Statement stm = con.createStatement();

			TimeZone.setDefault(TimeZone.getTimeZone("EST"));
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			DateFormat dfResr = new SimpleDateFormat("yyyyMMddHHmmss");
			Calendar calobj = Calendar.getInstance();
			Date now = calobj.getTime();
			String nowStr = df.format(now);
			
			// save roundTrip reservation (To)
			// build reservation number (to), t's asccii code is 116
			String to_reserve_num = customer_account + dfResr.format(now) + "116";
			String to_total_fee = "" + Double.parseDouble(to_booking_fee) * Integer.parseInt(ticket_num);
// 			System.out.println("booking_fee_to:" + to_booking_fee);
// 			System.out.println("ticket_num:" + ticket_num);
// 			System.out.println("total_fee_to:" + to_total_fee);
			
			// save reservation
			String strInsert = "INSERT INTO RESERVATION(reserve_num, date, ticket_num, booking_fee,total_fee,acct_num)"
					+ String.format("VALUES('%s','%s','%s','%s','%s', '%s');", to_reserve_num, nowStr ,ticket_num, to_booking_fee, to_total_fee, customer_account);
			
// 			System.out.println(strInsert);
		 	stm.executeUpdate(strInsert);
		 	
		 	// save leg
			strInsert = "INSERT INTO LEG(airline_id,flight_num,reserve_num,seat_num,class,meal,fly_date,representative)"
				 + String.format("VALUES('%s','%s','%s','%s','%s', '%s','%s', '%s');",to_airline_id, to_flight_num, to_reserve_num, seat_num ,flightClass, meal,to_depart_date, representative);
			
// 		 	System.out.println(strInsert);
		 	stm.executeUpdate(strInsert);
		 	
		 	// update ticket num
		 	
		 	String strUpdate = "UPDATE TICKET T,LEG L, RESERVATION R "
		 			+ " SET T.ticket=T.ticket-R.ticket_num " 
		 			+ " WHERE L.flight_num=T.flight_num AND L.airline_id=T.airline_id AND R.reserve_num=?"
		 			+ " AND L.reserve_num=R.reserve_num AND T.depart_date=L.fly_date;";
		 	PreparedStatement pstm = con.prepareStatement(strUpdate);
			pstm.setString(1, to_reserve_num);
			pstm.executeUpdate();
			
			
			// save roundTrip reservation (Back)
			// build reservation number (Back), b's asccii code is 98
			String back_reserve_num = customer_account + dfResr.format(now) + "98";
			String back_total_fee = "" + Double.parseDouble(back_booking_fee) * Integer.parseInt(ticket_num);
// 			System.out.println("booking_fee_back:" + back_booking_fee);
// 			System.out.println("ticket_num_back:" + ticket_num);
// 			System.out.println("total_fee_back:" + back_total_fee);
			
			// save reservation
			strInsert = "INSERT INTO RESERVATION(reserve_num, date, ticket_num, booking_fee,total_fee,acct_num)"
					+ String.format("VALUES('%s','%s','%s','%s','%s', '%s');", back_reserve_num, nowStr ,ticket_num, back_booking_fee, back_total_fee, customer_account);
			
// 			System.out.println(strInsert);
		 	stm.executeUpdate(strInsert);
		 	
		 	// save leg
			strInsert = "INSERT INTO LEG(airline_id,flight_num,reserve_num,seat_num,class,meal,fly_date,representative)"
				 + String.format("VALUES('%s','%s','%s','%s','%s', '%s','%s', '%s');",back_airline_id, back_flight_num, back_reserve_num, seat_num ,flightClass, meal,back_depart_date, representative);
			
// 		 	System.out.println(strInsert);
		 	stm.executeUpdate(strInsert);
		 	
		 	// update ticket num
		 	
		 	 strUpdate = "UPDATE TICKET T,LEG L, RESERVATION R "
		 			+ " SET T.ticket=T.ticket-R.ticket_num " 
		 			+ " WHERE L.flight_num=T.flight_num AND L.airline_id=T.airline_id AND R.reserve_num=?"
		 			+ " AND L.reserve_num=R.reserve_num AND T.depart_date=L.fly_date;";
		 	 pstm = con.prepareStatement(strUpdate);
			pstm.setString(1, back_reserve_num);
			pstm.executeUpdate();
			
		 	con.close();
		 	
			%>
			<script> 
		 		alert("Congratulation! New roundTrip Reservation created.");
	    			window.location.href = "customerHomePage.jsp";
			</script>
			<%
			

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

</body>
</html>