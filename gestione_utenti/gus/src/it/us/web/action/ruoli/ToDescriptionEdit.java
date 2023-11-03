package it.us.web.action.ruoli;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToDescriptionEdit extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView("AMMINISTRAZIONE", "RUOLI", "EDIT");
		can( gui, "w");
	}

	@Override
	public void execute() throws Exception
	{
		BRuolo ruolo = RuoloDAO.getRuoloByName( stringaFromRequest( "ruolo" ) );
		session.setAttribute( "ruolo", ruolo );
		gotoPage( "/jsp/amministrazione/ruoli/descriptionEdit.jsp" );
	}

}
