<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
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

 		String reserve_num = request.getParameter("reserve_num");
		
		try {
			//Create a connection string
			
			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
			//Create a SQL statement
            String strQuery = "DELETE"
                            +" FROM RESERVATION"
                            +" WHERE reserve_num=?";
            PreparedStatement stm = con.prepareStatement(strQuery);
            stm.setString(1, reserve_num);
            stm.executeUpdate();

			con.close();

			%>
			<script> 
		    	alert("Congratulations, cancel the reservation success!");
		    	window.location.href = "currentReservation.jsp";
			</script>
			<%	
			
		} catch (Exception e) {
			out.print("failed!" + e.toString());
			%>
			<script> 
		    	alert("Sorry, unexcepted error happens.");
		    	window.location.href = "customerHomePage.jsp";
			</script>
			<%			
		}
%>

</body>
</html>