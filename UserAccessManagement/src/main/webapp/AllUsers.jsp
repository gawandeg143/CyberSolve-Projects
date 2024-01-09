<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="Pojos.Users" %>
<%@page import="services.UserServices"%>
<%@page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>All Users</title>
<script>
	function removeUser(slctdUsr, utype)
	{
		console.log(slctdUsr);
		document.getElementById('rmv_user').value = slctdUsr;
		document.getElementById('usrType').value = utype;
		document.getElementById('hiddenSubmitButton').click();
	}
</script>
<style>

	.container{
		width: 98%;
		margin: 80px auto;
		text-align: center;
		font-size: 19px;
	}
	#close_btn{
		text-decoration: none;
		font-size: 20px;
		padding: 3px 20px;
		border: 1px solid black;
		border-radius: 3px;
		color: black;
	}
	table{
		width: 90%;
		padding: 10px;
	}
	table th{
		text-align: left;
	}
	table, tr{
		border: 1px solid black;
	}
	input{
		border: none;
		font-size: 16px;
		padding: 5px 2px;
	}
	#rmv_btn{
		font-size: 17px;
		padding: 3px 7px;
	}
</style>
</head>
<%
UserServices us = new UserServices();
List<Users> al1 = us.getAllUserDetails();
%>
<body><br>
	<div class="container">
	
		<form action="/UserAccessManagement/app/user/remove" method="post">
		
			<table>
				<tr>
					<th>First Name</th>
           			<th>Last Name</th>
           			<th>Email</th>
           			<th>Username</th>
           			<th>User Type</th>
           			<th>Manager</th>
           			<th>Registered On</th>
           			<th></th>
				</tr>
				
				<%for(Users u :al1){ %>
					<tr>
                 		<td colspan="8"><hr></td>
                 	</tr>
                 	<tr>
                 		<td><input type="text" name="fnm" value="<%=u.getFirstName() %>" readonly></td>
                 		<td><input type="text" name="lnm" value="<%=u.getLastName() %>" readonly></td>
                 		<td><input type="text" name="eml" value="<%=u.getEmail() %>" readonly></td>
                 		<td><input type="text" name="unm" value="<%=u.getUserName() %>" readonly></td>
                 		<td><input type="text" name="utype" value="<%=u.getUserType() %>" readonly></td>
                 		<td><input type="text" name="mngr" value="<%=u.getManager() %>" readonly></td>
                 		<td><input type="text" name="regDate" value="<%=u.getRegistration_date() %>" readonly></td>
                 		<td><button id="rmv_btn" type="button" onclick="removeUser('<%=u.getUserName()%>', '<%=u.getUserType()%>')">Remove</button></td>
                 	</tr>
				<%} %>
			</table>
			<input type="hidden" name="rmv_user" id="rmv_user" value="">
			<input type="hidden" name="usrType" id="usrType" value="">
			<button type="submit" style="display:none;" id="hiddenSubmitButton"></button>
		</form><br><br>
		<a id="close_btn" href="admin.jsp">Close</a>
	</div>
</body>
</html>