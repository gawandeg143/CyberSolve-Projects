<%@page import="services.RequestServices"%>
<%@page import="Pojos.Users" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Resource List</title>
<style>
	.container{
		width: 30%;
		margin: 100px auto;
		font-family: sans-serif;
		letter-spacing: 1px;
	}
	li{
		font-size: 19px;
		line-height: 30px;
	}
	#cbtn{
        width: 30%;
        margin: auto;
    }
    div button{
        width: 80%;
        margin: 30px auto;
        font-size: 18px;
        padding: 4px 20px;
    }
</style>
<%
HttpSession ssn2 = request.getSession(false);
Users user = (Users)ssn2.getAttribute("userSession");
String selectedUser = (String)ssn2.getAttribute("slctdUsr1");
if(selectedUser==null || "select".equals(selectedUser) || selectedUser.isEmpty()){
	%>
	 <script>
	 window.confirm('!! Choose appropriate option !!'); 
	 window.location.href='/UserAccessManagement/admin.jsp';
	 </script>
	 <%
}
else{
%>

<%
 RequestServices rqstMdl = new RequestServices();
 List<String> rsrcs = rqstMdl.getResourcesByUser(selectedUser);
%>
<script>
    	function closeWindow(){
    		var loc = "/UserAccessManagement/" + '<%=user.getUserType()%>' + ".jsp";
    		window.location.href=loc;
    	}
    </script>
</head>
<body>

	<div class="container">
        <h2>User : <%=selectedUser %></h2><br>
        <ol>
            <% try{
            	if(rsrcs.isEmpty() || rsrcs==null){%>
            	<label>No Resources</label>
            	<%}
            	else{ 
            		for(String s: rsrcs) {%>
            <li><%=s %></li>
            <%} } } catch(Exception e){} }%>
        </ol>
        <div id="cbtn"><button type="button" onclick="closeWindow()">Close</button></div>
    </div>
</body>
</html>