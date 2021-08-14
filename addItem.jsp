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

		String itemName = request.getParameter("name");
		String brand = request.getParameter("brand");
		String gender = request.getParameter("gender");
		String type = request.getParameter("type");

		String dsize = request.getParameter("dsize");
		String dlength = request.getParameter("dlength");
		String ssize = request.getParameter("ssize");
		String sstyle = request.getParameter("sstyle");
		String psize = request.getParameter("psize");
		String pstyle = request.getParameter("pstyle");

		String initprice = request.getParameter("initprice");
		String increment = request.getParameter("increment");
		String closedate = request.getParameter("closedate");
		String minprice = request.getParameter("minprice");

	
		
		if (itemName.isEmpty() || brand.isEmpty()) {
			out.println("Please make sure all fields are filled.");

		} else {
			//Make an insert statement for the Clothing table:
			String insert = "INSERT INTO clothing(name, gender, brand, type)" + "VALUES (?, ?, ?, ?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(insert);

			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, itemName);
			ps.setString(2, gender);
			ps.setString(3, brand);
			ps.setString(4, type);
			
			ps.executeUpdate();
		}

		
		int itemID = 0;
		String query = "SELECT MAX(itemID) as maxItem FROM clothing";
		ResultSet rs = stmt.executeQuery(query);

		if(rs.next()){
		     itemID = rs.getInt("maxItem");
		}
		
		
		if (type.equals("dress")) {
			if (dsize.isEmpty() || dlength.isEmpty()) {
		out.println("Please make sure all applicable fields are filled.");
			} else {
				//Make an insert statement for the Dress table:
				String insert = "INSERT INTO dress(itemID, dress_size, dress_length)" + "VALUES (?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query.
				ps.setInt(1, itemID);
				ps.setString(2, dsize);
				ps.setString(3, dlength);
				
				ps.executeUpdate();
				
			}
		} else if (type.equals("shirt")) {
			if (ssize.isEmpty() || sstyle.isEmpty()) {
		out.println("Please make sure all applicable fields are filled.");
			} else {
				//Make an insert statement for the Shirt table:
				String insert = "INSERT INTO shirt(itemID, shirt_size, shirt_style)" + "VALUES (?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query.
				ps.setInt(1, itemID);
				ps.setString(2, ssize);
				ps.setString(3, sstyle);
				
				ps.executeUpdate();
				
			}
		} else if (type.equals("pants")) {
			if (ssize.isEmpty() || sstyle.isEmpty()) {
		out.println("Please make sure all applicable fields are filled.");
			} else {
				//Make an insert statement for the Pants table:
				String insert = "INSERT INTO pants(itemID, pants_size, pants_style)" + "VALUES (?, ?, ?)";
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query.
				ps.setInt(1, itemID);
				ps.setString(2, psize);
				ps.setString(3, pstyle);
				
				ps.executeUpdate();
				
			}
		}
		response.sendRedirect("sellAuctionPage.jsp");

		
		//Close the connection.
		con.close();

		//out.print("Item has been listed. ");

	} catch (Exception ex) {
		out.println(ex);
		//	out.println("Insert failed :()");
	}
	%>
</body>
</html>