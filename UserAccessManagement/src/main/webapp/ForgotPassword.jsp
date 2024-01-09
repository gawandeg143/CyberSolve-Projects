<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <style>
        .container{
            width: 30%;
            margin: 60px auto;
            font-family: Georgia, 'Times New Roman', Times, serif;
            font-size: 20px;
            padding: 10px;
        }
        h1{
            text-align: center;
            margin: 50px 10px;
        }
        table th{
            text-align: left;
        }
        table input, select{
            font-size: 18px;
            padding: 3px 5px;
            margin: 10px 3px;
        }
        .btn, .links{
            width: 50%;
            margin: 20px auto;
        }
        .btn button{
            font-size: 18px;
            padding: 4px 15px;
            margin: 1px 12px;
        }
        .links a{
            padding: 2px 13px;
            text-decoration: none;
            color: midnightblue;
            cursor: pointer;
        }
        .links a:hover{
            text-decoration: underline;
        }
    </style>
    <script>
    
        function validate(){
            var usr = document.getElementById("user").value;
            var qtn = document.getElementById("qtn").value;
            var ans = document.getElementById("ans").value;

            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(usr)) {
                alert('Please enter a valid email address');
                return false;
            }

            if(qtn.trim()==="select" || qtn.trim()==='' || ans.trim()==='' || ans.trim().length<3)
            {
                alert("Enter appropriate value !!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Forgot Password</h1>
        <form action="/UserAccessManagement/app/user/forgotPass" method="post" onsubmit="return validate()">
            <table>
                <tr>
                    <th>Enter Email </th>
                    <td> : <input type="text" name="user" id="user" required></td>
                </tr>
                <tr>
                    <th>Security Question </th>
<!--                     <td> : <input type="text" name="qtn" id="qtn" required> </td> -->
                    <td>?</td>
                </tr>
                <tr>
                    <th>Security Answer </th>
                    <td>
                         : <input type="text" name="ans" id="ans" required>
                    </td>
                </tr>
            </table>
            <div class="btn">
                <button type="submit">Submit</button>
                <button type="reset">Clear</button>
            </div>
        </form>
        <div class="links">
            <a href="Login.html">Log-In</a>
            <a href="Register.jsp">Sign-Up</a>
        </div>
    </div>
</body>
</html>