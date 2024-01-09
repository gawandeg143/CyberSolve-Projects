package Pojos;

import java.time.LocalDate;

public class Requests {
	
	private int requestId;
	private String user;
	private String requestFor;
	private LocalDate requestedDate;
	private String status;
	
	public Requests(int request_id, String user, String requestFor, LocalDate date, String status) {
		super();
		this.requestId = request_id;
		this.user = user;
		this.requestFor = requestFor;
		this.status = status;
		this.requestedDate = date;
	}

	public Requests(String user, String requestFor) {
		super();
		this.user = user;
		this.requestFor = requestFor;
		this.requestedDate = LocalDate.now();
	}

	public Requests() {
		super();
	}

	public int getRequest_id() {
		return requestId;
	}

	public void setRequest_id(int request_id) {
		this.requestId = request_id;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getRequestFor() {
		return requestFor;
	}

	public void setRequestFor(String requestFor) {
		this.requestFor = requestFor;
	}

	public LocalDate getRequestedDate() {
		return requestedDate;
	}

	public void setRequestedDate(LocalDate requestedDate) {
		this.requestedDate = requestedDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "Requests [requestId=" + requestId + ", user=" + user + ", requestFor=" + requestFor + ", requestedDate="
				+ requestedDate + ", status=" + status + "]";
	}

}
