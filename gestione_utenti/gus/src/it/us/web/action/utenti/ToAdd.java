package it.us.web.action.utenti;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.dao.GuiViewDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToAdd extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "ADD" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		req.setAttribute( "modify", false );
		gotoPage( "/jsp/amministrazione/utenti/addModify.jsp" );
	}

}
