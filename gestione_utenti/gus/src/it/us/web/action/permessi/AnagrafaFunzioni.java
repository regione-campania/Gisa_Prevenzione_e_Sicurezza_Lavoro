package it.us.web.action.permessi;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.dao.GuiViewDAO;
import it.us.web.exceptions.AuthorizationException;

public class AnagrafaFunzioni extends GenericAction
{

	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "FUNZIONI", "ANAGRAFA" );
		can( gui, "w" );
	}

	public void execute() throws Exception
	{
		gotoPage( "/jsp/amministrazione/funzioni/startup.jsp" );
	}

}
