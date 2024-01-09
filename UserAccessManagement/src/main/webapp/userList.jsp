<%@page import="services.UserServices"%>
<%@page import="services.RequestServices"%>
<%@page import="Pojos.Users" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Users List</title>
<style>
    .container{
        width: 70%;
        margin: 100px auto;
        font-family: sans-serif;
    }
    #dbtn{
        width: 30%;
        margin: auto;
    }
    div button{
        width: 60%;
        margin: 30px auto;
        font-size: 18px;
        padding: 4px 20px;
    }
    table th{
    	font-size: 24px;
    }
    table td{
    	padding: 15px 50px;
    	font-size: 20px;
    }
</style>
</head>
<body>
<%
 HttpSession ssn1 = request.getSession(false);
 String resource = (String)ssn1.getAttribute("Resource_Users");
 if(resource==null || "select".equals(resource) || resource.isEmpty())
 {
	 %>
	 <script>
	 window.confirm('!! Choose appropriate option !!'); 
	 window.location.href='/UserAccessManagement/admin.jsp';
	 </script>
	 <%
 }
 else{
  RequestServices rqstMdl = new RequestServices();
 List<Users> al = rqstMdl.getAllUsersByResource(resource);
%>

	<div class="container">
	<h2>Resource : <%=resource %></h2>
	
	<%try{
		
		if(al.isEmpty() || al==null){%> 
		
		<label>No Users with selected Resource</label>
		 
		<%}
		else{ %>
		<table cellpadding="10">
    	<tr>
           <th>First Name</th>
           <th>Last Name</th>
           <th>Email</th>
           <th>Username</th>
           <th>User Type</th>
        </tr>
                 	<%for(Users u :al){ %>
                 	<tr>
                 		<td><%=u.getFirstName() %></td>
                 		<td><%=u.getLastName() %></td>
                 		<td><%=u.getEmail() %></td>
                 		<td><%=u.getUserName() %></td>
                 		<td><%=u.getUserType() %></td>
                 	</tr>
                 	<%} } }catch(Exception e){} }%>
                 	
     </table>
     <div id="dbtn"><button type="button" onclick="closeWindow()">Close</button></div>
	</div>
	
	<script>
		function closeWindow(){
			window.location.href="/UserAccessManagement/admin.jsp";
		}
	</script>

</body>
</html>