<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Rutgers Online Travel</title>

</head>
<body>
	<%
		String month = request.getParameter("month");
		String year = request.getParameter("year");
		
		if(month == null || month.length() == 0 || year == null || year.length() == 0){
			%> 
			<script> 
	 			alert("please select Year and Month ");
	 			window.location.href = "managerHomePage.jsp";
	 		</script> 
			<% 
	 		return;	
		}

		try {
			//Create a connection string

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");

			String strQuery = " SELECT SUM(R.booking_fee) AS total_fee " 
					+ " FROM RESERVATION R "
					+ " WHERE month(R.date)= ? AND year(R.date) = ? ;";

			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, month);
			stm.setString(2, year);
			ResultSet rs = stm.executeQuery();
			
			if(!rs.isBeforeFirst()){
				%> 
				<script> 
		 			alert(year + "-" + month + " doesn't have sales! Please choose another month!");
		 			window.location.href = "saleReportByMonth.jsp";
		 		</script> 
				<% 
				con.close();
		 		return;	
			} else {
				out.print("<h2>Monthly Report</h2>");
				out.print("<h3> " + year + "-" + month + " total fee: ");
				if(rs.next()){
					out.print("<label style='color: blue'>");
					out.print(rs.getString("total_fee"));
					out.print("</label>");
				}
				out.print("</h3>");
				
				out.print("<p class='message'>Go back? <a href='managerHomePage.jsp'>" + "Go back</a></p>");
			}
			con.close();
	
		} catch (Exception e) {
			System.out.println("getSaleReportByMonth error:" + e.toString());
			%>
			<script> 
				 alert("Sorry, something went wrong on our server");
				 window.location.href = "saleReportByMonth.jsp";
			</script>
			<%
			return;
		}
	%>
</body>
</html>