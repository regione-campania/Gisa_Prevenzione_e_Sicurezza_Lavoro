package it.us.web.action.guc;

import java.util.List;


import it.us.web.action.GenericAction;
import it.us.web.action.Home;
import it.us.web.bean.guc.Utente;
import it.us.web.dao.guc.UtenteGucDAO;
import it.us.web.exceptions.AuthorizationException;

public class Detail extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception
	{
		int id = interoFromRequest("id");
		Utente u = null;
		List<Utente> utentiList = UtenteGucDAO.listaUtentibyId(db, id);//persistence.createCriteria(Utente.class).add(Restrictions.eq("id", id)).list();
		
		if( utentiList.size() > 0 ){
			costruisciListaGestori();
			costruisciListaComuni();
			u = utentiList.get(0);
			req.setAttribute("UserRecord", u);
			gotoPage( "/jsp/guc/detail.jsp" );
			
		}
		else{
			setErrore("Utente con id " + id + " non trovato");
			goToAction(new Home());
		}
		
	}

}
