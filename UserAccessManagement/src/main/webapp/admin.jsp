<%@page import="services.UserServices"%>
<%@page import="javax.ws.rs.core.Request"%>
<%@page import="Pojos.Requests"%>
<%@page import="Pojos.Users" %>
<%@page import="services.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="0">
    
    <title>Admin page</title>
    <style>
    body{
    	font-family: sans-serif;
    }
        h1{
            text-align: center;
        }
        .container{
            border: 1px solid black;
            width: 70%;
            margin: 50px auto;
            padding: 25px;
            font-size: 19px;
        }
        #added_items{
        	width: 70%;
        	margin: 20px auto;
        }
        #added_items li{
        	text-decoration: none;
        	font-size: 19px;
        }
        #added_items li:hover{
        	text-decoration: underline;
        }
        #lgn{
        	width: 30%;
        	margin: 100px auto;
        	font-family: sans-serif;
        	font-size: 20px;
        }
        .row{
            margin: 15px;
        }
        #Chck{
            border: none;
            font-size: 17px;
            cursor: pointer;
            text-decoration: underline;
        }
        input{
            font-size: 17px;
        }
        select{
            font-size: 16px;
            margin: 2px 6px;
            padding: 2px 5px;
        }
        button{
            font-size: 16px;
            padding: 2px 5px;
            margin: 2px 8px;
        }
        span button{
            margin: 1px 35px;
        }
        
        .modal-content {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
		.profile-content {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            font-size: 19px;
        }
        .content {
            position: fixed;
            top: 40%;
            left: 30%;
            transform: translate(-20%, -20%);
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }

        .content li{
            list-style: none;
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            font-weight: bolder;
            padding: 5px;
        }
        table td{
        margin: 1px 15px;
        padding: 4px 0px;
        }
        table tr td input{
          border : 0px;
          padding-left: 120px;
        }
        #role{
        	font-size: 16px;
        }
        #usrlogout{
        	float: right;
        	margin-right : 50px;
        	text-decoration: none;
        	font-size : 19px;
        	font-family: sans-serif;
        	color: black;
        }
        #usrlogout:hover{
        	text-decoration: underline;
        }
        #tto{
        	display: flex;
        }
        #tto form{
        	display: inline-block;
        }
        #added_items{
        	display: inline-block;
        }
        .profile-content table{
        	margin: 10px;
        	padding: 10px;
        	border: 1px solid black;
        }
        .profile-content table th{
        	border: none;
        	text-align: left;
        }
        .profile-content table tr{
        	margin: 5px 2px;
        }
        .profile-content button{
        	font-size: 19px;
        	padding: 3px 10px;
        }
        #profile{
        	float: right;
        	margin-right: 100px;
        	background: none;
        	border: none;
        	font-size: 20px;
        	cursor: pointer;
        }
        #profile:hover{
        	text-decoration: underline;
        }
        #edit_btn{
        	padding: 6px 20px;
        	font-size: 18px;
        	border: none;
        	background: none;
        	cursor: pointer;
        }
        #edit_btn:hover {
			text-decoration: underline;
		}
		#change{
			float: right;
			text-decoration: none;
			margin: 4px 10px;
		}
		#change:hover {
			text-decoration: underline;
		}
    </style>
    
    <script>
    
        function openRequests() {
            document.getElementById('modal-content').style.display = 'block';
            <%
            RequestServices rqstmdl = new RequestServices();
            List<Requests> reqlst = rqstmdl.getAllRequests();
            %>
        }
        function closeRequests() {
            document.getElementById('modal-content').style.display = 'none';
        }
        function approveRequest(status, resource, username) {
            document.getElementById('status').value = status;
            document.getElementById('username').value = username;
            document.getElementById('resource').value = resource;
            document.getElementById('hiddenSubmitButton').click();
        }
        function showProfile(){
        	document.getElementById('profile-content').style.display = 'block';
        }
        function closeProfile(){
        	document.getElementById('profile-content').style.display = 'none';
        }
        function declineRequest(status, resource, username) {
        	document.getElementById('status').value = status;
            document.getElementById('username').value = username;
            document.getElementById('resource').value = resource;
            document.getElementById('hiddenSubmitButton').click();
        }
        function edit(){
        	var fnmInput = document.getElementById("fnm");
        	var lnmInput = document.getElementById("lnm");
        	var emlInput = document.getElementById("eml");
        	
            fnmInput.readOnly = !fnmInput.readOnly;
            fnmInput.style.border = fnmInput.readOnly ? "none" : "1px solid black";
            
            lnmInput.readOnly = !lnmInput.readOnly;
            lnmInput.style.border = lnmInput.readOnly ? "none" : "1px solid black";
            
            emlInput.readOnly = !emlInput.readOnly;
            emlInput.style.border = emlInput.readOnly ? "none" : "1px solid black";
        }
    </script>
    <% response.setHeader("Cache-Control", "no-store"); %>
