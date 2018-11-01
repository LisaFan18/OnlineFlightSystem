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

			String strQuery = " SELECT R.reserve_num, R.date, R.total_fee " 
					+ " FROM RESERVATION R "
					+ " WHERE month(R.date)= ? AND year(R.date) = ? ;";

			PreparedStatement stm = con.prepareStatement(strQuery);
			stm.setString(1, month);
			stm.setString(2, year);
			ResultSet rs = stm.executeQuery();
			if(!rs.isBeforeFirst()){
				%> 
				<script> 
		 			alert("No sales report in your specified month. Please select another month ");
		 			window.location.href = "saleReportByMonth.jsp";
		 		</script> 
				<% 
				con.close();
		 		return;	
			}
			
			ResultSetMetaData md = rs.getMetaData();
			
			List<String> columns = new ArrayList<String>();
			int rowCount = md.getColumnCount();
			for (int i = 1; i <= rowCount; i++) {
				columns.add(md.getColumnName(i));
			}
			
			List<String[]> results = new ArrayList<String[]>();
			while (rs.next()) {
				String[] row = new String[rowCount];
				for (int i = 1; i <= rowCount; i++) {
					row[i - 1] = rs.getString(columns.get(i - 1));
				}
				results.add(row);
			}
			
			strQuery = " SELECT SUM(R.total_fee) AS summary_fee " 
					+ " FROM RESERVATION R "
					+ " WHERE month(R.date)= ? AND year(R.date) = ? ;";
			stm = con.prepareStatement(strQuery);
			stm.setString(1, month);
			stm.setString(2, year);
			rs = stm.executeQuery();
			if(rs.next()){
				results.add(new String[] {"","in total:", rs.getString("summary_fee")});
			}

			String queryType = "Monthly Report: '" + year + "-" + month + "':";
			request.setAttribute("columns", columns);
			request.setAttribute("results", results);
			request.setAttribute("querytype", queryType);

			con.close();

			RequestDispatcher rd = request.getRequestDispatcher("mgrQueryResults.jsp");
			rd.forward(request, response);
	
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