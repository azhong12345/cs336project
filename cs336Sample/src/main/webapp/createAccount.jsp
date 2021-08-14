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

		//Get parameters from the HTML form at the createAccount.jsp
		String newName = request.getParameter("name");
		String newEmail = request.getParameter("email");
		String newAddress = request.getParameter("address");
		String newUser = request.getParameter("username");
		String newPassword = request.getParameter("password");

		if (newName.isEmpty()|| newEmail.isEmpty()|| newAddress.isEmpty() || newUser.isEmpty() || newPassword.isEmpty() ){
			out.println("Please make sure all fields are filled.");
		
		}else{
		
		String userType = "end";
		
		String checkUser = "SELECT EXISTS(SELECT * from user WHERE username = '" + newUser + "') exist";
		ResultSet result1 = stmt.executeQuery(checkUser);
		int exists = 0;
		while(result1.next()){
	        exists = result1.getInt("exist");
	    }
		if (exists == 1){
			out.print("Username is taken. Please enter different username.");
			throw new Exception();
		}
		
		String str = "SELECT COUNT(*) FROM user";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		int numberRow = 0;
		while(result.next()){
	        numberRow = result.getInt("COUNT(*)");
	    }
		
		String insert = "INSERT INTO user(name, email, address, username, password, type)"
				+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, newName);
		ps.setString(2, newEmail);
		ps.setString(3, newAddress);
		ps.setString(4, newUser);
		ps.setString(5, newPassword);
		ps.setString(6, userType);
		
		//Run the query against the DB
		ps.executeUpdate();

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		session.setAttribute("username", newUser);
		session.setAttribute("usertype", "end");
		response.sendRedirect("endUser.jsp");
		}
		
	} catch (Exception ex) {
		out.println(ex);
	}
%>
</body>
</html>