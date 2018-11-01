<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%	
	 	String newEmail = request.getParameter("cstEmail");
	 	String newPswd = request.getParameter("cstPassword");

 		try {
 			//Create a connection string
 			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
 			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the combobox from the HelloWorld.jsp
			
 			if ( newEmail.equals("") || newPswd.equals("")){
				%>
				<script>  
				    alert("Please enter your email or password");
				    window.location.href = "/Rutgers-Online-Travel/index.jsp";
				</script>
				<% 
			} else {
				String str = "SELECT * FROM CUSTOMERS c WHERE c.email='" + newEmail + "' and c.password='" + newPswd + "'";
	
				ResultSet result = stmt.executeQuery(str);
				//System.out.println(str);
	
				if (result.next()) {
					session.setAttribute("customer_email", newEmail);
					
					// retrieve customer account number 
					str = "SELECT acct_num FROM ACCOUNT WHERE email='" + newEmail + "'";
					result = stmt.executeQuery(str);
					if(result.next()){
						session.setAttribute("customer_account", result.getString("acct_num"));
					}
 					%>
					<script>  
 					//alert("login success!");
 				    	window.location.href = "customerHomePage.jsp";
					</script>
					<%						
 				} else {
 					out.print("User not found");
					%>
					<script> 
 				    	alert("Customer email not found, or you entered a wrong password.");
 				    	window.location.href = "/Rutgers-Online-Travel/index.jsp";
					</script>
					<%
				}
			}
			con.close();
		} catch (Exception e) {
			System.out.print("failed!" + e.toString());
			%>
			<script>  
 		    	alert("Sorry, unexcepted error happens.");
 		    	window.location.href = "/Rutgers-Online-Travel/index.jsp";
 			</script>
			<%			 
 		}
 	%>

</body>
</html>