<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<style>
input[type=submit] {
    padding:10px 20px; 
    background:#ccc; 
    border: 2px black;
    font-size: 15px;
    font-family: arial;
    border-radius: 5px; 
}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="endUser.css">
<title>Sell an Item</title>
</head>

<div class="topnav">
	<a class="active" href="endUser.jsp">Home</a> <a href="addItemPage.jsp">Sell</a>
	<a href="loginPage.jsp">Logout</a>
</div>
<body>
	<p>Confirm Auction Details </p>
	<form method="get" action="sellAuction.jsp">
		<table>
			
			<tr>
				<td>Initial Price</td>
				<td><input type="number" min="0.00" step="0.01" name="initprice"></td>
			</tr>
			
			<tr>
				<td>Minimum Price</td>
				<td><input type="number" min="0.00" step="0.01"  name="minprice"></td>
			</tr>
			<tr>
				<td>Bid Increment</td>
				<td><input type="number" min="0.00" step="0.01"  name="increment"></td>
			</tr>
			<tr>
				<td>Closing Date</td>
				<td><input type="text" name="closedate"></td>
			</tr>

			
		</table>
		<input type="submit" value="Create Auction">
	</form>
</body>
</html>

<script>
  $(function () {
    $('#datetimepicker1').datetimepicker();
 });
</script>