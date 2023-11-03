package it.us.web.exceptions;

public class NotLoggedException extends AuthorizationException {
	
	private static final long serialVersionUID = -8297953010637899587L;
	private String message;
	
	public NotLoggedException()
	{
		
	}
	
	public NotLoggedException( String message ) 
	{
		this.message = message;
	}
	
	public String getMessage()
	{
		return message;
	}
	
	public void setMessage( String message )
	{
		this.message = message;
	}
}
