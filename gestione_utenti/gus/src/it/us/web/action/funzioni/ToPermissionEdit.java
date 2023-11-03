package it.us.web.action.funzioni;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.FunzioneDAO;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;

import java.util.Vector;

	public class ToPermissionEdit
		extends
			GenericAction
	{
		
	public void execute()
		throws
			Exception 
	{
		String 				funzione	= stringaFromRequest( "funzione" );
		Vector<BRuolo>		ruoli		= RuoloDAO.getRuoli();
		Vector<BGuiView>	v2			= null;
		
		if( !isEmpty( funzione ) )
		{
			 v2 = GuiViewDAO.getByFunction( funzione );//null;
		}
		
		req.setAttribute( "funzioni", FunzioneDAO.getFunzioni(  ) );
		
		req.setAttribute( "permessi", v2 );

		req.setAttribute( "ruoli", ruoli );
		
		gotoPage( "/jsp/amministrazione/funzioni/permissionEdit.jsp" );
		
	}
	
	public void can()
		throws
			AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "FUNZIONI", "MAIN" );
		can( gui, "w" );
	}
	
}
