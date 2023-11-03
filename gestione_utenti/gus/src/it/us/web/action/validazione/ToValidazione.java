package it.us.web.action.validazione;

import it.us.web.action.GenericAction;
import it.us.web.bean.validazione.Richiesta;
import it.us.web.bean.validazione.RichiesteList;
import it.us.web.exceptions.AuthorizationException;

import java.util.ArrayList;



public class ToValidazione extends GenericAction
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
		
		int limit = interoFromRequest("limit"); 
		
		if (limit == -1)
			limit = 200;
		
		req.setAttribute("limit", limit);
		
		ArrayList<Richiesta> listaRichieste = RichiesteList.creaLista(db, limit);
		req.setAttribute("listaRichieste", listaRichieste);
		gotoPage( "/jsp/validazione/richiestelist.jsp" );
		
	}
	

}
