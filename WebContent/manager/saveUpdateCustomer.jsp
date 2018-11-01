<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Rutgers Online Travel</title>

</head>
<body>

	<%

	    String email = (String)request.getParameter("email");
	    String password = (String)request.getParameter("password");
		String firstName = (String)request.getParameter("firstname");
	    String lastName = (String)request.getParameter("lastname");
	    String address = (String)request.getParameter("address");
	    String city = (String)request.getParameter("city");
	    String state = (String)request.getParameter("state");
	    String zipCode = (String)request.getParameter("zipcode");
	    String phone = (String)request.getParameter("phone");
	    String creditCardNo = (String)request.getParameter("credit");
	    
	    // check required field
	    if (firstName == null || firstName.length() == 0 ||
	    		lastName == null || lastName.length() == 0 || 
	    		address == null || address.length() == 0 ||
	    		city == null || city.length() == 0 ||
	    		state == null || state.length() == 0 || 
	    		zipCode == null || zipCode.length() == 0 ||
	    		phone == null || phone.length() == 0 ){
	 		%> 
			<script> 
	 			alert("please fill the required fields");
	 			window.location.href = "manageCustomer.jsp";
	 		</script> 
			<% 
	 		return;	
	    }
	
		// 1. check the password length
		if( password.length() < 3 ){
			System.out.println("password too short!");
	 		%> 
			<script> 
	 			alert("Sorry, the password should be at least 3 characters");
	 			window.location.href = "manageCustomer.jsp";
	 		</script> 
			<% 
	 		return;			
		}
	
	try {
	
		String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");
	
		//Create a connection to your DB
		Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
		//Create a SQL statement
		Statement stmt = con.createStatement();
		

			String strQuery = "UPDATE CUSTOMERS C, ACCOUNT A " 
							+ " SET C.firstname = ?,"
							+ " C.lastname = ?,"
							+ " C.address = ?,"
							+ " C.city = ?,"
							+ " C.state = ?,"
							+ " C.zipcode = ?,"
							+ " C.phone = ?,"
							+ " C.password = ?,"
							+ " A.credit = ? "
							+ " WHERE C.email  = ? AND A.email = C.email;";

			PreparedStatement stm = con.prepareStatement(strQuery);
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			stm.setString(1, firstName);
			stm.setString(2, lastName);
			stm.setString(3, address);
			stm.setString(4, city);
			stm.setString(5, state);
			stm.setString(6, zipCode);
			stm.setString(7, phone);
			stm.setString(8, password);
			stm.setString(9, creditCardNo);
			stm.setString(10, email);
			stm.executeUpdate();
			
			con.close();

			%>
		<script> 
			alert("Congratulation! Update customer success!");
	    		window.location.href = "manageCustomer.jsp";
		</script>
		<%
	} catch (Exception e) {
		System.out.println("update error:" + e.toString());
	
		%>
		<script> 
			 alert("Sorry, something went wrong on our server, failed to update the customer");
			 window.location.href = "manageCustomer.jsp";
		</script>
		<%
		return;
	}
%>
</body>
</html>