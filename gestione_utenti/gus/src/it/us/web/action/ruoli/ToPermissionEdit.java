package it.us.web.action.ruoli;

import it.us.web.action.GenericAction;
import it.us.web.bean.BFunzione;
import it.us.web.bean.BGuiView;
import it.us.web.dao.FunzioneDAO;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;

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
		String 				ruolo		= stringaFromRequest( "ruolo" );
		Vector<BGuiView>	v2			= null;
		
		if( !isEmpty( funzione ) )
		{
			if( funzione.equalsIgnoreCase( "tutte" ) )
			{
				v2 = Permessi.getPermissionsOnRuolo( ruolo );
			}
			else
			{
				v2 = Permessi.getPermissionsOnRuolo( ruolo, funzione );
			}
		}

		Vector<BFunzione> funzioni	= FunzioneDAO.getFunzioni();
		req.setAttribute( "funzioni", funzioni );
		req.setAttribute( "permessi", v2 );
		
		req.setAttribute( "ruolo", RuoloDAO.getRuoloByName(ruolo) );
		
		gotoPage( "/jsp/amministrazione/ruoli/permissionEdit.jsp" );
	}
	
	public void can()
		throws
			AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "PERMISSION EDIT" );
		can( gui, "w" );
	}
	
}
