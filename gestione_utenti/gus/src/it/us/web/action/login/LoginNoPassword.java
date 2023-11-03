package it.us.web.action.login;

import java.util.Enumeration;

import it.us.web.action.GenericAction;
import it.us.web.action.Index;
import it.us.web.action.messaggi.Messaggi;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;


public class LoginNoPassword extends GenericAction {

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
		
		if(cf_spid!=null && !cf_spid.equals("") && !cf_spid.equals("null"))
			utente = UtenteDAO.authenticate( cf_spid, db );
			
		if( utente == null )
		{
			setErrore("Autenticazione fallita");
		}
		else
		{	
			session.setAttribute( "utente", utente );
		}
		
		if(req.getParameter("messaggio_home") != null && req.getParameter("messaggio_home").equals("true")){
			goToAction( new Messaggi());
		}else{
			goToAction( new Index());
		}
	}
}