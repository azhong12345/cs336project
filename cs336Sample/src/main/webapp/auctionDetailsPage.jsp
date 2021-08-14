<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="endUser.css">
<title>Welcome</title>
</head>

<div class="topnav">
	<a class="active" href="endUser.jsp">Home</a> <a href="addItemPage.jsp">Sell</a>
	<a href="loginPage.jsp">Logout</a>
</div>

<body>
	<%
	// var query = window.location.search.substring(1);
	//var vars = query.split("&");
	//String auctionID = (String)request.getParameter("auctionID");
	//session.setAttribute("auction", auctionID);
	%>
	<br>
	<b>Details for Auction# <%=request.getParameter("id")%>
	</b>

	<br>

	<%
	try { //Get the database connection 
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection(); //Create a SQL statement 
		Statement stmt = con.createStatement();

		session.setAttribute("auctionnum", request.getParameter("id"));

		int itemid = 0;
		String open = "";
		String close = "";
		String price = "";
		String increment = "";
		String name = "";
		String brand = "";
		String gender = "";
		String type = "";
		String size = "N/A";
		String length = "N/A";
		String style = "N/A";
		String bidder = "";

		String num = request.getParameter("id");
		String str1 = "SELECT itemID, username, open_date, close_date, current_price, bid_increment, current_bidder FROM auction WHERE auctionID = '"
		+ num + "'";
		ResultSet rs1 = stmt.executeQuery(str1);

		if (rs1.next()) {
			itemid = rs1.getInt("itemID");
			open = rs1.getString("open_date");
			close = rs1.getString("close_date");
			price = rs1.getString("current_price");
			increment = rs1.getString("bid_increment");
			bidder = rs1.getString("current_bidder");
		}

		String str2 = "SELECT name, gender, brand, type FROM clothing WHERE itemID = '" + itemid + "'";
		ResultSet rs2 = stmt.executeQuery(str2);

		if (rs2.next()) {
			name = rs2.getString("name");
			gender = rs2.getString("gender");
			brand = rs2.getString("brand");
			type = rs2.getString("type");
		}

		if (type.equals("shirt")) {
			String str3 = "SELECT shirt_style, shirt_size FROM shirt WHERE itemID = '" + itemid + "'";
			ResultSet rs3 = stmt.executeQuery(str3);
			if (rs3.next()) {
		size = rs3.getString("shirt_size");
		style = rs3.getString("shirt_style");
			}

		} else if (type.equals("dress")) {
			String str4 = "SELECT dress_length, dress_size FROM dress WHERE itemID = '" + itemid + "'";
			ResultSet rs4 = stmt.executeQuery(str4);
			if (rs4.next()) {
		size = rs4.getString("dress_size");
		length = rs4.getString("dress_length");
			}
		} else if (type.equals("pants")) {
			String str5 = "SELECT pants_style, pants_size FROM pants WHERE itemID = '" + itemid + "'";
			ResultSet rs5 = stmt.executeQuery(str5);
			if (rs5.next()) {
		size = rs5.getString("pants_size");
		style = rs5.getString("pants_style");
			}
		}

		//String str ="SELECT c.name, c.gender, c.brand,  FROM end_view"; 

		//Get the selected radio button from the index.jsp 
		//String entity = request.getParameter("command"); //Make a SELECT query from the table specified by the 'command' parameter at the index.jsp 
		//String str ="SELECT * FROM end_view"; //Run the query against the database.
		//	ResultSet result = stmt.executeQuery(str);
	%>

	<table>

		<tr>
			<td>Item Name:</td>
			<td><%=name%></td>
		</tr>
		<tr>
			<td>Clothing Type:</td>
			<td><%=type%></td>
		</tr>
		<tr>
			<td>Gender:</td>
			<td><%=gender%></td>
		</tr>
		<tr>
			<td>Brand:</td>
			<td><%=brand%></td>
		</tr>
		<tr>
			<td>Size:</td>
			<td><%=size%></td>
		</tr>
		<tr>
			<td>Length:</td>
			<td><%=length%></td>
		</tr>
		<tr>
			<td>Style:</td>
			<td><%=style%></td>
		</tr>
	</table>

	<table>
		<tr>
			<td>Current Bid Price:</td>
			<td><%=price%></td>
		</tr>
		<tr>
			<td>Bidder:</td>
			<td><%=bidder%></td>
		</tr>
		<tr>
			<td>Bid Increment:</td>
			<td><%=increment%></td>

		</tr>
		<tr>
			<td>Closing Date:</td>
			<td><%=close%></td>
		</tr>
	</table>

	<form method="get" action="placeBid.jsp">
		<table>
			<tr>
				<td><input type="radio" id="regular" name="bidtype" value="bid"
					checked> Bid</td>
				<td><input type="radio" id="auto" name="bidtype" value="auto">
					Automatic Bidding</td>
			</tr>


			<tr>
				<td>Price/Maximum Price:</td>
				<td><input type="number" min="0.00" step="0.01" name="bidprice">
				</td>
			</tr>

			<tr>
				<td>Make Bid Anonymous (Hide Username):</td>
				<td><input type="radio" id="notanon" name="isanon"
					value="notanon" checked> No</td>
				<td><input type="radio" id="anon" name="isanon" value="anon">
					Yes</td>
			</tr>

		</table>

		<input type="submit" value="Place Bid">
	</form>

	<%
	} catch (Exception e) {
	out.print(e);
	}
	%>




</body>
</html>