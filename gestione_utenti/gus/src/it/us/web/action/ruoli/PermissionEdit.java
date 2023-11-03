package it.us.web.action.ruoli;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.dao.GuiViewDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;

import java.util.Enumeration;
 
public class PermissionEdit extends GenericAction
{
	
	@SuppressWarnings("unchecked")
	public void execute() throws Exception
	{
		Enumeration<String> e = (Enumeration<String>)req.getParameterNames();
		String gruppo = stringaFromRequest( "gruppo" );
		while(e.hasMoreElements())
		{
			String nome_attributo = e.nextElement();
			if( nome_attributo.substring(0,3).equals("OG_") )
			{
				String cod = null;
				int permesso = new Integer( stringaFromRequest(nome_attributo) );
				if( permesso == 0 )
				{
					cod = "r";
				}
				if( permesso == 1 )
				{
					cod = "w";
				}
				
				int id = Integer.parseInt( nome_attributo.substring(3) );
				
				BGuiView gv = GuiViewDAO.getById( id );
				
				Permessi.grant2category( gv, gruppo, cod );
			}
			
		}
		
		setMessaggio( "Permessi modificati correttamente" );
		req.setAttribute("NOME_RUOLO",gruppo );
		
		goToAction( new List() );
	}

	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "PERMISSION EDIT" );
		can( gui, "w" );
	}
	
	
	

}
