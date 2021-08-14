<%@page import="java.math.BigDecimal"%>
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
	<p></p>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		String bidtype = request.getParameter("bidtype");
		BigDecimal bidprice = new BigDecimal(request.getParameter("bidprice"));
		String num = (String) session.getAttribute("auctionnum");
		String isanon = request.getParameter("isanon");
		
		String itemID = "";

		BigDecimal current_price = new BigDecimal("0.00");
		BigDecimal min_price = new BigDecimal("0.00");
		BigDecimal bid_increment = new BigDecimal("0.00");

		if (bidprice.toString().isEmpty()) {
			out.println("Please enter bid amount.");
		} else {
			//check if new bid is higher than current highest bid
			String str1 = "SELECT itemID, current_price, min_price, bid_increment FROM auction WHERE auctionID = '" + num + "'";
			ResultSet rs1 = stmt.executeQuery(str1);

			if (rs1.next()) {
		current_price = rs1.getBigDecimal("current_price");
		min_price = rs1.getBigDecimal("min_price");
		bid_increment = rs1.getBigDecimal("bid_increment");
		itemID = rs1.getString("itemID");

			}
			if (bidprice.compareTo(current_price) <= 0 || bidprice.compareTo(current_price.add(bid_increment)) < 0) {
		System.out.println("Please enter value higher than current bid or minimum increment.");
			} else {

		//for regular bids
		if (bidtype.equals("bid")) {
			String str2 = "UPDATE auction SET current_price = '" + bidprice + "' WHERE auctionID = '" + num + "'";
			PreparedStatement ps2 = con.prepareStatement(str2);

			ps2.executeUpdate();

			String str5 = "SELECT current_bidder FROM auction WHERE auctionID = '" + num + "'";
			ResultSet rs5 = stmt.executeQuery(str5);

			if (rs5.next()) {
				
				String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
				PreparedStatement ps1 = con.prepareStatement(alert1);
				ps1.setString(1, (String) rs5.getString("current_bidder"));
				ps1.setString(2, num);
				ps1.setString(3, "You've been outbid! Place another bid or miss out!");
				ps1.setString(4, itemID);
				ps1.setBigDecimal(5, current_price);

				ps1.executeUpdate();
			}

			if (isanon.equals("yes")) {
				String str4 = "UPDATE auction SET current_bidder = 'ANONYMOUS' WHERE auctionID = '" + num + "'";
				PreparedStatement ps0 = con.prepareStatement(str4);
				ps0.executeUpdate();
				
				
				String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
				PreparedStatement ps = con.prepareStatement(str3);
				ps.setString(1, (String) session.getAttribute("username"));
				ps.setString(2, num);
				ps.setBigDecimal(3, bidprice);
				ps.setInt(4, 1);

				ps.executeUpdate();
				response.sendRedirect("bidSuccess.jsp");


			} else {
				String str4 = "UPDATE auction SET current_bidder = '" + (String) session.getAttribute("username")
						+ "' WHERE auctionID = '" + num + "'";
				PreparedStatement ps0 = con.prepareStatement(str4);
				ps0.executeUpdate();
				
				String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
				PreparedStatement ps = con.prepareStatement(str3);
				ps.setString(1, (String) session.getAttribute("username"));
				ps.setString(2, num);
				ps.setBigDecimal(3, bidprice);
				ps.setInt(4, 0);

				ps.executeUpdate();
				response.sendRedirect("bidSuccess.jsp");


			}

		} else if (bidtype.equals("auto")) {

		}

			}

		}

		//Close the connection.
		con.close();

		//out.print("Item has been listed. ");

	} catch (

	Exception ex) {
		out.println(ex);
		//	out.println("Insert failed :()");
	}
	%>
</body>
</html>