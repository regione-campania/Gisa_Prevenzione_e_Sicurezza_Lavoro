package it.us.web.action;

import java.util.ArrayList;

import it.us.web.dao.guc.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;

public class IndexGUC extends GenericAction
{
	
	
	public IndexGUC() {		
	}
	
	@Override
	public void can() throws AuthorizationException
	{

	}

	@Override
	public void execute() throws Exception
	{
		if( utenteGuc == null)
		{
			gotoPage("/jsp/guc/indexguc.jsp" );
		}
		else
		{
			ArrayList<String> endpoints = RuoloDAO.getEndpointByIdUtente(utenteGuc.getId(), db);
			req.setAttribute("endpoints", endpoints);
			gotoPage("/jsp/guc/scelta.jsp" ); 
		}
			
	}

}
