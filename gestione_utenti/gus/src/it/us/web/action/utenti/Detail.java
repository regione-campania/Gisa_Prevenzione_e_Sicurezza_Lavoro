package it.us.web.action.utenti;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BUtente;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;

public class Detail extends GenericAction
{
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "MAIN" );
		can( gui, "r" );
	}

	public void execute() throws Exception
	{
		BUtente userDetail = (BUtente)req.getAttribute( "userDetail" );
		
		if( userDetail == null )
		{
			int id = interoFromRequest( "user_id" );
			userDetail = UtenteDAO.getUtenteBId(db, id) ;//(BUtente) persistence.find( BUtente.class, id );
			req.setAttribute( "userDetail", userDetail );
		}
		
		gotoPage( "/jsp/amministrazione/utenti/detail.jsp" );
		
	}
}
