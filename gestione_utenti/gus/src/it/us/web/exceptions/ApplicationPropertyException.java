package it.us.web.exceptions;

public class ApplicationPropertyException extends Exception {
	
	private static final long serialVersionUID = -8297953010637899587L;
	private String message;
	
	public ApplicationPropertyException( String message ) 
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
