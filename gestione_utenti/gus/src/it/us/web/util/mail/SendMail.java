package it.us.web.util.mail;

import java.util.Collection;

import it.us.web.util.properties.Application;

public class SendMail extends SimpleEmail implements Runnable
{
	static String from_address	= null;
	static String from_name		= null;
	static String host			= null;
	
	static
	{
		host			= Application.get( "MAIL_HOST" );
		from_address	= Application.get( "MAIL_SENDER_ADDRESS" );
		from_name		= Application.get( "MAIL_SENDER_NAME" );
	}
	
	public SendMail()
	{
		return;
	}

	public void send( String destination, String message, String subject )
	{		
		try
		{
			setHostName( host );
			setFrom( from_address, from_name );			
			this.run();
			addTo( destination );
			setSubject( subject );
			setMsg( message );
			send();
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void send( String destination, String bcc, String message, String subject )
	{		
		try
		{
			setHostName( host );
			setFrom( from_address, from_name );			
			this.run();
			addTo( destination );
			setSubject( subject );
			setMsg( message );
			setBcc(bcc);
			send();
		} 
		catch (Exception e) {
			e.printStackTrace();
		    send(bcc, bcc, message, subject);

		}
	}
	
	public void run() {
		
	}

}
