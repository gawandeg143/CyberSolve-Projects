package services;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import Pojos.Requests;
import Pojos.Users;

public class RequestServices {
	
	private PreparedStatement ps;
	
	public String createRequest(String username, String requirement)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			
			ps = con.prepareStatement("select * from requests where requestor=? and requirement=? and status='pending'");
			ps.setString(1, username);
			ps.setString(2, requirement);
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{
				return "exists";
			}
			else {
			ps = con.prepareStatement("insert into requests(requestor, requirement, requested_date) values(?, ?, ?)");
			ps.setString(1, username);
			ps.setString(2, requirement);
			ps.setDate(3, Date.valueOf(LocalDate.now()));
			if(ps.executeUpdate()>0)
			{
				return "requested";
			}
		} }catch (Exception e) {
			e.printStackTrace();
		}
		return "failed";
	}
	
	public String resignRequest(String reason, String user)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			
			ps = con.prepareStatement("select * from requests where requestor=? and requirement=? and status='pending'");
			ps.setString(1, user);
			ps.setString(2, "self-resign");
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{
				return "exists";
			}
			else {
			ps = con.prepareStatement("insert into requests(requestor, requirement, requested_date) values(?, ?, ?)");
			ps.setString(1, user);
			ps.setString(2, "self-resign");
			ps.setDate(3, Date.valueOf(LocalDate.now()));
			if(ps.executeUpdate()>0)
			{
				return "requested";
			}
		} }catch (Exception e) {
			e.printStackTrace();
		}
		return "failed";
	}
	
	public boolean updateRequest(String username, String requirement, String status)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			boolean flag = false;
			
			ps = con.prepareStatement("update requests set status=? where requestor=? and requirement=? and status='pending'");
			ps.setString(1, status);
			ps.setString(2, username);
			ps.setString(3, requirement);
			flag = ps.executeUpdate()>0;
			if(flag && "denied".equals(status))
			{
				return true;
			}
			if(flag && "approved".equals(status) && ("manager".equals(requirement) || "admin".equals(requirement)))
			{
				ps = con.prepareStatement("update users set user_type=? where username=?");
				ps.setString(1, requirement);
				ps.setString(2, username);
				flag = ps.executeUpdate()>0;
				return true;
			}
			else if(flag && "approved".equals(status) && "r_admin".equals(requirement))
			{
				ps = con.prepareStatement("update users set user_type=? where username=?");
				ps.setString(1, "admin");
				ps.setString(2, username);
				flag = ps.executeUpdate()>0;
				if(flag)
				{
					ps = con.prepareStatement("select username from users where manager=? and username in(select requestor from requests where requirement='r_manager')");
					ps.setString(1, username);
					ResultSet rs = ps.executeQuery();
					if(rs.next())
					{
						String newManager = rs.getString(1);
						ps = con.prepareStatement("update requests set status=? where requestor=? and requirement=? and status='pending'");
						ps.setString(1, status);
						ps.setString(2, newManager);
						ps.setString(3, "r_manager");
						flag = ps.executeUpdate()>0;
						if(flag)
						{
							ps = con.prepareStatement("update users set user_type=? where username=?");
							ps.setString(1, "manager");
							ps.setString(2, newManager);
							if(ps.executeUpdate()>0)
							{
								ps = con.prepareStatement("update users set manager=? where username in(select username from (select username from users where manager=?) as sq)");
								ps.setString(1, newManager);
								ps.setString(2, username);
								if(ps.executeUpdate()>=0)
								{
									UserServices usrSrvc = new UserServices();
									if(usrSrvc.allocateManager(newManager, usrSrvc.getDefaultAdmin()))
									{
										return true;
									}
								}
							}
						}
					}
				}
			}
			else if(flag && "self-resign".equals(requirement))
			{
				ps = con.prepareStatement("delete from requests where requestor=? and status='approved'");
				ps.setString(1, username);
				flag = ps.executeUpdate()>0;
				if(flag)
				{
					ps = con.prepareStatement("select * from users where username=?");
					ps.setString(1, username);
					ResultSet rs = ps.executeQuery();
					if(rs.next())
					{
						if("manager".equals(rs.getString("user_type")))
						{
							System.out.println("hello");
							UserServices usrSrvc = new UserServices();
							System.out.println(usrSrvc.updateTeamManager(username) );
						}
						ps = con.prepareStatement("delete from users where username=?");
						ps.setString(1, username);
						return ps.executeUpdate()>0?true:false;
					}
				}
			}
			return flag;

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	
	public List<Users> getAllUsersByResource(String resource)
	{
		List<Users> al = new ArrayList<Users>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from Users where username in(select requestor from requests where requirement=? and status='approved')");
			ps.setString(1, resource);
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(new Users(rs.getInt(1), rs.getString(2) , rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), LocalDate.parse(rs.getString(8)), rs.getString(9)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return al.isEmpty()?null:al;
	}
	
	public boolean removeResourceFromUser(String username, String resource)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("delete from requests where requestor=? and requirement=?");
			ps.setString(1, username);
			ps.setString(2, resource);
			return ps.executeUpdate()>0?true:false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<String> getAllUsersWithResources()
	{
		List<String> al = new ArrayList<String>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select distinct(requestor) from requests where status='approved' and requirement not in('manager', 'r_manager', 'admin', 'r_admin', 'self-resign')");
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(rs.getString(1));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<Requests> getAllRequests()
	{
		List<Requests> al = new ArrayList<Requests>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from requests where status='pending' and requirement!='r_manager'");
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(new Requests(rs.getInt(1), rs.getString(2), rs.getString(3), LocalDate.parse(rs.getString(4)), rs.getString(5)));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<Requests> getAllRequestsByUser(String user)
	{
		List<Requests> al = new ArrayList<Requests>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from requests where requestor=?");
			ps.setString(1, user);
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(new Requests(rs.getInt(1), rs.getString(2), rs.getString(3), LocalDate.parse(rs.getString(4)), rs.getString(5)));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<String> getResourcesByUser(String username)
	{
		//System.out.println(username);
		List<String> al = new ArrayList<String>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select requirement from requests where requestor=? and status='approved' and requirement not in('manager', 'member', 'admin', 'r_admin', 'r_manager')");
			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(rs.getString(1));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	// for manager to admin
	public String changeRole(String requestor, String requestFor, String newManager)
	{
		boolean flag = false;
		try(Connection con = new DBConnect().dBConnect()) {
			
			ps = con.prepareStatement("select * from requests where requestor=? and requirement=? and status='pending'");
			ps.setString(1, requestor);
			ps.setString(2, requestFor);
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{
				return "exists";
			}
			else{
				ps = con.prepareStatement("insert into requests(requestor, requirement, requested_date) values (?, ?, ?)");
				ps.setString(1, requestor);
				ps.setString(2, requestFor);
				ps.setDate(3, Date.valueOf(LocalDate.now()));
				flag = ps.executeUpdate()>0;
				if( flag && newManager!=null)
				{
					ps = con.prepareStatement("insert into requests(requestor, requirement, requested_date) values (?, ?, ?)");
					ps.setString(1, newManager);
					ps.setString(2, "r_manager");
					ps.setDate(3, Date.valueOf(LocalDate.now()));
					if(ps.executeUpdate()>0)
					{
						return "requested";
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return flag?"requested":"failed";
	}	

}
