package Pojos;

import java.time.LocalDate;

public class Resources {
	
	private int resourceId;
	private String resource;
	private LocalDate added_date;
	
	public Resources(int resourceId, String resource, LocalDate date) {
		super();
		this.resourceId = resourceId;
		this.resource = resource;
		this.added_date = date;
	}

	public Resources(String resource) {
		super();
		this.resource = resource;
		this.added_date = LocalDate.now();
	}

	public Resources() {
		super();
	}

	public int getResourceId() {
		return resourceId;
	}

	public void setResourceId(int resourceId) {
		this.resourceId = resourceId;
	}

	public String getResource() {
		return resource;
	}

	public void setResource(String resource) {
		this.resource = resource;
	}

	public LocalDate getAdded_date() {
		return added_date;
	}

	public void setAdded_date(LocalDate added_date) {
		this.added_date = added_date;
	}

	@Override
	public String toString() {
		return "Resources [resourceId=" + resourceId + ", resource=" + resource + ", added_date=" + added_date + "]";
	}

}
