package it.us.web.action.ruoli;

import java.util.Vector;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;

public class ToAdd extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "ADD" );
		Permessi.can( utente, gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		Vector<BRuolo> v = RuoloDAO.getRuoli();
		req.setAttribute( "ruoli", v );
		gotoPage( "/jsp/amministrazione/ruoli/add.jsp" );
	}

}
