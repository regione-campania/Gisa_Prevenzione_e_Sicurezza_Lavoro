package it.us.web.action.utenti;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BUtente;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToModify extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "EDIT" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		
		int id = interoFromRequest( "user_id" );
 		BUtente userDetail =UtenteDAO.getUtenteBId(db, id);	// (BUtente) persistence.find( BUtente.class, id );
		req.setAttribute( "userDetail", userDetail );
		
		req.setAttribute( "modify", true );
		gotoPage( "/jsp/amministrazione/utenti/addModify.jsp" );
	}

}
