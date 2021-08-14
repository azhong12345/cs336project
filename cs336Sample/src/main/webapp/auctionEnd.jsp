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
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//get details for auction
		String num = (String)session.getAttribute("auctionnum");
				
		int itemid = 0;
		BigDecimal bidprice = new BigDecimal("0.00");
		BigDecimal minprice = new BigDecimal("0.00");
		
		String seller = "";
		String bidder = "";
				
		String str1 = "SELECT itemID, username, min_price, current_price, current_bidder FROM auction WHERE auctionID = '"
		+ num + "'";
		ResultSet rs1 = stmt.executeQuery(str1);

		if (rs1.next()) {
			itemid = rs1.getInt("itemID");
			seller = rs1.getString("username");
			bidprice = rs1.getBigDecimal("current_price");
			minprice = rs1.getBigDecimal("min_price");
			bidder = rs1.getString("current_bidder");
		}
		
		//check whether final bid price is higher than the seller's minimum reserve price
		if (bidprice.compareTo(minprice) > 0){
			//if bid is higher than min, then alert buyer that they've won the auction
			String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
			PreparedStatement ps1 = con.prepareStatement(alert1);
			ps1.setString(1, bidder);
			ps1.setString(2, num);
			ps1.setString(3, "Congratulations, you've won the auction!");
			ps1.setInt(4, itemid);
			ps1.setBigDecimal(5, bidprice);
			ps1.executeUpdate();
			
		}else{
			//if bid is not higher than min, they alert buyer that they've lost
			String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
			PreparedStatement ps1 = con.prepareStatement(alert1);
			ps1.setString(1, bidder);
			ps1.setString(2, num);
			ps1.setString(3, "Unfortunately, the bid has not reached seller's minimum price. Better luck next time!");
			ps1.setInt(4, itemid);
			ps1.setBigDecimal(5, bidprice);
			ps1.executeUpdate();
		}
		
		
	} catch (Exception ex) {
		out.println(ex);
	}
%>
</body>
</html>