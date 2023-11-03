package it.us.web.util.mail.test;

import it.us.web.util.mail.EmailException;
import it.us.web.util.mail.Mailer;


public class MailTest {

	public static void main(String[] args)
	{
		try
		{
			Mailer.send( "a.donatiello@u-s.it", "chissa'' se va", "prova" );
		}
		catch (EmailException e)
		{
			e.printStackTrace();
		}
	}

}
