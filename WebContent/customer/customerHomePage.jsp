<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="../css/login.css">

<title>Rutgers Online Travel</title>
</head>
<body>

	<p class="app-name"> Rutgers Online Travel </p>      

	<div class="passenger-home-page">
	
		<div class="form">
			<%
			    String customer_email = session.getAttribute("customer_email").toString();
				String customer_account = session.getAttribute("customer_account").toString();
				out.print( "<p class='message' > Welcome! Dear " + customer_email + "</p>");
			%>
			<p class="message">You are now log in as a customer. Log out please <a href="../index.jsp">click here</a></p>
			
			<p class="message-red">Operations</p>
			<form>
			
				<button formaction='findCheapFlight.jsp'> Make a Reservation </button>
				<br /><br />
				<button formaction='currentReservation.jsp'> Current Reservation And Itinerary </button>
				<br /><br />
				<button formaction='cancelExistingReservation.jsp'> Cancel My Reservation </button>
				<br /><br />
				<button formaction='reservationHistory.jsp'> Reservation History </button>
				<br /><br />
				<button formaction='bestSellerFlights.jsp'> Best-Seller list of Flights</button>
				<br /><br />
				<button formaction='editProfile.jsp'> Edit Profile </button>
				<br /><br />
			</form>
			
		</div>
	</div>
<p class="message">Logout? <a href="/Rutgers-Online-Travel/index.jsp">Logout</a></p>
</body>
</html>