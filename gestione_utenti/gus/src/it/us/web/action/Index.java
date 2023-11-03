package it.us.web.action;

import it.us.web.action.endpointconnector.ConfigAction;
import it.us.web.bean.endpointconnector.EndPointConnectorList;
import it.us.web.exceptions.AuthorizationException;

public class Index extends GenericAction
{
	
	
	public Index() {		
	}
	
	@Override
	public void can() throws AuthorizationException
	{

	}

	public EndPointConnectorList inizializzaEndPointConnector(){
	//Da mettere in session all'avvio?
		  ConfigAction ac = new ConfigAction();
		  EndPointConnectorList listaEndPointConnector = ac.getEndPointConnector();
		  return listaEndPointConnector;
	}

	@Override
	public void execute() throws Exception
	{
		
		req.setAttribute("test", req.getParameter("test"));
		
		System.out.println("GUC *** Costruisco e metto in sessione EndPointConnector.");
		EndPointConnectorList listaEndPointConnector = inizializzaEndPointConnector();
		req.getSession().setAttribute("listaEndPointConnector", listaEndPointConnector);
		System.out.println("GUC *** Messo in sessione EndPointConnector *** size: "+listaEndPointConnector.size());
		
		
		if( utente == null )
		{
			gotoPage("/jsp/guc/index.jsp" );
		}
		else
		{	gotoPage("/jsp/guc/pannello.jsp");
		//	goToAction( new Home() );
		}
		
	}

}
