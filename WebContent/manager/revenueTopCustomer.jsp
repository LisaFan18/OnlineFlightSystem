<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Storing request</title>
</head>
<body>
	<%

		try {
			//Create a connection string

			String url = "jdbc:mysql://cs539-fzj-spring18.cqcdjb7jk2qs.us-east-2.rds.amazonaws.com:3306/hwproject";
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "fzj", "Ru151718~");
			
// 			String strQuery = "SELECT M.firstname, M.lastname, M.email, M.revenue "
// 					+ " FROM(select C.firstname AS firstname, C.lastname AS lastname, A.email AS email, SUM(R.total_fee) AS revenue "
// 							+ " FROM CUSTOMERS C, ACCOUNT A, RESERVATION R"
// 							+ " WHERE  C.email = A.email AND A.acct_num = R.acct_num"
// 							+ " group by C.email) M "
// 					+ " HAVING MAX(M.revenue);";
					
		 	String strQuery	 = "	SELECT  C.firstname, C.lastname, C.email, M1.revenue "
					+ " FROM CUSTOMERS C, ACCOUNT A, "
					+ "		(select  acct_num, sum(R.total_fee) revenue "
					+ "		from RESERVATION R "
					+ "		group by R.acct_num "
					+ "       ) M1 "
					+ " WHERE C.email = A.email AND A.acct_num = M1.acct_num AND M1.revenue = ( "
					+ "      select max(M2.revenue) "
					+ "		from (select  acct_num, sum(R.total_fee) revenue "
					+ "				from RESERVATION R "
					+ "				group by R.acct_num "
					+ "       ) M2 ); ";

			Statement stm = con.createStatement();

// 			System.out.println(" debuggable statement= " + stm.toString());
			ResultSet rs = stm.executeQuery(strQuery);
			if(!rs.isBeforeFirst()){
				%>
				<script>
					alert("Sorry, no data to summary.");
					window.location.href = "revenueReports.jsp";
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
			
			//Data structure to hold result set
			List<String[]> results = new ArrayList<String[]>();
			while (rs.next()) {
				String[] row = new String[rowCount];
				for (int i = 1; i <= rowCount; i++) {
					row[i - 1] = rs.getString(columns.get(i - 1));
				}
				results.add(row);
			}

			String queryType = "Customer genereted most total revenue: ";
			request.setAttribute("columns", columns);
			request.setAttribute("results", results);
			request.setAttribute("querytype", queryType);

			con.close();

			RequestDispatcher rd = request.getRequestDispatcher("mgrQueryResults.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			out.println(e);
			e.printStackTrace();
		}

		response.setContentType("text/html");
	%>

</body>
</html>