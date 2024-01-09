package services;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ResourceServices {
	
	private PreparedStatement ps;
	
	public boolean addResource(String resrc)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			PreparedStatement ps = con.prepareStatement("insert into resources(resource, added_date) values(?, ?)");
			ps.setString(1, resrc);
			ps.setDate(2, Date.valueOf(LocalDate.now()));
			if(ps.executeUpdate()>0)
			{
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<String> getALLResources()
	{
		try(Connection con = new DBConnect().dBConnect()) {
			PreparedStatement ps = con.prepareStatement("select * from resources");
			ResultSet rs = ps.executeQuery();
			List<String> al = new ArrayList<String>();
			while(rs.next())
			{
				al.add(rs.getString("resource"));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public boolean removeResource(String resource)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("delete from resources where resource=?");
			ps.setString(1, resource);
			if(ps.executeUpdate()>0)
			{
				ps = con.prepareStatement("delete from requests where requirement=?");
				ps.setString(1, resource);
				return ps.executeUpdate()>=0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<String> resourcesToRequest(String user)
	{
		List<String> resources = new ArrayList<String>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select resource from resources where resource not in(select requirement from requests where requestor=? and status='approved' and requirement not in('manager', 'member', 'admin'))");
			ps.setString(1, user);
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				resources.add(rs.getString(1));
			}
			//System.out.println(resources);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resources;
	}

}
