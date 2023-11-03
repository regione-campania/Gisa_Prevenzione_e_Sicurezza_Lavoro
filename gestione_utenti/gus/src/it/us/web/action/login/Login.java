package it.us.web.action.login;

import java.util.Enumeration;

import it.us.web.action.GenericAction;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;

public class Login extends GenericAction {

	@Override
	public void can() throws AuthorizationException
	{
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception
	{
		if( utente != null )
		{
			Enumeration<String> e = session.getAttributeNames();
			while( e.hasMoreElements() )
			{
				session.removeAttribute( e.nextElement() );
			}
			utente = null;
		}
		
		String un = req.getParameter( "utente" );
		String pw = req.getParameter( "password" );
		String cf_spid = req.getParameter( "cf_spid" );
		
		if(cf_spid!=null && !cf_spid.equals("") && !cf_spid.equals("null"))
			utente = UtenteDAO.authenticate( cf_spid, db );
		else
			utente = UtenteDAO.authenticate( un, pw, db );
		
		if( utente == null )
		{
			setErrore("Autenticazione fallita");
		}
		else
		{	
			session.setAttribute( "utente", utente );
		}
		
		redirectTo( "Index.us" );
		
	}
}
