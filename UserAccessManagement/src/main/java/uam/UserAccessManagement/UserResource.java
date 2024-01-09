package uam.UserAccessManagement;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import Pojos.Users;
import services.UserServices;

@Path("/user")
public class UserResource {
	
	private UserServices usrSrvc;
	
	@Context
	private HttpServletRequest servletRequest;
	
	private HttpSession session;
	
	public UserResource() {
		usrSrvc = new UserServices();
	}
	
	@POST
	@Path("/add")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String addUser(@FormParam("fname") String fnm, @FormParam("lname") String lnm, @FormParam("email") String email, @FormParam("pass")String pswd, @FormParam("qtn") String qtn, @FormParam("ans") String ans)
	{
		try {
			String usrnm = usrSrvc.addUser(fnm.trim(), lnm.trim(), email, pswd, qtn.toLowerCase(), ans.toLowerCase());
			return "no".equals(usrnm)?"<!DOCTYPE html>\r\n"
					+ "<html>\r\n"
					+ "<head>\r\n"
					+ "<meta charset=\"ISO-8859-1\">\r\n"
					+ "<title>Registration Status</title>\r\n"
					+ "<style>\r\n"
					+ "    .container{\r\n"
					+ "		width: 40%;\r\n"
					+ "		margin: 100px auto;\r\n"
					+ "        font-family: sans-serif;\r\n"
					+ "	}\r\n"
					+ "    h2{\r\n"
					+ "        color: red;\r\n"
					+ "        font-size: 25px;\r\n"
					+ "    }\r\n"
					+ "    p{\r\n"
					+ "        font-size: 18px;\r\n"
					+ "    }\r\n"
					+ "</style>\r\n"
					+ "</head>\r\n"
					+ "<body>\r\n"
					+ "	<div class=\"container\">\r\n"
					+ "        <h2>!! Registration failed !!</h2>\r\n"
					+ "        <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Try registering again... &nbsp;&nbsp;<a href=\"/UserAccessManagement/Register.jsp\">Register here</a></p>\r\n"
					+ "    </div>\r\n"
					+ "</body>\r\n"
					+ "</html>" : "<!DOCTYPE html>\r\n"
					+ "<html>\r\n"
					+ "<head>\r\n"
					+ "<meta charset=\"ISO-8859-1\">\r\n"
					+ "<title>Registration Status</title>\r\n"
					+ "<style>\r\n"
					+ "    .container{\r\n"
					+ "		width: 40%;\r\n"
					+ "		margin: 100px auto;\r\n"
					+ "        font-family: sans-serif;\r\n"
					+ "	}\r\n"
					+ "    h2{\r\n"
					+ "        color: blue;\r\n"
					+ "        font-size: 25px;\r\n"
					+ "    }\r\n"
					+ "    p{\r\n"
					+ "        font-size: 18px;\r\n"
					+ "    }\r\n"
					+ "</style>\r\n"
					+ "</head>\r\n"
					+ "<body>\r\n"
					+ "	<div class=\"container\">\r\n"
					+ "        <h2>!! Registered Successfully !!</h2>\r\n"
					+ "        <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Your Username is : "+usrnm+"&nbsp;&nbsp;</p>\r\n"
					+ "        <a href=\"/UserAccessManagement/Login.html\">login here</a>\r\n"
					+ "    </div>\r\n"
					+ "</body>\r\n"
					+ "</html>";
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	@POST
	@Path("/addUsers")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public String addMultipleUsers(InputStream file)
	{
		List<Users> al = new ArrayList<Users>();
		if(usrSrvc==null)
		{
			usrSrvc = new UserServices();
		}
		try(BufferedReader cs = new BufferedReader(new InputStreamReader(file))) {
			
			String line;
			
			cs.readLine(); cs.readLine(); cs.readLine(); cs.readLine();
			
			while( (line = cs.readLine()) != null ) {
				
				if (!line.isEmpty()) {
					
					String [] values = line.split(", ");
					if (values.length >= 3) {
//					System.out.println(values[0]+"\t"+values[1]+"\t"+values[2]);
					al.add(new Users(values[0], values[1], values[2], usrSrvc.generateUsername(values[0], values[1]), values[3]));
					}
				}
				else {
					break;
				}
			}
			//System.out.println(al);
			StringBuilder query = new StringBuilder("insert into users(f_name, l_name, email, username, password, manager, registration_date) values");
			for(Users u: al)
			{
				query.append(" ('"+u.getFirstName()+"','"+u.getLastName()+"','"+u.getEmail()+"','"+u.getUserName().toLowerCase()+"','"+usrSrvc.encryptPassword(u.getPassword())+"','"+usrSrvc.getDefaultAdmin()+"','"+Date.valueOf(LocalDate.now())+"'),");
			}
			query.deleteCharAt(query.length()-1);
			query.append(";");
			if(usrSrvc.multipleUsers(query.toString()))
				return "<html><head><script> window.confirm('Users created successfully...'); window.location.href='/UserAccessManagement/admin.jsp';</script></head><body></body></html>";
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(al);
		return "<html><head><script> window.confirm('!! ERROR !!'); window.location.href='/UserAccessManagement/admin.jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/authenticate")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public Response authenticateUser(@FormParam("username") String unm, @FormParam("password") String pswd)
	{
		try {
			
			if(!pswd.isEmpty()) {
				Users user = usrSrvc.userLogin(unm.trim(), pswd.trim());
			
			if(user!=null)
			{
				session = servletRequest.getSession();
				session.setAttribute("userSession", user);
				
				URI redirectUri = URI.create("../"+user.getUserType()+".jsp");
			    return Response.seeOther(redirectUri).build();
			}
			
		} }catch (Exception e) {
			e.printStackTrace();
		}
		URI redirectUri = URI.create("../incorrect.html");
	    return Response.seeOther(redirectUri).build();
	}
	
	@GET
	@Path("/logout")
	public String signOutUser()
	{
		try {
			session = servletRequest.getSession(false);
			if(session!=null)
			{
				Enumeration<String> sessionAttributes = session.getAttributeNames();
				while(sessionAttributes.hasMoreElements())
				{
					String attribute = sessionAttributes.nextElement();
					session.removeAttribute(attribute);
				}
			}
			session.invalidate();
		} catch (Exception e){
			e.printStackTrace();
		}
		return "<html><head><script>window.location.href='/UserAccessManagement/index.jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/addtoteam")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String addUserToTeam(@FormParam("usrs")String username)
	{
		try {
			//HttpSession ssn1 = servletRequest.getSession();
			session = servletRequest.getSession(false);
			Users manager = (Users)session.getAttribute("userSession");
			
			if("select".equals(username)) {
				return "<html><head><script> window.confirm('!! Choose appropriate Option !!'); window.location.href='/UserAccessManagement/"+manager.getUserType()+".jsp';</script></head><body></body></html>";
			}
			
			if(usrSrvc.allocateManager(username, manager.getUserName()))
			{
				return "<html><head><script> window.confirm('User "+username+" added to the team...'); window.location.href='/UserAccessManagement/"+manager.getUserType()+".jsp';</script></head><body></body></html>";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script> window.confirm('User "+username+" cannot be added to the team...'); window.location.href='/UserAccessManagement/manager.jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/removefromteam")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String removeUserFromTeam(@FormParam("usrnm") String username)
	{
		try {
			if (usrSrvc.deallocateManager(username)) {
				return "<html><head><script> window.confirm('User "+username+" removed from team...'); window.location.href='/UserAccessManagement/manager.jsp';</script></head><body></body></html>";
			} 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script> window.confirm('!! User "+username+" cannot be removed from team !!'); window.location.href='/UserAccessManagement/manager.jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/remove")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String removeUser(@FormParam("rmv_user") String userToRemove, @FormParam("usrType") String uType)
	{
		try {
			
			if(usrSrvc.removeUser(userToRemove, uType))
			{
				return "<html><head><script> window.confirm('User "+userToRemove+" removed from records...'); window.location.href='/UserAccessManagement/AllUsers.jsp';</script></head><body></body></html>";
			}
			else {
				return "<html><head><script> window.confirm('!! User "+userToRemove+" cannot be removed !!'); window.location.href='/UserAccessManagement/AllUsers.jsp';</script></head><body></body></html>";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script> window.confirm('!! ERROR !!'); window.location.href='/UserAccessManagement/AllUsers.jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/update")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String updateUserData(@FormParam("fnm") String fnm, @FormParam("lnm") String lnm, @FormParam("eml") String eml) {
		session = servletRequest.getSession(false);
		Users usr = (Users)session.getAttribute("userSession");
		try {
			if(usrSrvc.updateUser(usr.getUserName(), fnm, lnm, eml))
			{
				signOutUser();
				return "<html><head><script> window.confirm('User Data updated successfully...\\nPlease Login again'); window.location.href='/UserAccessManagement/Login.html';</script></head><body></body></html>";
			}
			else {
				return "<html><head><script> window.confirm('!! User Data could not be updated !!'); window.location.href='/UserAccessManagement/"+usr.getUserType()+".jsp';</script></head><body></body></html>";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script> window.confirm('!! ERROR !!'); window.location.href='/UserAccessManagement/Login.html';</script></head><body></body></html>";
		
	}
	
	@POST
	@Path("/changePassword")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String changePassword(@FormParam("pass") String cpass, @FormParam("npass") String npass)
	{
		try {
			session = servletRequest.getSession(false);
			String username=null;
			String type=null;
			if(cpass==null)
			{
				username = (String)session.getAttribute("user");
			}
			else {
				Users usr = (Users)session.getAttribute("userSession");
				if(usr.getPassword().equals(usrSrvc.encryptPassword(cpass)))
				{
					username = usr.getUserName();
					type = usr.getUserType();
				}
			}
			if(usrSrvc.changePass(username, usrSrvc.encryptPassword(npass)))
			{
				signOutUser();
				return "<html><head><script> window.confirm('User password updated successfully...\\nPlease Login again'); window.location.href='/UserAccessManagement/Login.html';</script></head><body></body></html>";
			}
			else {
				return type!=null?"<html><head><script> window.confirm('!! Password could not be updated !!'); window.location.href='/UserAccessManagement/"+type+".jsp';</script></head><body></body></html>":"<html><head><script> window.confirm('!! Password could not be updated !!'); window.location.href='/UserAccessManagement/Login.html';</script></head><body></body></html>";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script> window.confirm('!! ERROR !!'); window.location.href='/UserAccessManagement/Login.html';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/forgotPass")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String forgotPassword(@FormParam("user") String email, @FormParam("qtn") String qtn, @FormParam("ans") String ans) {
		try {
			String result = usrSrvc.forgotPass(email, qtn, ans);

				if("invalidEmail".equals(result)){
					return "<html><head><script> window.confirm('!! Invalid Email address !!'); window.location.href='/UserAccessManagement/ForgotPassword.jsp';</script></head><body></body></html>";
				}
				else if("invalidQtn".equals(result))
				{
					return "<html><head><script> window.confirm('!! Incorrect Question !!'); window.location.href='/UserAccessManagement/ForgotPassword.jsp';</script></head><body></body></html>";
				}
				else if("invalidAns".equals(result))
				{
					return "<html><head><script> window.confirm('!! Wrong Answer !!'); window.location.href='/UserAccessManagement/ForgotPassword.jsp';</script></head><body></body></html>";
				}
				if("error".equals(result))
				{
					return "<html><head><script> window.confirm('!! Error !!'); window.location.href='/UserAccessManagement/index.jsp';</script></head><body></body></html>";
				}
				else {
					session = servletRequest.getSession();
					session.setAttribute("username", result);
					return "<html><head><script>window.location.href='/UserAccessManagement/ChangePassword.jsp';</script></head><body></body></html>";
				}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script> window.confirm('!! ERROR !!'); window.location.href='/UserAccessManagement/Login.html';</script></head><body></body></html>";
	}

}
