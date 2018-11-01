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
				String mgAccount = session.getAttribute("account").toString();
				out.print( "<p class='message' > Welcome! Dear " + mgAccount + "</p>");
			%>
			<p class="message">You are now log in as a manager. Log out please <a href="mgLogin.jsp">click here</a></p>
			
			<p class="message-red">Operations</p>
			<form>
			
				<button formaction='manageCustomer.jsp'> Manage an Customer </button>
				<br /><br />
				<button formaction='saleReportByMonth.jsp'> Sales Report for a Particular Month </button>
				<br /><br />
				<button formaction='flightReports.jsp'> Flight Report </button>
				<br /><br />
				<button formaction='revenueReports.jsp'> Revenue Report </button>
			</form>
			
		</div>
	</div>
</body>
</html>