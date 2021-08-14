<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 70%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" >
<link rel="stylesheet" type="text/css" href="endUser.css">
<title>Welcome</title>
</head>

<div class="topnav">
	<a class="active" href="endUser.jsp">Home</a> <a href="addItemPage.jsp">Sell</a>
	<a href="loginPage.jsp">Logout</a>
</div>

<body>

<br>
	Welcome back, ${username}! 
	Browse for items or bid on open auctions.
	
	<br>
	<br>


	<%
try { //Get the database connection 
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection(); //Create a SQL statement 
	Statement stmt = con.createStatement();

	//Get the selected radio button from the index.jsp 
	//String entity = request.getParameter("command"); //Make a SELECT query from the table specified by the 'command' parameter at the index.jsp 
	String str = "SELECT * FROM end_view"; //Run the query against the database.
	ResultSet result = stmt.executeQuery(str);
%>

	<!--  Make an HTML table to show the results in: -->
	<table class = "center">
		<caption style="font-weight: bold">Current Open Auctions:</caption>
		<tr>
			<th>Name</th>
			<th>Gender</th>
			<th>Brand</th>
			<th>Current Bid Price</th>
			<th>Seller</th>

		</tr>
		<%
		//parse out the results
		while (result.next()) {
			session.setAttribute("auctionID", result.getString("auctionID"));
		%>

		<tr>

			<td><a href="auctionDetailsPage.jsp?id=${auctionID}"><%=result.getString("name")%></a></td>
			<td><a href="auctionDetailsPage.jsp?id=${auctionID}"><%=result.getString("gender")%></a></td>
			<td><a href="auctionDetailsPage.jsp?id=${auctionID}"><%=result.getString("brand")%></a></td>
			<td><a href="auctionDetailsPage.jsp?id=${auctionID}"><%=result.getString("current_price")%></a></td>
			<td><%=result.getString("username")%></td>

		</tr>


		<%
		}
		%>
	</table>
	<br>

	<%
	String str2 = "SELECT * FROM alerts WHERE username = '" + session.getAttribute("username") + "'"; //Run the query against the database.
	ResultSet result2 = stmt.executeQuery(str2);
	%>

	<table class='center'>
		<caption style="font-weight: bold">My Alerts</caption>
		<tr>
			<th>Item</th>
			<th>Auction</th>
			<th>Message</th>

		</tr>
		<%
		while (result2.next()) {
			//session.setAttribute("auctionID", result.getString("auctionID"));
		%>

		<tr>
			<td><%=result2.getString("itemID")%></td>
			<td><a href="auctionDetailsPage.jsp?id=<%=result2.getString("auctionID")%>"><%=result2.getString("auctionID")%></a></td>
			<td><%=result2.getString("message")%></td>


		</tr>
		<%
		}
		%>
	</table>

	<%
	//close the connection.
	db.closeConnection(con);
	%>
	<%
	} catch (Exception e) {
	out.print(e);
	}
	%>



</body>
</html>