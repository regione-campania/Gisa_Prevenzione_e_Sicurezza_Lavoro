package it.us.web.action.login;

import it.us.web.action.GenericAction;
import it.us.web.action.Index;
import it.us.web.action.IndexGUC;
import it.us.web.exceptions.AuthorizationException;

public class LogoutGUC extends GenericAction
{
	@Override
	public void can() throws AuthorizationException
	{

	}

	@Override
	public void execute() throws Exception
	{
		if( utenteGuc != null )
		{
			String system = (String) session.getAttribute("system");
			session.setAttribute( "utenteGuc", null );
			session.invalidate();			
			utenteGuc = null;
			
			goToAction( new IndexGUC() );
			
			
		}
		else {
			
			session.invalidate();			
			goToAction( new IndexGUC() );
			
			
		}
		
		
	}
}
