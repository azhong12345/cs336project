<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<link rel="stylesheet" type="text/css" href="endUser.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Login to BuyMe</title>
</head>

<body>

	<%
	
	session.setAttribute("isLoggedIn", false);
	%>

	<br> 
	<b>Welcome to BuyMe! Please sign in to your account to get
	started. </b>
	<br>
	<br>

	<form method="get" action="siteLogin.jsp">
		<table>
			<tr>
				<td>Username</td>
				<td><input type="text" name="username"></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="text" name="password"></td>
			</tr>
		</table>
		<br> <input type="submit" value="Login">
	</form>
	<br>
	<a href="createAccountPage.jsp"> <input type="submit"
		value="Create New Account" />
	</a>
	<br>

</body>
</html>