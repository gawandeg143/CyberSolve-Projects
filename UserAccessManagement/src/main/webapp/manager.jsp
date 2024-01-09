<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="Pojos.*" %>
<%@ page import="services.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="0">
	<title>Manager Page</title>
	<style>
	h1{
		text-align: center;
	}
	#usrlogout{
		float: right;
		margin-right: 50px;
		font-size: 19px;
		font-family: sans-serif;
		color: black;
		text-decoration: none;
	}
	#usrlogout:hover{
		text-decoration: underline;
	}
	#lgn{
        	width: 30%;
        	margin: 100px auto;
        	font-family: sans-serif;
        	font-size: 20px;
        }
        #role{
        	font-size: 16px;
        }
        .container{
            width: 80%;
            margin: 50px auto;
            border: 1px solid black;
            font-size: 19px;
            font-family: sans-serif;
            line-height: 26px;
            display: fl;
        }
        .row{
            margin: 20px 15px;
        }
        .row button{
            font-size: 15px;
            letter-spacing: 1px;
            padding: 2px 8px;
            margin: 2px 10px;
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
        .modal-content1 {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
        .modal-content2 {
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
        .Chck{
            border: none;
            text-decoration: underline;
            cursor: pointer;
        }
        .row select{
            font-size: 16px;
            padding: 2px 5px;
            margin: 2px 10px;
        }
        table th{
        	text-align: left;
        }
        table tr td input{
         border: none;
         font-size: 19px;
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
        	font-size: 19px;
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
        }
        
        function closeRequests() {
            document.getElementById('modal-content').style.display = 'none';
        }
        
        function removeUser(user)
        {
        	document.getElementById('username').value = user;
        	document.getElementById('hiddenSubmitButton').click();
        }
        
        function showResources(){
        	document.getElementById('modal-content1').style.display = 'block';
        }
        function hideResources(){
        	document.getElementById('modal-content1').style.display = 'none';
        }
        function showProfile(){
        	document.getElementById('profile-content').style.display = 'block';
        }
        function closeProfile(){
        	document.getElementById('profile-content').style.display = 'none';
        }
        function showApprovals(){
        	document.getElementById('modal-content2').style.display = 'block';
        }
        function hideApprovals(){
        	document.getElementById('modal-content2').style.display = 'none';
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
	<h1>Welcome, <%=usrSession.getFirstName() %> <label id="role">[manager]</label></h1><br>
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
                <button type="button" onclick="openRequests()" class="Chck">Show team</button>
            </form>
            <div class="modal-content" id="modal-content">
                <div class="content">
                <%
                UserServices usrSrvc = new UserServices();
                List<Users> usrLst = usrSrvc.getAllUsersManager(usrSession.getUserName());
                %>
                    <span class="close-btn" onclick="closeRequests()"> X </span>
                    	
                    		<%
                    		 if(usrLst==null || usrLst.isEmpty())
                    		 {
                    		%>
                    		<h3>No Team Members</h3>
                    		<%}
                    		else{%>
                    		<form action="/UserAccessManagement/app/user/removefromteam" method="post">
                    		<table>
		                    	<tr>
		                    		<th>First Name</th>
		                    		<th>Last Name</th>
		                    		<th>Email</th>
		                    		<th>Username</th>
		                    		<th></th>
		                    	</tr>
		                    	<tr>
		                    		<td colspan="4"><hr></td>
		                    	</tr>
		                    	<%for(Users r : usrLst){ %>
		                    	<tr>
		                    		<td> <input type="text" name="fnm" value="<%=r.getFirstName() %>" readonly> </td>
		                    		<td> <input type="text" name="lnm" value="<%=r.getLastName() %>" readonly> </td>
		                    		<td> <input type="text" name="eml" value="<%=r.getEmail() %>" readonly> </td>
		                    		<td> <input type="text" name="unm" value="<%=r.getUserName() %>" readonly> </td>
		                    		<td> <button type="button" name="rmv_btn" onclick="removeUser('<%=r.getUserName()%>')"> Remove</button> </td>
		                    	</tr>
		                    	<%} %>
	                    		<input type="hidden" name="usrnm" id="username" value="">
                    		</table>
                    		<button type="submit" style="display:none;" id="hiddenSubmitButton"></button>
                    		</form>
                    		<%}%>
                    	
                </div>
            </div>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/user/addtoteam" method="post">
                <label for="team-member">Get a team member</label><br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="username">User-name : </label>
                <%
                 List<String> usrs = usrSrvc.getAllUsersNoManager(usrSession.getUserName());
                %>
                <select name="usrs" id="usrs">
                    <option value="select">Select</option>
                    <%for(String s: usrs){%>
                    <option value="<%=s %>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>             
            </form>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/rolerequest" method="post">
                <label for="admin-request">Request for Admin</label><br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="username">Assign manager to : </label>
                
                <select name="new_mngr" id="new_mngr">
                    <option value="select">Select</option>
                    <%for(Users s: usrLst){%>
                    <option value="<%=s.getUserName() %>"><%=s.getUserName() %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button> 
                <input type="hidden" name="usr_role_rqst" value="r_admin">
            </form>
        </div>

        <div class="row">
            <form>
                <button type="button" onclick="showResources()" class="Chck">Check Resources</button>
            </form>
            <div class="modal-content1" id="modal-content1">
                <div class="content">
                <%
               		RequestServices rqstSrvc = new RequestServices();
                	List<String> rsrcLst = rqstSrvc.getResourcesByUser(usrSession.getUserName());
                %>
                    <span class="close-btn" onclick="hideResources()"> X </span>
                    	<label> <h4>User :  <%=usrSession.getFirstName() %> <%=usrSession.getLastName() %></h4></label>
                    <hr><br>
                    		<%
                    		 if(rsrcLst==null || rsrcLst.isEmpty())
                    		 {
                    		%>
                    		<h3>No Resources</h3>
                    		<%}
                    		else{%>
                    			<h3> Resources </h3>
                    			<ol>
                    				<%
                    				 for(String s : rsrcLst)
                    				 {
                    				%>
                    				<li><%=s %></li>
                    				<%} %>
                    			</ol>
                    		<%}%>
                    	
                </div>
            </div>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/add" method="post">
                <label for="new-rsrc-request">Request for new resource</label>
                <%
                 ResourceServices rsrcSrvc = new ResourceServices();
                 List<String> rsrcRqstLst = rsrcSrvc.resourcesToRequest(usrSession.getUserName());
                %>
                <select name="reqrsrc" id="reqrsrc">
                    <option value="select">Select</option>
                    <%for(String s : rsrcRqstLst){%>
                    <option value="<%=s %>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>
            </form>
        </div>

        <div class="row">
            <form>
                <button type="button" onclick="showApprovals()" class="Chck">Check Approvals</button>
            </form>
            <div class="modal-content2" id="modal-content2">
                <div class="content">
                <%
                	List<Requests> rqstLst = rqstSrvc.getAllRequestsByUser(usrSession.getUserName());
                %>
                    <span class="close-btn" onclick="hideApprovals()"> X </span>
                    <%
                    		 if(rqstLst==null || rqstLst.isEmpty())
                    		 {
                    		%>
                    		<h3>No Requests</h3>
                    		<%}
                    		else{%>
                    		<h3>User : <%=usrSession.getFirstName() %> <%=usrSession.getLastName() %></h3>
                    <table>
                    	<tr>
                    		<th>Requested Resource</th>
                    		<th>Status</th>
                    	</tr>
                    	<tr><td colspan="2"><hr></td></tr>
                    	<%for(Requests s : rqstLst){ %>
                    	<tr>
                    		<td><label><%=s.getRequestFor() %></label><td>
                    		<td><label><%=s.getStatus() %></label><td>
                    	</tr>
                    	<%} %>
                    </table>
                    	<%} %>
                </div>
            </div>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/rmv_resrc_usr" method="post">
                <label for="rm_rsrc">Remove own resource : </label>
                <select name="rmv_resrc" id="rmv_resrc">
                    <option value="select">Select</option>
                    <%for(String s : rsrcLst){%>
                    <option value="<%=s %>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>
            </form>
        </div>
        <div class="row">
        	<form action="/UserAccessManagement/app/request/resign" method="post">
        		<label>Resignation request : </label>
	        	<input type="text" name="resign_reason" placeholder="Reason for resignation">
	        	<button type="submit">Submit</button>
        	</form>
        </div>
    </div>
</body>
<%
	  }
  }
 %>
</html>