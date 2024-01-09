<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Change</title>
    <style>
        h2{
            text-align: center;
            font-family: 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', 'Geneva, Verdana, sans-serif';
            font-size: 30px;
        }
        .container{
            width: 40%;
            margin: 80px auto;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
            font-size: 20px;
        }
        table tr input{
            margin: 2px 10px;
            font-size: 20px;
            padding: 2px 4px;
        }
        table th{
            text-align: left;
        }
        table tr{
            line-height: 45px;
        }
        .btn{
            width: 60%;
            margin: 2px auto;
        }
        .btn button{
            font-size: 19px;
            padding: 4px 20px;
            margin: 1px 20px;
        }
        #message{
        	text-align: right;
        }
    </style>
    <script>
    document.addEventListener('DOMContentLoaded', function () {
    	
        var newPasswordInput = document.getElementById('npass');
        var confirmPasswordInput = document.getElementById('cpass');
        var sbtn = document.getElementById('submit_btn');
        
        newPasswordInput.addEventListener('input', checkPasswordMatch);
        confirmPasswordInput.addEventListener('input', checkPasswordMatch);

        function checkPasswordMatch() {
            var newPassword = newPasswordInput.value;
            var confirmPassword = confirmPasswordInput.value;

            var passwordMatchMessage = document.getElementById('message');
            
            if(newPassword.trim() !== '' && confirmPassword.trim() !== '')
            	{
	                if (newPassword.trim() === confirmPassword.trim()) {
	                    passwordMatchMessage.innerText = 'Passwords match';
	                    passwordMatchMessage.style.color = 'green';
	                    sbtn.disabled = false;
	                } else {
	                    passwordMatchMessage.innerText = 'Passwords do not match';
	                    passwordMatchMessage.style.color = 'red';
	                    sbtn.disabled = true;
	                }
            	}else {
                    passwordMatchMessage.innerText = '';
                    sbtn.disabled = true;
                }
        }
    });
    
    function validate()
    {
    	var newPassword = document.getElementById('npass').value;
        var confirmPassword = document.getElementById('cpass').value;
        
        if(newPassword.trim().length<=6 || confirmPassword.trim().length<=6)
		{
			alert("Password should be more than 6 characters");
			return false;
		}
    }
</script>
<%
 session = request.getSession(false);
 String usr = (String)session.getAttribute("username");
 session.setAttribute("user", usr);
%>
</head>
<body>
    <br>
    <h2>Change Password</h2>
    <div class="container">
        <form action="/UserAccessManagement/app/user/changePassword" method="post" onsubmit="return validate()">
            <table>
                <tr>
                    <th>New Password</th>
                    <td>: <input type="password" name="npass" id="npass" required></td>
                </tr>
                <tr>
                    <th>Confirm Password</th>
                    <td>: <input type="password" name="cpass" id="cpass" required></td>
                </tr>
                <tr>
                	<td colspan="2"><div id="message"></div></td>
                </tr>
            </table><br>
            <div class="btn">
                <button id="submit_btn" type="submit">Submit</button>
                <button type="reset">Clear</button>
            </div>
        </form>
    </div>
</body>
</html>