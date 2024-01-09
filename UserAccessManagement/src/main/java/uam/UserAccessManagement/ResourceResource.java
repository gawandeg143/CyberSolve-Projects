package uam.UserAccessManagement;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;

import services.ResourceServices;

@Path("/resource")
public class ResourceResource {

	private ResourceServices rsrcSrvc;

	public ResourceResource()
	{
		rsrcSrvc = new ResourceServices();
	}

	@POST
	@Path("/add")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String addResource(@FormParam("new_rsrc") String resrc)
	{
		try {

			if(resrc.isEmpty() || resrc==null)
			{
				return "<html><head><script>window.confirm('!! Invalid value !!'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>";
			}

			if(rsrcSrvc.addResource(resrc))
			{
				return "<html><head><script>window.confirm('Resource added successfully...'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>";
			}
			return "<html><head><script>window.alert('Resource cannot be added !!'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>";

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<html><head><script>window.alert('!! Error !!'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>";
	}

	@POST
	@Path("/remove")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String removeResource(@FormParam("rmvresrc") String resource)
	{
		try {
			if("select".equals(resource) || resource.isEmpty() || resource==null)
			{
				return "<html><head><script>window.confirm('!! Choose appropriate option !!'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>";
			}
			return rsrcSrvc.removeResource(resource)?"<html><head><script>window.alert('Resource removed successfully...'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>":"<html><head><script>window.alert('Resource cannot be removed'); window.location.href='/UserAccessManagement/admin.jsp'</script></head><body></body></html>";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

}
