package it.us.web.action.endpointconnector;

import it.us.web.action.GenericAction;
import it.us.web.bean.endpointconnector.EndPointConnectorList;
import it.us.web.exceptions.AuthorizationException;



public class ConfigActionList extends GenericAction
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
		
		EndPointConnectorList listaEndPoint = (EndPointConnectorList) req.getSession().getAttribute("listaEndPointConnector");
		req.setAttribute("listaEndPoint", listaEndPoint);
		gotoPage( "/jsp/endpointconnector/endpointlist.jsp" );
		
	}
	

}
