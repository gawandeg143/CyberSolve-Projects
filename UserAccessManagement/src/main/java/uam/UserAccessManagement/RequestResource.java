package uam.UserAccessManagement;

import java.net.URI;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import Pojos.Users;
import services.RequestServices;

@Path("/request")
public class RequestResource {
	
	private RequestServices rqstSrvc;
	
	@Context
	private HttpServletRequest srvltRqst;
	
	private HttpSession usr;
	private Users u=null;
	
	public RequestResource()
	{
		rqstSrvc = new RequestServices();
	}
	
	@POST
	@Path("/add")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String addRequest(@FormParam("reqrsrc") String resource)
	{
		try {
			usr = srvltRqst.getSession(false);
			u = (Users)usr.getAttribute("userSession");
			if("select".equals(resource)) {
				return "<html><head><script>window.confirm('!! Choose appropriate option !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			else{
			
			String result = rqstSrvc.createRequest(u.getUserName(), resource);
			
			if("requested".equals(result))
			{
				return "<html><head><script>window.confirm('Request Sent successfully...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			else if("exists".equals(result))
			{
				return "<html><head><script>window.confirm('Request already pending...\\nWait for request to be approved !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			else {
				return "<html><head><script>window.confirm('Request could not be Sent !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			
		} }catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script>window.confirm('!! Error !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/rolerequest")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String roleChangeRequest(@FormParam("usr_role_rqst") String role, @FormParam("new_mngr") String newManager)
	{
		try {
			
			usr = srvltRqst.getSession(false);
			u = (Users)usr.getAttribute("userSession");
			if("select".equals(newManager) || role.isEmpty() || role==null)
			{
				return "<html><head><script>window.confirm('!! Choose appropriate option !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			else {
				String result = rqstSrvc.changeRole(u.getUserName(), role, newManager);
				//System.out.println(result);
				if("requested".equals(result)){
					return "<html><head><script>window.confirm('Request Sent successfully...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
				}
				else if("exists".equals(result))
				{
					return "<html><head><script>alert('Existing request is pending...\\nYou can make only one request for "+role+" at a time !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
				}
				else {
					return "<html><head><script>window.confirm('Request could not be Sent !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script>window.confirm('!! Error !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/update")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String updateRequest(@FormParam("username") String usrnm, @FormParam("resource") String resource, @FormParam("status") String status)
	{
		try {
			usr = srvltRqst.getSession(false);
			u = (Users)usr.getAttribute("userSession");
			boolean flag = rqstSrvc.updateRequest(usrnm, resource, status);
			
			if(flag)
			{
				return "<html><head><script>window.confirm('Request "+status+"...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script>window.confirm('!! Error !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp'</script></head><body></body></html>";
	}
	
	@POST
	@Path("/user")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public Response getAllResourcesByUsers(@FormParam("rmvresrcusr") String unm)
	{
		usr = srvltRqst.getSession(false);
		u = (Users)usr.getAttribute("userSession");
		URI redirectUri = URI.create("../"+u.getUserType()+".jsp");
		try {
			
			if("selected".equals(unm))
			{
				return Response.seeOther(redirectUri).build();
			}
			else {
				usr.setAttribute("slctdUsr", unm);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	    return Response.seeOther(redirectUri).build();
	}
	
	@POST
	@Path("/checkresources")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public Response getResourcesByUsers(@FormParam("chckresrcusr") String unm)
	{
		
		try {
			usr = srvltRqst.getSession(false);
			usr.setAttribute("slctdUsr1", unm);
			usr.setAttribute("userSession", (Users)usr.getAttribute("userSession"));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		URI redirectUri = URI.create("../resourceList.jsp");
	    return Response.seeOther(redirectUri).build();
	}
	
	@POST
	@Path("/rmv_resrc_usr")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String removeResourceFromUser(@FormParam("rmv_resrc") String resource)
	{
		try {
			usr = srvltRqst.getSession(false);
			u = (Users)usr.getAttribute("userSession");
			
			if("select".equals(resource)){
				return "<html><head><script>window.confirm(' !! Choose appropriate option !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			else{
				String slctUsr = (String)usr.getAttribute("slctdUsr");
				
				if(slctUsr==null && rqstSrvc.removeResourceFromUser(u.getUserName(), resource))
				{
					return "<html><head><script>window.confirm('Resource "+resource+" for user "+u.getFirstName()+" was removed successfully...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
				}
				else { 
					if(slctUsr!=null && rqstSrvc.removeResourceFromUser(slctUsr, resource))
					{
						return "<html><head><script>window.confirm('Resource "+resource+" for user "+slctUsr+" was removed successfully...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
					}
					else return "<html><head><script>window.confirm('Resource "+resource+" for user "+slctUsr+" cannot be removed !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script>window.confirm('Resource "+resource+" for user "+u.getUserName()+" cannot be removed !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
	}
	
	@POST
	@Path("/checkusers")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public Response checkUsersByResource(@FormParam("chckresrc") String resource)
	{
		try {
			usr = srvltRqst.getSession(false);
			usr.setAttribute("Resource_Users", resource);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		URI redirectUri = URI.create("../userList.jsp");
	    return Response.seeOther(redirectUri).build();
	}
	
	@POST
	@Path("/resign")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String resignRequest(@FormParam("resign_reason") String reason)
	{
		try {
			usr = srvltRqst.getSession(false);
			u = (Users)usr.getAttribute("userSession");
			String flag = rqstSrvc.resignRequest(reason, u.getUserName());
			
			if("requested".equals(flag))
			{
				return "<html><head><script>window.confirm('Request made successfully...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
			else if("exists".equals(flag)) {
				return "<html><head><script>window.confirm('Resignation already requested and is in progress...'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp';</script></head><body></body></html>";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script>window.confirm('!! Error !!'); window.location.href='/UserAccessManagement/"+u.getUserType()+".jsp'</script></head><body></body></html>";
	}

}
