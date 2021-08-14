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
		String current_bidder = "";

		BigDecimal current_price = new BigDecimal("0.00");
		BigDecimal min_price = new BigDecimal("0.00");
		BigDecimal bid_increment = new BigDecimal("0.00");
		BigDecimal secret_max = new BigDecimal("0.00");
		

		if (bidprice.toString().isEmpty()) {
			out.println("Please enter bid amount.");
		} else if (bidprice.compareTo(current_price) <= 0 || bidprice.compareTo(current_price.add(bid_increment)) < 0) { //check if bid is higher than current bid or higher by min increment value
			System.out.println("Please enter value higher than current bid or minimum increment.");
		} else {
			//get the values of auction
			String str1 = "SELECT itemID, current_price, min_price, bid_increment, secret_max, current_bidder FROM auction WHERE auctionID = '" + num
			+ "'";
			ResultSet rs1 = stmt.executeQuery(str1);

			if (rs1.next()) {
				current_price = rs1.getBigDecimal("current_price");
				min_price = rs1.getBigDecimal("min_price");
				bid_increment = rs1.getBigDecimal("bid_increment");
				itemID = rs1.getString("itemID");
				secret_max = rs1.getBigDecimal("secret_max");
				current_bidder = rs1.getString("current_bidder");
			}
			
			//for regular, manual bids:
			if (bidtype.equals("bid")) {
				//first, we check if another bidder has set an automatic bid, and get the secret maximum price if so
				if (secret_max != null){
				
				//if the maximum is greater, then we will place the bid and add it to the table, then immediately 
				//send an alert and place another bid using the default increment
					if (bidprice.compareTo(current_price.add(bid_increment)) > 0 && bidprice.compareTo(secret_max) <= 0) {
					
						//place bid from current user
						String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
						PreparedStatement ps = con.prepareStatement(str3);
						ps.setString(1, (String) session.getAttribute("username"));
						ps.setString(2, num);
						ps.setBigDecimal(3, bidprice);
						ps.setInt(4, 0);
						ps.executeUpdate();
						
						//increment current bid price by default bid increment or the secret maximum, whichever is less:
						if (bidprice.add(bid_increment).compareTo(secret_max) < 0){	
							
							String update = "UPDATE auction SET current_price = '" + bidprice.add(bid_increment)
							+ "' WHERE auctionID = '" + num + "'";
							PreparedStatement ps1 = con.prepareStatement(update);
							ps1.executeUpdate();
							
							String insert = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
							PreparedStatement ps2 = con.prepareStatement(insert);
							ps2.setString(1, current_bidder);
							ps2.setString(2, num);
							ps2.setBigDecimal(3, bidprice.add(bid_increment));
							ps2.setInt(4, 0);
							ps2.executeUpdate();
							
						}else {
							String update = "UPDATE auction SET current_price = '" + secret_max
							+ "' WHERE auctionID = '" + num + "'";
							PreparedStatement ps1 = con.prepareStatement(update);
							ps1.executeUpdate();
							
							String insert = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
							PreparedStatement ps2 = con.prepareStatement(insert);
							ps2.setString(1, current_bidder);
							ps2.setString(2, num);
							ps2.setBigDecimal(3, secret_max);
							ps2.setInt(4, 0);
							ps2.executeUpdate();
							
						}
					
						//alert the current user that they've been outbid
						String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
						PreparedStatement ps1 = con.prepareStatement(alert1);
						ps1.setString(1, (String) session.getAttribute("username"));
						ps1.setString(2, num);
						ps1.setString(3, "You've been outbid! Place another bid or miss out!");
						ps1.setString(4, itemID);
						ps1.setBigDecimal(5, bidprice);
						ps1.executeUpdate();
						
						response.sendRedirect("bidSuccess.jsp");
	
					} else {
						//if the new bid is greater than the secret max, then we will update the highest bid/bidder and set 
						//secret max to null
						//if user is highest bidder, then we update the auction values to the current price
						//first, find the last highest bidder and alert them that they are no longer winning
		
						String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
						PreparedStatement ps1 = con.prepareStatement(alert1);
						ps1.setString(1, current_bidder);
						ps1.setString(2, num);
						ps1.setString(3, "Someone had bid past your upper limit! Place another bid or miss out!");
						ps1.setString(4, itemID);
						ps1.setBigDecimal(5, current_price);
						ps1.executeUpdate();
				
						//update table values
						String str2 = "UPDATE auction SET current_price = '" + bidprice + "' WHERE auctionID = '" + num + "'";
						PreparedStatement ps2 = con.prepareStatement(str2);
						ps2.executeUpdate();
	
						String str4 = "UPDATE auction SET current_bidder = '" + (String) session.getAttribute("username")
								+ "' WHERE auctionID = '" + num + "'";
						PreparedStatement ps0 = con.prepareStatement(str4);
						ps0.executeUpdate();
						
						
						String str5 = "UPDATE auction SET secret_max = NULL WHERE auctionID = '" + num + "'";
						PreparedStatement ps5 = con.prepareStatement(str5);
						ps5.executeUpdate();
		
						String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
						PreparedStatement ps = con.prepareStatement(str3);
						ps.setString(1, (String) session.getAttribute("username"));
						ps.setString(2, num);
						ps.setBigDecimal(3, bidprice);
						ps.setInt(4, 0);
		
						ps.executeUpdate();
						response.sendRedirect("bidSuccess.jsp");
					}
				
				}else{
					
					//if there are no current autobids for the auction, then we will set the new bid and user as the highest bid/bidder for the auction table
					String str2 = "UPDATE auction SET current_price = '" + bidprice + "' WHERE auctionID = '" + num + "'";
					PreparedStatement ps2 = con.prepareStatement(str2);
					ps2.executeUpdate();
	
					//find the last highest bidder and alert them that they are no longer winning
					String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
					PreparedStatement ps1 = con.prepareStatement(alert1);
					ps1.setString(1, current_bidder);
					ps1.setString(2, num);
					ps1.setString(3, "You've been outbid! Place another bid or miss out!");
					ps1.setString(4, itemID);
					ps1.setBigDecimal(5, current_price);

					ps1.executeUpdate();

					//update auction and bid table values
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
				//check if there is pre-existing autobid max price
				if (secret_max != null){
					
					//if the maximum is greater, then we will place the bid at the max price and add it to the table, then immediately 
					//send an alert and place another bid using the default increment
						if (bidprice.compareTo(current_price.add(bid_increment)) > 0 && bidprice.compareTo(secret_max) <= 0) {
						
							//place bid from current user
							String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
							PreparedStatement ps = con.prepareStatement(str3);
							ps.setString(1, (String) session.getAttribute("username"));
							ps.setString(2, num);
							ps.setBigDecimal(3, bidprice);
							ps.setInt(4, 0);
							ps.executeUpdate();
							
							//increment current bid price by default bid increment or the secret maximum, whichever is less:
							if (bidprice.add(bid_increment).compareTo(secret_max) < 0){	
								
								String update = "UPDATE auction SET current_price = '" + bidprice.add(bid_increment)
								+ "' WHERE auctionID = '" + num + "'";
								PreparedStatement ps1 = con.prepareStatement(update);
								ps1.executeUpdate();
								
								String insert = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
								PreparedStatement ps2 = con.prepareStatement(insert);
								ps2.setString(1, current_bidder);
								ps2.setString(2, num);
								ps2.setBigDecimal(3, bidprice.add(bid_increment));
								ps2.setInt(4, 0);
								ps2.executeUpdate();
								
							}else {
								String update = "UPDATE auction SET current_price = '" + secret_max
								+ "' WHERE auctionID = '" + num + "'";
								PreparedStatement ps1 = con.prepareStatement(update);
								ps1.executeUpdate();
								
								String insert = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
								PreparedStatement ps2 = con.prepareStatement(insert);
								ps2.setString(1, current_bidder);
								ps2.setString(2, num);
								ps2.setBigDecimal(3, secret_max);
								ps2.setInt(4, 0);
								ps2.executeUpdate();
								
							}
						
							//alert the current user that they've been outbid
							String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
							PreparedStatement ps1 = con.prepareStatement(alert1);
							ps1.setString(1, (String) session.getAttribute("username"));
							ps1.setString(2, num);
							ps1.setString(3, "You've been outbid! Place another bid or miss out!");
							ps1.setString(4, itemID);
							ps1.setBigDecimal(5, bidprice);
							ps1.executeUpdate();
							
							response.sendRedirect("bidSuccess.jsp");
		
						} else {
							//if the new maximum bid is greater than the secret max, then we will update the highest bid/bidder and set 
							//secret max to the new bid
							
							//place a bid for the previous bidder's maximum price
							String insert = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
							PreparedStatement ps3 = con.prepareStatement(insert);
							ps3.setString(1, current_bidder);
							ps3.setString(2, num);
							ps3.setBigDecimal(3, secret_max);
							ps3.setInt(4, 0);
			
							ps3.executeUpdate();
							
						
							//alert the previous highest bidder that their maximum price has been beat
							String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
							PreparedStatement ps1 = con.prepareStatement(alert1);
							ps1.setString(1, current_bidder);
							ps1.setString(2, num);
							ps1.setString(3, "Someone had bid past your upper limit! Place another bid or miss out!");
							ps1.setString(4, itemID);
							ps1.setBigDecimal(5, current_price);
							ps1.executeUpdate();
					
							//update table values for new highest bid/bidder
							String str2 = "UPDATE auction SET current_price = '" + current_price.add(bid_increment) + "' WHERE auctionID = '" + num + "'";
							PreparedStatement ps2 = con.prepareStatement(str2);
							ps2.executeUpdate();
		
							String str4 = "UPDATE auction SET current_bidder = '" + (String) session.getAttribute("username")
									+ "' WHERE auctionID = '" + num + "'";
							PreparedStatement ps0 = con.prepareStatement(str4);
							ps0.executeUpdate();
							
							String str5 = "UPDATE auction SET secret_max = '" + bidprice + "' WHERE auctionID = '" + num + "'";
							PreparedStatement ps5 = con.prepareStatement(str5);
							ps5.executeUpdate();
			
							//increase current bid price by the default increment
							String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
							PreparedStatement ps = con.prepareStatement(str3);
							ps.setString(1, (String) session.getAttribute("username"));
							ps.setString(2, num);
							ps.setBigDecimal(3, current_price.add(bid_increment));
							ps.setInt(4, 0);
			
							ps.executeUpdate();
							response.sendRedirect("bidSuccess.jsp");
						}
					
				}else{
						
						//if there are no current autobids for the auction, then we will set the new bid and user as the highest bid/bidder for the auction table
						//increment current price by default increment and set as current bid price
						String str2 = "UPDATE auction SET current_price = '" + current_price.add(bid_increment)
								+ "' WHERE auctionID = '" + num + "'";
						PreparedStatement ps2 = con.prepareStatement(str2);
						ps2.executeUpdate();
		
						//set the secret maximum price
						String str3 = "UPDATE auction SET secret_max = '" + bidprice + "' WHERE auctionID = '" + num + "'";
						PreparedStatement ps3 = con.prepareStatement(str3);
						ps3.executeUpdate();
		
						//find the last highest bidder and alert them that they are no longer winning 
		
						String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
						PreparedStatement ps1 = con.prepareStatement(alert1);
						ps1.setString(1, current_bidder);
						ps1.setString(2, num);
						ps1.setString(3, "You've been outbid! Place another bid or miss out!");
						ps1.setString(4, itemID);
						ps1.setBigDecimal(5, current_price);
	
						ps1.executeUpdate();
						
							
						//update auction values and insert bid details into table
						String str4 = "UPDATE auction SET current_bidder = '" + (String) session.getAttribute("username")
								+ "' WHERE auctionID = '" + num + "'";
						PreparedStatement ps0 = con.prepareStatement(str4);
						ps0.executeUpdate();
	
						String str6 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
						PreparedStatement ps = con.prepareStatement(str6);
						ps.setString(1, (String) session.getAttribute("username"));
						ps.setString(2, num);
						ps.setBigDecimal(3, bidprice);
						ps.setInt(4, 0);
	
						ps.executeUpdate();
						response.sendRedirect("bidSuccess.jsp");
					}			
			}
		}
		//Close the connection.
		con.close();

	} catch (Exception ex) {
		out.println(ex);
		//	out.println("Insert failed :()");
	}
	%>	
	
			
			

		<% 
		/*	
			
			//check if someone has place an autobid and get value of the maximum price
			if (secret_max != null){
				
				//if the maximum is greater, then we will place the bid and add it to the table, then immediately 
				//send an alert and place another bid using the default increment
				if (bidprice.compareTo(current_price.add(bid_increment)) > 0 && bidprice.compareTo(secret_max) <= 0) {
					
					String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
					PreparedStatement ps = con.prepareStatement(str3);
					ps.setString(1, (String) session.getAttribute("username"));
					ps.setString(2, num);
					ps.setBigDecimal(3, bidprice);
					ps.setInt(4, 0);
					ps.executeUpdate();
					
					String str2 = "UPDATE auction SET current_price = '" + bidprice.add(bid_increment)
					+ "' WHERE auctionID = '" + num + "'";
					PreparedStatement ps2 = con.prepareStatement(str2);
					ps2.executeUpdate();
					
					String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
					PreparedStatement ps = con.prepareStatement(str3);
					ps.setString(1, current_bidder);
					ps.setString(2, num);
					ps.setBigDecimal(3, bidprice.add(bid_increment));
					ps.setInt(4, 0);
					ps.executeUpdate();
					
					
					String alert1 = "INSERT INTO alerts(username, auctionID, message, itemID, bid_price) VALUES(?,?,?,?, ?)";
					PreparedStatement ps1 = con.prepareStatement(alert1);
					ps1.setString(1, (String) rs5.getString("current_bidder"));
					ps1.setString(2, num);
					ps1.setString(3, "You've been outbid! Place another bid or miss out!");
					ps1.setString(4, itemID);
					ps1.setBigDecimal(5, current_price);

					ps1.executeUpdate();
					
					
					response.sendRedirect("bidSuccess.jsp");
				
				} else {
					//if the new bid is greater than the secret max, then we will update the high bid/bidder and set 
					//secret max to null
					//if user is highest bidder, then we update the auction values to the current price
			//first, find the last highest bidder and alert them that they are no longer winning
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
			
			//update table values
			String str2 = "UPDATE auction SET current_price = '" + bidprice + "' WHERE auctionID = '" + num + "'";
			PreparedStatement ps2 = con.prepareStatement(str2);
			ps2.executeUpdate();

				String str4 = "UPDATE auction SET current_bidder = '" + (String) session.getAttribute("username")
						+ "' WHERE auctionID = '" + num + "'";
				PreparedStatement ps0 = con.prepareStatement(str4);
				ps0.executeUpdate();
				
				
				String str5 = "UPDATE auction SET secret_max = NULL WHERE auctionID = '" + num + "'";
				PreparedStatement ps5 = con.prepareStatement(str5);
				ps5.executeUpdate();

				String str3 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
				PreparedStatement ps = con.prepareStatement(str3);
				ps.setString(1, (String) session.getAttribute("username"));
				ps.setString(2, num);
				ps.setBigDecimal(3, bidprice);
				ps.setInt(4, 0);

				ps.executeUpdate();
				response.sendRedirect("bidSuccess.jsp");
			}
					
			}else{
				
			
			
			//check if new bid is higher than current highest bid
			if (bidprice.compareTo(current_price) <= 0 || bidprice.compareTo(current_price.add(bid_increment)) < 0) {
		System.out.println("Please enter value higher than current bid or minimum increment.");
			} else {

		//for regular bids
		if (bidtype.equals("bid")) {
			
			//if user is highest bidder, then we update the auction values to the current price
			String str2 = "UPDATE auction SET current_price = '" + bidprice + "' WHERE auctionID = '" + num + "'";
			PreparedStatement ps2 = con.prepareStatement(str2);
			ps2.executeUpdate();

			//find the last highest bidder and alert them that they are no longer winning
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
			//increment current price by default increment and set as current bid price
			String str2 = "UPDATE auction SET current_price = '" + current_price.add(bid_increment)
					+ "' WHERE auctionID = '" + num + "'";
			PreparedStatement ps2 = con.prepareStatement(str2);
			ps2.executeUpdate();

			//set the secret maximum price
			String str3 = "UPDATE auction SET secret_max = '" + bidprice + "' WHERE auctionID = '" + num + "'";
			PreparedStatement ps3 = con.prepareStatement(str3);
			ps3.executeUpdate();

			//find the last highest bidder and alert them that they are no longer winning 
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
				//set the name of highest bidder to 'anonymous'
				String str4 = "UPDATE auction SET current_bidder = 'ANONYMOUS' WHERE auctionID = '" + num + "'";
				PreparedStatement ps0 = con.prepareStatement(str4);
				ps0.executeUpdate();

				//insert bid details into table
				String str6 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
				PreparedStatement ps = con.prepareStatement(str6);
				ps.setString(1, (String) session.getAttribute("username"));
				ps.setString(2, num);
				ps.setBigDecimal(3, bidprice);
				ps.setInt(4, 1);

				ps.executeUpdate();
				response.sendRedirect("bidSuccess.jsp");

			} else {
				
				//update auction values and insert bid details into table
				String str4 = "UPDATE auction SET current_bidder = '" + (String) session.getAttribute("username")
						+ "' WHERE auctionID = '" + num + "'";
				PreparedStatement ps0 = con.prepareStatement(str4);
				ps0.executeUpdate();

				String str6 = "INSERT INTO bid(username, auctionID, price, is_anon) VALUES (?,?,?,?)";
				PreparedStatement ps = con.prepareStatement(str6);
				ps.setString(1, (String) session.getAttribute("username"));
				ps.setString(2, num);
				ps.setBigDecimal(3, bidprice);
				ps.setInt(4, 0);

				ps.executeUpdate();
				response.sendRedirect("bidSuccess.jsp");

			}
			

		}

			}

		}
		
		*/
		%>	

</body>
</html>