<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Users</title>
</head>
<body>
	<div class="container">
		<form action="/UserAccessManagement/app/user/addUsers" method="post" enctype="multipart/form-data">
			<label>Upload file : </label><input type="file" name="file">
			<button type="submit">Submit</button>
		</form>
	</div>
</body>
</html>