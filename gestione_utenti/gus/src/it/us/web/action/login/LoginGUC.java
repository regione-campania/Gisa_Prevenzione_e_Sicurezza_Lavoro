package it.us.web.action.login;

import java.util.Enumeration;

import it.us.web.action.GenericAction;
import it.us.web.dao.UtenteDAO;

import it.us.web.exceptions.AuthorizationException;

public class LoginGUC extends GenericAction {

	@Override
	public void can() throws AuthorizationException
	{
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception
	{
		if( utenteGuc != null )
		{
			Enumeration<String> e = session.getAttributeNames();
			while( e.hasMoreElements() )
			{
				session.removeAttribute( e.nextElement() );
			}
			utenteGuc = null;
		}
		
		String un = stringaFromRequest( "utente" );
		String pw = stringaFromRequest( "password" );
		
		
		utenteGuc = UtenteDAO.authenticateUnifiedAccess(un, pw, db);
		
		if( utenteGuc == null)
		{
			setErrore("Autenticazione fallita");
		}
		
		else {
			
			session.setAttribute( "utenteGuc", utenteGuc );			
		}
			
		
		redirectTo( "IndexGUC.us" );
		
	}
}
