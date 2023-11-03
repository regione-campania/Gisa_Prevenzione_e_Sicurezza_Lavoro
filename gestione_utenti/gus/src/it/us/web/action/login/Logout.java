package it.us.web.action.login;

import it.us.web.action.GenericAction;
import it.us.web.action.Index;
import it.us.web.exceptions.AuthorizationException;

public class Logout extends GenericAction
{
	@Override
	public void can() throws AuthorizationException
	{

	}

	@Override
	public void execute() throws Exception
	{
		if( utente != null )
		{
			String system = (String) session.getAttribute("system");
			session.setAttribute( "utente", null );
			session.invalidate();			
			utente = null;
			
			goToAction( new Index() );
			
			
		}
		else {
			
			session.invalidate();			
			goToAction( new Index() );
			
			
		}
		
		
	}
}
