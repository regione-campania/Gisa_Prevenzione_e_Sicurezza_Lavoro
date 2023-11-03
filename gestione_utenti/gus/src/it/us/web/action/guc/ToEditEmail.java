package it.us.web.action.guc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javassist.bytecode.Descriptor.Iterator;
import it.us.web.action.GenericAction;
import it.us.web.action.Home;
import it.us.web.bean.guc.Asl;
import it.us.web.bean.guc.Utente;
import it.us.web.dao.AslDAO;
import it.us.web.dao.guc.UtenteGucDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToEditEmail extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		int id = interoFromRequest("id");
		Utente u = null;
		
		List<Utente> utentiList = UtenteGucDAO.listaUtentibyId(db, id);
		if( utentiList.size() > 0 )
		{
			u = utentiList.get(0);
			req.setAttribute("UserRecord", u);
			gotoPage( "/jsp/guc/edit_email.jsp" );
			
		}
		else
		{
			setErrore("Utente con id " + id + " non trovato");
			goToAction(new Home());
		}	
	}
}
