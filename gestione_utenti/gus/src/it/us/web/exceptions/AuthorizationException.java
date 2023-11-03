package it.us.web.exceptions;

public class AuthorizationException extends Exception {
	
	private static final long serialVersionUID = -8297953010637899587L;
	private String message;
	
	public AuthorizationException()
	{
		
	}
	
	public AuthorizationException( String message ) 
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
