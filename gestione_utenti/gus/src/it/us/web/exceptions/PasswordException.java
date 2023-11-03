package it.us.web.exceptions;

public class PasswordException extends Exception{

	private static final long serialVersionUID = -2403325587841993550L;
	private String message;
	
	public PasswordException( String message ) 
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
