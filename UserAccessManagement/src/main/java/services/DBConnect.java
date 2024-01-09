package services;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
	
private Connection con;
	
	public Connection dBConnect()
	{
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/uam_db", "root", "Cyber@24");
			return con;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
