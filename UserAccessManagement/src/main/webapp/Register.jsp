<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Registration page</title>
<style>
    body{
        background-image: url("images/reg_bg.jpg");
    }
        .container{
            width: 40%;
            margin: 60px auto;
            padding: 5px;
            color: white;
            border: 1px solid rgba(8, 6, 48, 0.682);
            background-color: rgba(8, 6, 48, 0.682);
        }
        .container h2{
            text-align: center;
            font-size: 50px;
            margin-bottom: 50px;
            font-family: Georgia, 'Times New Roman', Times, serif;
        }
        form{
            width: 70%;
            margin: auto;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .btn{
            margin: 20px;
        }
        .column .row{
            margin: 5px;
            font-size: 22px;
        }
        .row input{
            font-size: 18px;
            margin: 0px 2px 15px 2px;
            padding: 4px;
        }
        .row label{
            margin: 4px 2px 0px 2px;
        }
        .btn #sbmt, #rst{
            padding: 5px 30px;
            font-size: 18px;
        }
        #sbmt, #rst{
            margin: 12px 15px;
        }
        .credential{
            display: none;
        }
        table{
        	text-align: left;
        }
        table input{
        	font-size: 18px;
        	padding: 4px;
        	margin: 7px 0px;
        }
    </style>
    <script>
    	function validateForm(){
    		var firstName = document.getElementById('fnm').value;
      var lastName = document.getElementById('lnm').value;
      var email = document.getElementById('eml').value;
      var password = document.getElementById('ps').value;
      var qtn = document.getElementById('qtn').value;
      var ans = document.getElementById('ans').value;

      if(firstName.trim().length<4)
      {
        alert('Firstname should be greater than 4 characters...');
        return false;
      }

      if(lastName.trim().length<4)
      {
        alert('Lastname should be greater than 4 characters...');
        return false;
      }

      // Validate email format
      var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email.trim())) {
        alert('Please enter a valid email address');
        return false;
      }

      // Additional password validation (e.g., minimum length)
      if (password.trim().length < 6) {
        alert('Password should be at least 6 characters long');
        return false;
      }
      
      if(qtn.trim().length<5){
    	  alert('Enter a valid question !!');
    	  return false;
      }
      if(ans.trim().length<3){
    	  alert('!! Invalid Answer !! \\nAnswer length should be more than 3 characters !!');
    	  return false;
      }

      return true;
    	}
    </script>
</head>
<body>
	<div class="container">
        <h2>Register</h2>
        <form action="app/user/add" method="post" onsubmit="return validateForm()">
            <div class="column">
                <div class="row">
                    <label for="firstname">Firstname </label>
                </div>
                <div class="row">
                    <input type="text" name="fname" id="fnm" required>
                </div>
                <div class="row">
                    <label for="lastname">Lastname </label>
                </div>
                <div class="row">
                    <input type="text" name="lname" id="lnm" required>
                </div>
                <div class="row">
                    <label for="email">Email </label>
                </div>
                <div class="row">
                    <input type="email" name="email" id="eml" required>
                </div>
                <div class="row">
                    <label for="password">Password </label>
                </div>
                <div class="row">
                    <input type="password" name="pass" id="ps" required>
                </div>
                <table>
                	<tr>
                		<th><label>Security Question </label></th>
                		<td> : <input type="text" name="qtn" id="qtn" required></td>
                	</tr>
                	<tr>
                		<th><label>Answer </label></th>
                		<td> : <input type="text" name="ans" id="ans" required></td>
                	</tr>
                </table>
                <div>
                	
                	
                </div>
                    <div class="btn"><button type="submit" id="sbmt">Submit</button><button type="reset" id="rst">Clear</button></div>
                </div>  
        </form>
    </div>
</body>
</html>