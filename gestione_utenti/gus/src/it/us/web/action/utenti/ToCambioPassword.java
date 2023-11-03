package it.us.web.action.utenti;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BUtente;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToCambioPassword extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "CAMBIO PASSWORD" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		int					user_id	= interoFromRequest( "user_id" );
		BUtente				ut		= UtenteDAO.getUtenteBId(db, user_id);	//(BUtente)persistence.find( BUtente.class, user_id );
		
		req.setAttribute( "userDetail", ut );
		
		if( ut == null )
		{
			goToAction( new List() );
		}
		else
		{
			gotoPage( "/jsp/amministrazione/utenti/cambioPassword.jsp" );
		}
	}

}
