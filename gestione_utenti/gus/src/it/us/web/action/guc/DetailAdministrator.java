package it.us.web.action.guc;

import it.us.web.action.GenericAction;
import it.us.web.bean.BUtente;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAdministrator extends GenericAction
{
	private static final Logger logger = LoggerFactory.getLogger( EditAnagrafica.class );
	
	@Override
	public void can() throws AuthorizationException
	{
			isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		int id = interoFromRequest("id");
		BUtente utente = UtenteDAO.getUtenteBId(db,id); 
		req.setAttribute("UserRecord", utente);
		gotoPage( "/jsp/guc/detailAdministrator.jsp" );
	}
}