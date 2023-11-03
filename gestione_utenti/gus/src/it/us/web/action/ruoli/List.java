package it.us.web.action.ruoli;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;

import java.util.Vector;

public class List extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "MAIN" );
		can( gui, "r" );
	}

	@Override
	public void execute() throws Exception
	{
		Vector<BRuolo> v = RuoloDAO.getRuoli();
		req.setAttribute( "ruoli", v );
		gotoPage( "/jsp/amministrazione/ruoli/list.jsp" );
	}

}
