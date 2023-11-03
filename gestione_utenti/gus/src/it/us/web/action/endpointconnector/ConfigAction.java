package it.us.web.action.endpointconnector;

import java.sql.SQLException;

import it.us.web.action.GenericAction;
import it.us.web.action.Index;
import it.us.web.bean.endpointconnector.EndPointConnectorList;
import it.us.web.db.DbUtil;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.exceptions.NotLoggedException;



public class ConfigAction extends GenericAction
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
		
		EndPointConnectorList listaEndPoint = new EndPointConnectorList();
		listaEndPoint.creaLista(db);
		req.setAttribute("listaEndPoint", listaEndPoint);
		
		gotoPage( "/jsp/endpointconnector/endpointlist.jsp" );
		
	}
	
	public EndPointConnectorList getEndPointConnector()
	{
		EndPointConnectorList listaEndPointConnector = new EndPointConnectorList();
		
		try {
			db = DbUtil.getConnection() ;
		
		listaEndPointConnector.creaLista(db);
		}
		catch (Exception e)
		{
			try {
				DbUtil.close(db);
			} catch (SQLException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			
			req.setAttribute( "errore", e.getMessage() );
			
				try
				{
					GenericAction.goToAction( new Index(), req, res );
				}
				catch (Exception e1)
				{
					e1.printStackTrace();
				}
			
		}
		return listaEndPointConnector;
		
	}
	

}
