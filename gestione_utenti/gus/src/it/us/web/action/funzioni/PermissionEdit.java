package it.us.web.action.funzioni;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;

import java.util.Enumeration;
import java.util.Vector;
 
public class PermissionEdit extends GenericAction
{
	@SuppressWarnings("unchecked")
	public void execute() throws Exception
	{
		Vector<BRuolo> ruoli = RuoloDAO.getRuoli();
		
		Enumeration e = (Enumeration)req.getParameterNames();
		while( e.hasMoreElements() )
		{
			String nome_attributo = (String)e.nextElement();
			if( nome_attributo.length() >= 3 && nome_attributo.substring( 0,3 ).equals( "OG_" ) )
			{
				String cod = null;
				int permesso = new Integer(req.getParameter(nome_attributo));
				
				if( permesso == 0 )
				{
					cod = "r";
				}
				if( permesso == 1 )
				{
					cod = "w";
				}
				
				int id = Integer.parseInt( nome_attributo.substring(3) );
			
				BGuiView gv = GuiViewDAO.getById(id);
				
				for( int i = 0; i < ruoli.size(); i++ )
				{
					String ruolo = stringaFromRequest( ruoli.elementAt(i).getRuolo() );
					if( ruolo != null )
					{
						Permessi.grant2category( gv, ruolo, cod );
					}
				}
			}
		
		}
		
		setMessaggio( "Operazione eseguita con successo" );
		
		goToAction( new ToPermissionEdit() );
		
	}

	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "FUNZIONI", "MAIN" );
		can( gui, "w" );
	}
	
	
	

}
