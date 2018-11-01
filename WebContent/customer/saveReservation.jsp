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
		String airline_id = request.getParameter("airline_id");
		String flight_num = request.getParameter("flight_num");
		String booking_fee = request.getParameter("booking_fee");
		String ticket_num = request.getParameter("ticket_num");
		
		String seat_num = request.getParameter("seat_num");
		String meal = request.getParameter("meal");
		String flightClass = request.getParameter("class");
		String representative = request.getParameter("representative");
		String depart_date = request.getParameter("depart_date");
		

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
			
			// build reservation number
			String reserve_num = customer_account + dfResr.format(now);
			String total_fee = "" + Double.parseDouble(booking_fee) * Integer.parseInt(ticket_num);
			
			// save reservation
			String strInsert = "INSERT INTO RESERVATION(reserve_num, date, ticket_num, booking_fee,total_fee,acct_num)"
					+ String.format("VALUES('%s','%s','%s','%s','%s', '%s');", reserve_num, nowStr ,ticket_num, booking_fee,total_fee, customer_account);
			
// 			System.out.println(strInsert);
		 	stm.executeUpdate(strInsert);
		 	
		 	// save leg
			strInsert = "INSERT INTO LEG(airline_id,flight_num,reserve_num,seat_num,class,meal,fly_date,representative)"
				 + String.format("VALUES('%s','%s','%s','%s','%s', '%s','%s', '%s');",airline_id, flight_num, reserve_num, seat_num ,flightClass, meal,depart_date, representative);
			
// 		 	System.out.println(strInsert);
		 	stm.executeUpdate(strInsert);
		 	
		 	// update ticket num
		 	
		 	String strUpdate = "UPDATE TICKET T,LEG L, RESERVATION R "
		 			+ " SET T.ticket=T.ticket-R.ticket_num " 
		 			+ " WHERE L.flight_num=T.flight_num AND L.airline_id=T.airline_id AND R.reserve_num=?"
		 			+ " AND L.reserve_num=R.reserve_num AND T.depart_date=L.fly_date;";
		 	PreparedStatement pstm = con.prepareStatement(strUpdate);
			pstm.setString(1, reserve_num);
			pstm.executeUpdate();
		 	con.close();
		 	
			%>
			<script> 
		 		alert("Congratulation! New reservation created.");
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