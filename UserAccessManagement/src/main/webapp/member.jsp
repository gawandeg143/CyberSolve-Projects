<%@page import="services.ResourceServices"%>
<%@page import="services.RequestServices"%>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="Pojos.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="0">
	
    <title>Member page</title>
    <style>
        .container{
            width: 70%;
            margin: 100px auto;
            font-size: 19px;
            font-family: sans-serif;
            border: 1px solid black;
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
        #lgn{
        	width: 30%;
        	margin: 100px auto;
        	font-family: sans-serif;
        	font-size: 20px;
        }
        .row{
            margin: 25px 15px;
            letter-spacing: 1px;
        }
        .row button{
            padding: 2px 8px;
            font-size: 15px;
            margin: 2px 10px;
        }
        .Chck{
            border: none;
            letter-spacing: 1px;
            cursor: pointer;
            text-decoration: underline;
        }
        .row a{
            color: black;
        }
        .row select{
            cursor: pointer;
            font-size: 16px;
            padding: 2px 5px;
            margin: 2px 10px;
        }
        h1{
        text-align: center;
        }
        #role{
        	font-size: 16px;
        }
        #usrlogout{
        	float: right;
        	margin-right: 30px;
        	font-size: 19px;
        	text-decoration: none;
        	font-family: sans-serif;
        	color: black;
        }
        #usrlogout:hover{
        	text-decoration: underline;
        }
        td input{
        	border: none;
        	font-size : 20px;
        	padding-left: 120px; 
        }
        table th{
        	text-align: center;
        	border : 1px solid black;
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
        	color: blue;
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
        document.getElementById('modal-content1').style.display = 'block';
    }
    function openResources(){
    	document.getElementById('modal-content').style.display = 'block';
    }
    function showProfile(){
    	document.getElementById('profile-content').style.display = 'block';
    }
    function closeProfile(){
    	document.getElementById('profile-content').style.display = 'none';
    }
    function closeResources(){
    	document.getElementById('modal-content').style.display = 'none';
    }
    function closeRequests() {
        document.getElementById('modal-content1').style.display = 'none';
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
	<h1>Welcome, <%=usrSession.getFirstName() %> <label id="role">[member]</label></h1>
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
                <button type="button" id="Chck" onclick="openResources()">Check Resources</button>
            </form>
            <div class="modal-content" id="modal-content">
                <div class="content">
                <%
                RequestServices rqstSrvc = new RequestServices();
                List<String> avlRsrcs = rqstSrvc.getResourcesByUser(usrSession.getUserName());
                %>
                    <span class="close-btn" onclick="closeResources()"> X </span>
                    <%if(avlRsrcs==null || avlRsrcs.isEmpty()){ %>
                    	<h3>No Resources</h3>
                    	<%}else{ %>
                    	<table cellpadding="10">
	                    	<tr>
	                    		<th>Available Resources</th>
	                    	</tr>
	                    	<%for(String r : avlRsrcs){ %>
	                    	<tr>
	                    		<td> <input type="text" name="resrc" value="<%=r %>" readonly> </td>
	                    	</tr>
	                    	<%} %>
                    </table>
                    <%} %>
                </div>
            </div>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/add" method="post">
                <label for="new-resource">Request for new resource : </label>
                <%
                	ResourceServices rsrcSrvc = new ResourceServices();
                	List<String> rsrcTorqst = rsrcSrvc.resourcesToRequest(usrSession.getUserName());
                %>
                <select name="reqrsrc" id="reqrsrc">
                    <option value="select">Select</option>
                    <%for(String s: rsrcTorqst){ %>
                    <option value="<%=s%>"><%=s %></option>
                    <%} %>
                </select>
                <button type="submit">Submit</button>
            </form>
        </div>

        <div class="row">
            <form>
                <button type="button" id="Chck" onclick="openRequests()">Check Approvals</button>
            </form>
            <div class="modal-content1" id="modal-content1">
                <div class="content">
                <%
                List<Requests> rqsts = rqstSrvc.getAllRequestsByUser(usrSession.getUserName());
                %>
                    <span class="close-btn" onclick="closeRequests()"> X </span>
                    <label> <h4>User :  <%=usrSession.getFirstName() %> <%=usrSession.getLastName() %></h4></label>
                    <hr><br>
                    <%if(rqsts==null || rqsts.isEmpty()){ %>
                    	<h3>No Requests</h3>
                    <%}else{ %>
                    	<table cellpadding="10">
	                    	<tr>
	                    		<th>Resource</th>
	            				<th>Status</th>
	                    	</tr>
	                    	<%for(Requests rq : rqsts){ %>
	                    	<tr>
	                    		<td> <input type="text" name="resrc" value="<%=rq.getRequestFor() %>" readonly> </td>
	                    		<td><input type="text" name="status" value="<%=rq.getStatus() %>" readonly></td>
	                    	</tr>
	                    	<%} %>
                    </table>
                    <%} %>
                </div>
            </div>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/rolerequest" method="post">
                <label>Request for Manager/Admin :</label>
                <input type="radio" name="usr_role_rqst" id="usr_role_rqst" value="admin"> <label> Admin</label>
                <input type="radio" name="usr_role_rqst" id="usr_role_rqst" value="manager"> <label> Manager</label>
                <button type="submit">Submit</button>
            </form>
        </div>

        <div class="row">
            <form action="/UserAccessManagement/app/request/rmv_resrc_usr" method="post">
                <label for="rm_rsrc">Remove own resource : </label>
                <%
                 List<String> rmvRsrc = rqstSrvc.getResourcesByUser(usrSession.getUserName());
                %>
                <select name="rmv_resrc" id="rmv_resrc">
                    <option value="select">Select</option>
                    <%for(String s: rmvRsrc){ %>
                    <option value="<%=s%>"><%=s %></option>
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