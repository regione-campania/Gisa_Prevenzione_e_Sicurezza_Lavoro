package it.us.web.action.login;

import java.net.URLEncoder;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.http.HttpSession;

import it.us.web.action.GenericAction;
import it.us.web.dao.UtenteDAO;
import it.us.web.db.ApplicationProperties;
import it.us.web.exceptions.AuthorizationException;

public class LoginTest extends GenericAction {

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
		
		String cf_spid = req.getParameter( "cf_spid" );
		String pw_spid = req.getParameter( "pw_spid" );
		
		if(cf_spid!=null && !cf_spid.equals("") && !cf_spid.equals("null"))
			utente = UtenteDAO.authenticateAdministratorAccessSpid(cf_spid, pw_spid, db);
				
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
