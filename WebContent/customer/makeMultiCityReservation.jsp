<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<h2>Path Details</h2>
<p>Select additional options for your Reservation</p>
<form name="reservationForm" action="saveRoundTripReservation.jsp" method="post">

	<input type="hidden" name="customer_account" value="<%=request.getParameter("customer_account")%>"/>
	<input type="hidden" name="to_airline_id" value="<%=request.getParameter("to_airline_id")%>"/>
	<input type="hidden" name="to_flight_num" value="<%=request.getParameter("to_flight_num")%>"/>
	<input type="hidden" name="to_booking_fee" value="<%=request.getParameter("to_booking_fee")%>"/>
	<input type="hidden" name="to_depart_date" value="<%=request.getParameter("to_depart_date")%>"/>
	
	<input type="hidden" name="back_airline_id" value="<%=request.getParameter("back_airline_id")%>"/>
	<input type="hidden" name="back_flight_num" value="<%=request.getParameter("back_flight_num")%>"/>
	<input type="hidden" name="back_booking_fee" value="<%=request.getParameter("back_booking_fee")%>"/>
	<input type="hidden" name="back_depart_date" value="<%=request.getParameter("back_depart_date")%>"/>
	
  <h4>Seat Class:</h4>
    <label for="economy">Economy</label>
    <input type="radio" checked name="class" id="economy" value="economy">
    <label for="business">Business</label>
    <input type="radio" name="class" id="business" value="business">
    <label for="first">First Class</label>
    <input type="radio" name="class" id="first" value="first">
  <h4> Seat Number: </h4>
  	<label>Input your preference seat number: </label>
  	<input type = "text" name="seat_num" value="4A"> 
  <h4>Number of Passengers:</h4>
    <label>How many tickets do you need?</label>
    <select name='ticket_num'>
    <%for(int i=1;i<4;i++) {%>
    <option value='<%=i%>'><%=i%></option>
    <%}%>
    </select>
    <label>Passengers</label>
  
  <h4>Meal:</h4>
    <label>Do you request any special Meal for your flight?</label>
    <input type="text" name="meal" value="Noodle">

  <h4>Customer Representative:</h4>
    <label>Did a customer representative help you? If so, enter his/her name. If not, enter "no".</label>
    <input type="text" class="textbox" name="representative" value="no"><br>
    
  <br><br><input type='submit' value='Book It'>
</form>
<br><br>Go Back ?<a href= "findCheapFlight.jsp"> Go Back</a>
</body>
</html>