</head>
<% 
  HttpSession ssn = request.getSession(false);
  Users usrSession=null;
  String slctdusr=null;
  String resourceForUser=null;
  if(ssn!=null)
  {
	  Object ob = ssn.getAttribute("userSession");
	  if(ob instanceof Users)
	  {
		  usrSession = (Users)ob;
	  }
	  
	  if (usrSession == null) {
	      %>
	      <body>
	      	<div id="lgn">
	      		<h2>Session Expired....</h2>
	      		<p>Please login... <a href="/UserAccessManagement/Login.html">Login here</a></p>
	      	</div>
	      </body>
	      <%
	   }
	  else{
		  %>
<body>
		  	<h1>Welcome, <%=usrSession.getFirstName() %> <label id="role">[admin]</label></h1><br><br>
		  	<label><button type="button" id="profile" onclick="showProfile()">Profile</button></label>
	<div class="profile-content" id="profile-content">
		<div class="content">
			<span class="close-btn" onclick="closeProfile()"> X </span><br>
			<label><h2><%=usrSession.getFirstName() %> <%=usrSession.getLastName() %></h2></label>
			<hr>
			<span><label><b>Role :</b> <%=usrSession.getUserType() %></label> <label style="margin-left: 150px;"><b>Manager :</b> <%=usrSession.getManager() %> </label></span>
			<form action="/UserAccessManagement/app/user/update" method="post">
			<br>
				<table>
					<tr>
						<td colspan="2" style="text-align: right;"><button type="button" onclick="edit()" id="edit_btn">Edit</button><br></td>
					</tr>
					<tr>
						<th>First Name </th>
						<td> : <input type="text" id="fnm" name="fnm" value="<%=usrSession.getFirstName() %>" readonly></td>
					</tr>
					<tr>
						<th>Last Name </th>
						<td> : <input type="text" id="lnm" name="lnm" value="<%=usrSession.getLastName() %>" readonly></td>
					</tr>
					<tr>
						<th>Email </th>
						<td> : <input type="email" id="eml" name="eml" value="<%=usrSession.getEmail() %>" readonly></td>
					</tr>
					<tr>
						<td><br><button type="submit">Submit</button> <button type="reset">Clear</button></td>
					</tr>
				</table>
			</form>
			<a href="PasswordChange.html" id="change">Change Password</a>
		</div>
	</div>
    <label><a href="/UserAccessManagement/app/user/logout" id="usrlogout">Log Out</a></label>
    <div class="container">
        <div class="row">
            <form>
                <button type="button" id="Chck" onclick="openRequests()">Check requests</button>
            </form>
            <div class="modal-content" id="modal-content">
                <div class="content">
                    <span class="close-btn" onclick="closeRequests()">X</span>
                    <form action="/UserAccessManagement/app/request/update" method="post">
                    	<table>
	                    	<tr>
	                    		<th>Request for</th>
	            				<th>Requestor</th>
	            				<th></th>
	            				<th></th>
	                    	</tr>
	                    	<tr>
	                    		<td colspan="4"><hr></td>
	                    	</tr>
	                    	<%for(Requests rq :reqlst){ %>
	                    	<tr>
	                    		<td> <input type="text" name="resrc_<%=rq.getRequest_id() %>" value="<%=rq.getRequestFor()%>" readonly> </td>
	                    		<td><input type="text" name="unm_<%=rq.getRequest_id() %>" value="<%=rq.getUser() %>" readonly></td>
	                    		<td><button type="button" onclick="approveRequest('approved', '<%=rq.getRequestFor()%>', '<%=rq.getUser() %>')">Approve</button></td>
	                    		<td><button type="button" onclick="declineRequest('denied', '<%=rq.getRequestFor()%>', '<%=rq.getUser() %>')">Decline</button></td>
	                    	</tr>
	                    	<%} %>
	                    	<input type="hidden" name="status" id="status" value="">
	                    	<input type="hidden" name="username" id="username" value="">
	                    	<input type="hidden" name="resource" id="resource" value="">
                    </table>
                    <button type="submit" style="display:none;" id="hiddenSubmitButton"></button>
                    </form>
                </div>
            </div>
        </div>
        <div class="row">
            <form action="/UserAccessManagement/app/resource/add" method="post">
                <label for="add_resource">Add resource : </label><input type="text" name="new_rsrc" id="new_rsrc" placeholder="resource-name"> <button type="submit">Submit</button>
            </form>
        </div>
        <div class="row">
            <form action="/UserAccessManagement/app/resource/remove" method="post">
                <label for="">Remove resource from Database : </label>
                <select name="rmvresrc" id="rmvrsrc">
                <%
                ResourceServices rsrcmdl = new ResourceServices();
                 List<String> al = rsrcmdl.getALLResources();
                %>
                    <option value="select">Select</option>
                    <%for(String s: al){%>
                    <option value="<%=s %>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>
            </form>
        </div>
        
        <%
               HttpSession rsrcSession = request.getSession(false);
              
              if(rsrcSession!=null)
              {
            	  slctdusr = (String)rsrcSession.getAttribute("slctdUsr");
              }
              %>

        <div class="row" id="tto">
            <form action="/UserAccessManagement/app/request/user" method="post">
                <label for="">Remove resource from User : </label>
                <select name="rmvresrcusr" id="rmvresrcusr">
                <%
                List<String> al1 = rqstmdl.getAllUsersWithResources();
                %>
                	<option <% if (slctdusr != null) { %>value="<%=slctdusr %>" selected<% } else { %>value="selected"<% } %>><%= slctdusr != null ? slctdusr : "Select User" %></option>
                    <%
                    if(slctdusr == null){for(String s:al1){ %>
                     <option value="<%=s%>"><%=s %></option>
                    <%} }%>
                    
                </select>
                <button type="submit"> -> </button>
             </form>
              <form action="/UserAccessManagement/app/request/rmv_resrc_usr" method="post">
              		<select name="rmv_resrc" id="resrc">
                
                    <option value="select">Select Resource</option>
                    <%List<String> al2 = rqstmdl.getResourcesByUser(slctdusr); %>
                    <%for(String s:al2){ %>
                    <option value="<%=s%>"><%=s %></option>
                    <%} %>
                </select>
                <input type="hidden" value="<%=slctdusr%>" name="susr">
                <button type="submit">Submit</button>
              </form>
                
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/checkusers" method="post">
                <label for="">Check users for a resource : </label>
                <select name="chckresrc" id="chckresrc">
                    <option value="select">Select Resource</option>
                    <%for(String s: al){%>
                    <option value="<%=s %>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>
            </form>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/checkresources" method="post">
                <label for="">Check resources of an user : </label>
                <% UserServices usrSrvc = new UserServices();
                 List<String> al3 = usrSrvc.getAllUsers();
                %>
                <select name="chckresrcusr" id="chckresrcusr">
                    <option value="select">Select User</option>
                    <%for(String s: al3){%>
                    <option value="<%=s %>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>
            </form>
        </div>
    </div>
    <div id="added_items">
    	<ul>
    		<li><a href="/UserAccessManagement/AllUsers.jsp">All Users</a></li>
    		<li><a href="/UserAccessManagement/addUsers.jsp">Add Users</a></li>
    	</ul>
    </div>
</body><%
	  }
  }
 %>
</html>