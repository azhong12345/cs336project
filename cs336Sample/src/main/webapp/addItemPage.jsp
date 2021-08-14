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
	<h3>What are you selling today? </h3>
	<form method="get" action="addItem.jsp">
		<table>
			<tr>
				<td>Item Name</td>
				<td><input type="text" name="name"></td>
			</tr>
			<tr>
				<td>Brand</td>
				<td><input type="text" name="brand"></td>
			</tr>
			<tr>
				<td>Gender</td>
				<td><select name="gender" id="gender">
					<option value="men">Men</option>
					<option value="women">Women</option>
					<option value="unisex">Unisex</option>
					</select>
				</td>
			</tr>
			

			<tr>
				<td>Clothing Type</td>
				<td><select name="type" id="type">
					<option value="dress">Dress</option>
					<option value="shirt">Shirt</option>
					<option value="pants">Pants</option>

				</select>
				</td>
			</tr>
			
			<tr>
				<td>Dress Size (if applicable)</td>
				<td><select name="dsize" id="dsize">
					<option value="00">00</option>
					<option value="0">0</option>
					<option value="2">2</option>
					<option value="4">4</option>
					<option value="6">6</option>
					<option value="8">8</option>
					<option value="10">10</option>
					<option value="12">12</option>
					<option value="14">14</option>
					<option value="16">16</option>
					<option value="18">18</option>
					<option value="20">20</option>

				</select>
				</td>
			</tr>
			<tr>
				<td>Dress Length in inches(if applicable)</td>
				<td><input type="number" name="dlength"> </td>
			</tr> 
			
				<tr>
				<td>Shirt Size (if applicable)</td>
				<td><select name="ssize" id="ssize">
					<option value="XS">XS</option>
					<option value="S">S</option>
					<option value="M">M</option>
					<option value="L">L</option>
					<option value="XL">XL</option>

				</select>
				</td>
			</tr>
			<tr>
				<td>Shirt Style (if applicable)</td>
				<td><select name="sstyle" id="sstyle">
					<option value="tank">Tank Top</option>
					<option value="blouse">Blouse</option>
					<option value="sweater">Sweater</option>
					<option value="tee">T-shirt</option>
					<option value="vest">Vest</option>
					<option value="dress">Dress Shirt</option>

				</select>
				</td>
			</tr> 
			<tr>
				<td>Pants Size (if applicable)</td>
				<td><select name="psize" id="psize">
					<option value="25">25"</option>
					<option value="26">26"</option>
					<option value="27">27"</option>
					<option value="28">28"</option>
					<option value="29">29"</option>
					<option value="30">30"</option>
					<option value="31">31"</option>
					<option value="32">32"</option>
					<option value="33">33"</option>
					<option value="34">34"</option>
					<option value="35">35"</option>
					<option value="36">36"</option>
					<option value="37">37"</option>

				</select>
				</td>
			</tr>
			<tr>
				<td>Pants Style (if applicable)</td>
				<td><select name="pstyle" id="pstyle">
					<option value="shorts">Shorts</option>
					<option value="jeans">Jeans</option>
					<option value="leggings">Leggings</option>
					<option value="formal">Formal</option>
					<option value="active">Active</option>

				</select>
				</td>
			</tr> 
			
			</table>
			<input type="submit" value="Next">
			</form>
			
</body>
</html>