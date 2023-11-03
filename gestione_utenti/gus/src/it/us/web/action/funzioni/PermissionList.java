package it.us.web.action.funzioni;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;

import java.util.Vector;

	public class PermissionList
		extends
			GenericAction
	{
		
	public void execute()
		throws
			Exception 
	{
		
		String funzione		= stringaFromRequest( "funzione" );
		String subFunzione	= stringaFromRequest( "subfunzione" );
		String gui			= stringaFromRequest( "gui" );
		
		Vector<BRuolo> ruoli = RuoloDAO.getRuoli();
		BGuiView bGuiView = GuiViewDAO.getView( funzione, subFunzione, gui );
		req.setAttribute( "ruoli", ruoli );
		req.setAttribute( "bGuiView", bGuiView );
		
		gotoPage( "popup", "/jsp/amministrazione/funzioni/permissionList.jsp" );
		
	}
	
	public void can()
		throws
			AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView("AMMINISTRAZIONE", "FUNZIONI", "PERMISSION LIST");
		can( gui, "r" );
	}
	
}
