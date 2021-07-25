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

		//Get parameters from the HTML form at the HelloWorld.jsp
		String newUser = request.getParameter("username");
		String newPassword = request.getParameter("password");
	
		String checkUser = "SELECT EXISTS(SELECT * from user WHERE username = '" + newUser + "' and password = '" + newPassword + "') exist";
		ResultSet result1 = stmt.executeQuery(checkUser);
		int exists = 0;
		while(result1.next()){
	        exists = result1.getInt("exist");
	    }
		if (exists == 1){ //username and password are correct. user has successfully logged in.
		
			String getName = "SELECT name FROM user WHERE username = '" + newUser + "' and password = '" + newPassword + "'";
			ResultSet result2 = stmt.executeQuery(getName);
			while(result2.next()){
		        out.println("Welcome back, "+ result2.getString("name") + ". ");
		    }
			
		}else if (exists == 0){ //username doesn't match password. prompts user to enter new credentials.
			out.println("Username or password is incorrect. Please try again.");
		}
		
		

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		
	} catch (Exception ex) {
		out.println(ex);
		
	}
%>

<br>
<br>
<a href="loginPage.jsp">
       <input type="submit" value= "Logout"/>
       
</body>
</html>