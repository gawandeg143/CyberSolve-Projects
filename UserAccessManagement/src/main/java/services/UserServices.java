package services;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import Pojos.PasswordRecovery;
import Pojos.Users;

public class UserServices {
	
	private PreparedStatement ps;
	private boolean ff=false;
	private String defaultAdmin;
	
	public UserServices()
	{
		try(Connection con = new DBConnect().dBConnect()){
			ps = con.prepareStatement("select username from users where user_type='admin' order by user_id asc limit 1");
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{
				defaultAdmin = rs.getString(1);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public String getDefaultAdmin() {
		return defaultAdmin;
	}

	public String encryptPassword(String pass)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			md.update(pass.getBytes(StandardCharsets.UTF_8));

            byte[] hashedBytes = md.digest();

            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
			
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public String generateUsername(String fnm, String lnm)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			String usrnm = fnm+"."+lnm;
			ps = con.prepareStatement("select username from users where username like '"+usrnm.toLowerCase()+"%';");
			ResultSet rs = ps.executeQuery();
			int i=1;
			while(rs.next())
			{
				if(usrnm.equals(rs.getString("username")))
				{
					usrnm = fnm+"."+lnm + ++i;
				}
			}
			return usrnm;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public boolean checkAdmin() {
		
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from users");
			ResultSet rs = ps.executeQuery();
			if(!rs.next())
			{
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public String addUser(String fnm, String lnm, String email, String pass, String qtn, String ans)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			String usrnm;
			if(!ff && checkAdmin())
			{
				usrnm = fnm.toLowerCase()+"."+lnm.toLowerCase();
				ps = con.prepareStatement("insert into users(f_name, l_name, username, password, email, registration_date, user_type, manager) values(?, ?, ?, ?, ?, ?, ?, ?)");
				ps.setString(7, "admin");
				if(defaultAdmin==null)
				{
					ps.setString(8, null);
				}
				else {
					ps.setString(8, defaultAdmin);
				}
				ff=true;
			}
			else {
				usrnm = generateUsername(fnm.toLowerCase(), lnm.toLowerCase());
				ps = con.prepareStatement("insert into users(f_name, l_name, username, password, email, registration_date, manager) values (?, ?, ?, ?, ?, ?, ?)");
				ps.setString(7, defaultAdmin);
			}
			
			if(usrnm!=null)
			{
				ps.setString(1, fnm);
				ps.setString(2, lnm);
				ps.setString(3, usrnm);
				pass = encryptPassword(pass);
				ps.setString(4, pass);
				ps.setString(5, email);
				ps.setDate(6, Date.valueOf(LocalDate.now()));
				
				if(ps.executeUpdate()>0)
				{
					ps = con.prepareStatement("insert into forgot_password(user, question, answer) values (?, ?, ?)");
					ps.setString(1, usrnm);
					ps.setString(2, qtn);
					ps.setString(3, ans);
					return ps.executeUpdate()>0?usrnm:"no";
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "no";
	}
	
	public boolean multipleUsers(String query)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement(query);
			if(ps.executeUpdate()>0)
			{
				return true;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public Users userLogin(String unm, String pass)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from users;");
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				if(unm.equals(rs.getString("username")) || unm.equals(rs.getString("email")))
				{
					String pswrd = encryptPassword(pass);
					
					if(pswrd.equals(rs.getString("password")))
					{
						return new Users(rs.getInt(1), rs.getString(2) , rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), LocalDate.parse(rs.getString(8)), rs.getString(9));
					}
					else {
						return null;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<String> getAllUsers()
	{
		List<String> al = new ArrayList<String>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select username from users where username!=?");
			ps.setString(1, defaultAdmin);
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
	
	public List<Users> getAllUserDetails()
	{
		List<Users> al = new ArrayList<Users>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from users");
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(new Users(rs.getInt(1), rs.getString(2) , rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), LocalDate.parse(rs.getString(8)), rs.getString(9)));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<Users> getAllUsersManager(String manager)
	{
		List<Users> al = new ArrayList<Users>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select * from users where manager=?");
			ps.setString(1, manager);
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				al.add(new Users(rs.getInt(1), rs.getString(2) , rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), LocalDate.parse(rs.getString(8)), rs.getString(9)));
			}
			return al;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List<String> getAllUsersNoManager(String manager)
	{
		List<String> al = new ArrayList<String>();
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("select username from users where manager=? and username!=?");
			ps.setString(1, defaultAdmin);
			ps.setString(2, manager);
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
	
	public boolean allocateManager(String usrnm, String mngr)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("update users set manager=? where username=?");
			ps.setString(1, mngr);
			ps.setString(2, usrnm);
			return ps.executeUpdate()>0 ? true:false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean deallocateManager(String usrnm)
	{
		System.out.println(defaultAdmin+"\t admin");
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("update users set manager=? where username=?");
			ps.setString(1, defaultAdmin);
			ps.setString(2, usrnm);
			return ps.executeUpdate()>0 ? true:false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean updateTeamManager(String usrnm)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			ps = con.prepareStatement("update users set manager=? where username in(select username from (select * from users where manager=?) as sq)");
			ps.setString(1, defaultAdmin);
			ps.setString(2, usrnm);
			return ps.executeUpdate()>0 ? true:false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean removeUser(String usrnm, String uType)
	{
		try(Connection con = new DBConnect().dBConnect()) {
				if("admin".equals(uType))
				{
					ps = con.prepareStatement("select count(*) from users where user_type='admin'");
					ResultSet rs1 = ps.executeQuery();
					int count=0;
					if(rs1.next())
						count = rs1.getInt(1);
					if(count>1)
					{
						ps = con.prepareStatement("update users set manager=? where manager=?");
						ps.setString(1, defaultAdmin);
						ps.setString(2, usrnm);
						ps.execute();
					}
					else {
						return false;
					}
				}
				else if("manager".equals(uType))
				{
					ps = con.prepareStatement("update users set manager=? where manager=?");
					ps.setString(1, defaultAdmin);
					ps.setString(2, usrnm);
					ps.execute();
				}
				ps = con.prepareStatement("delete from users where username=?");
				ps.setString(1, usrnm);
				return ((ps.executeUpdate()>0) ? true:false);
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updateUser(String unm, String fnm, String lnm, String eml) {
		
		try(Connection con = new DBConnect().dBConnect()) {
			
			ps = con.prepareStatement("update users set f_name=?, l_name=?, email=? where username=?");
			ps.setString(1, fnm);
			ps.setString(2, lnm);
			ps.setString(3, eml);
			ps.setString(4, unm);
			return ps.executeUpdate()>0 ? true:false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
		
	}
	
	public boolean changePass(String unm, String pass)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			
			ps = con.prepareStatement("update users set password=? where username=?");
			ps.setString(1, pass);
			ps.setString(2, unm);
			return ps.executeUpdate()>0 ? true:false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public String forgotPass(String eml, String qtn, String ans)
	{
		try(Connection con = new DBConnect().dBConnect()) {
			
			ps = con.prepareStatement("select username from users where email=?");
			ps.setString(1, eml);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				String user = rs.getString(1);
				ps = con.prepareStatement("select * from forgot_password where user=?");
				ps.setString(1, user);
				ResultSet rs1 = ps.executeQuery();
				if(rs1.next())
				{
					PasswordRecovery pr = new PasswordRecovery(rs1.getInt(1), rs1.getString(2), rs1.getString(3), rs1.getString(4));
					if(pr.getQuestion().equalsIgnoreCase(qtn))
					{
						if(pr.getAnswer().equalsIgnoreCase(ans))
						{
							return user;
						}
						return "invalidAns";
					}
					else {
						return "invalidQtn";
					}
				}
			}
			else
				return "invalidEmail";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "error";
	}

}
