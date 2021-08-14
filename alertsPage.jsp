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

	Welcome back, ${username}.


	<%
try { //Get the database connection 
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection(); //Create a SQL statement 
	Statement stmt = con.createStatement();

	
	String str2 = "SELECT * FROM alerts WHERE username = '" + session.getAttribute("username") + "'"; //Run the query against the database.
	ResultSet result2 = stmt.executeQuery(str2);
	
	%>

	<table>
		<caption style="font-weight: bold">My Alerts</caption>
		<%
		while (result2.next()) {
			//session.setAttribute("auctionID", result.getString("auctionID"));
		%>

		<tr>
			<td><%=result2.getString("itemID")%></td>
			<td><%=result2.getString("auctionID")%></td>
			<td><%=result2.getString("message")%></td>


		</tr>
		<%
		}
		//close the connection.
		db.closeConnection(con);
		%>
	</table>

	<%
	
	%>
	<%
	} catch (Exception e) {
	out.print(e);
	}
	%>



</body>
</html>