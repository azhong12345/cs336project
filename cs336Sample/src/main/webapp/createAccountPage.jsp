<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create New Account</title>
	</head>
	
	<body>
	
	<form method="get" action="createAccount.jsp">
			<table>
				<tr>    
					<td>Name</td><td><input type="text" name="name"></td>
				</tr>
				<tr>    
					<td>Email</td><td><input type="text" name="email"></td>
				</tr>
				<tr>    
					<td>Address</td><td><input type="text" name="address"></td>
				</tr>
				<tr>    
					<td>Username</td><td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password</td><td><input type="text" name="password"></td>
				</tr>
				
			</table>
			<input type="submit" value="Create New Account">
		</form>

</body>
</html>