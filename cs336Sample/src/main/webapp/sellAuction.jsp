<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		String initprice = request.getParameter("initprice");
		String increment = request.getParameter("increment");
		String closedate = request.getParameter("closedate");
		String minprice = request.getParameter("minprice");

		int itemID = 0;
		String query = "SELECT MAX(itemID) as maxItem FROM clothing";
		ResultSet rs = stmt.executeQuery(query);

		if (rs.next()) {
			itemID = rs.getInt("maxItem");
		}

		if (initprice.isEmpty() || increment.isEmpty() || minprice.isEmpty() || closedate.isEmpty()) {
			out.println("Please make sure all applicable fields are filled.");
		} else {
			//Make an insert statement for the Auction table:
			String insert = "INSERT INTO auction(itemID, username, open_date, close_date, init_price, bid_increment, min_price, current_price)"
			+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);

			java.util.Date date = new java.util.Date();
			java.text.SimpleDateFormat sdf =   new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			String currentDateTime = sdf.format(date);
			
			//Add parameters of the query.
			ps.setInt(1, itemID);
			ps.setString(2, (String) session.getAttribute("username"));
			ps.setString(3, currentDateTime);
			ps.setString(4, closedate);
			ps.setString(5, initprice);
			ps.setString(6, increment);
			ps.setString(7, minprice);
			ps.setString(8, initprice);

			
			ps.executeUpdate();
			response.sendRedirect("auctionSuccess.jsp");

		}

		/*
		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO clothing(name, gender, brand)" + "VALUES (?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);
		
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, itemName);
		ps.setString(2, gender);
		ps.setString(3, brand);
		//	ps.setString(4, type);
		//	ps.setString(5, initprice);
		//	ps.setString(6, increment);
		//	ps.setString(7, closedate);
		
		//Run the query against the DB
		ps.executeUpdate();
		
		*/

		//Close the connection.
		con.close();

		//out.print("Item has been listed. ");

	} catch (Exception ex) {
		out.println(ex);
		//	out.println("Insert failed :()");
	}
	%>
</body>
</html>