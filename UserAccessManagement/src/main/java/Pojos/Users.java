package Pojos;

import java.time.LocalDate;

public class Users {
	
	private int user_id;
	private String firstName;
	private String lastName;
	private String email;
	private String userName;
	private String password;
	private String userType;
	private String manager;
	private LocalDate registration_date;
	
	public Users() {
		super();
	}
	
	public Users(String firstName, String lastName, String email, String userName, String password) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.userName = userName;
		this.password = password;
		this.email = email;
		this.registration_date = LocalDate.now();
	}

	public Users(int user_id, String firstName, String lastName, String email, String userName, String userType, String manager, LocalDate reg_date, String password) {
		super();
		this.user_id = user_id;
		this.firstName = firstName;
		this.lastName = lastName;
		this.userName = userName;
		this.password = password;
		this.userType = userType;
		this.manager = manager;
		this.email = email;
		this.registration_date = reg_date;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getManager() {
		return manager;
	}

	public void setManager(String manager) {
		this.manager = manager;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public LocalDate getRegistration_date() {
		return registration_date;
	}

	public void setRegistration_date(LocalDate registration_date) {
		this.registration_date = registration_date;
	}

	@Override
	public String toString() {
		return "Users [user_id=" + user_id + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email
				+ ", userName=" + userName + ", password=" + password + ", userType=" + userType + ", manager="
				+ manager + ", registration_date=" + registration_date + "]";
	}

}
