package it.us.web.action.validazione;

import it.us.web.action.GenericAction;
import it.us.web.bean.validazione.Richiesta;
import it.us.web.exceptions.AuthorizationException;



public class ToRichiesta extends GenericAction
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
		String numeroRichiesta = stringaFromRequest("numeroRichiesta");
		Richiesta ric = new Richiesta(db, numeroRichiesta);
		req.setAttribute("dettaglioRichiesta", ric);
		System.out.println("RIC RECUPERATA - FWD richiesta.jsp");
		gotoPage( "/jsp/validazione/richiesta.jsp" );
		
	}
	

}
