package it.us.web.bean;

public class ServicesStatus
{
	private String error = null;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}
	
	public boolean isAllRight()
	{
		return error == null;
	}
}
