package it.us.web.action.xls;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.dao.GuiViewDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;
import it.us.web.util.XlsUtil;
import it.us.web.util.properties.Label;

import java.util.Vector;

import javax.servlet.ServletOutputStream;

public class ListaRuoli extends GenericAction {

	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "MAIN" );
		can( gui, "w" );
	}

	@SuppressWarnings("unchecked")
	public void execute()
		throws
			Exception
	{
		String ruolo	= (String)req.getParameter("ruolo");
		Vector v		= Permessi.getPermissionsOnRuolo( ruolo );
		
		StringBuffer csv = new StringBuffer( "FUNZIONE\tSUBFUNZIONE\tGUIOBJECT\tPERMESSI\n\n" );
		for( int i = 0; i < v.size(); i++ )
		{
			BGuiView g	= (BGuiView)v.elementAt(i);
			String p	= g.getDiritti();
			
			if( (p != null) && p.equalsIgnoreCase( "r" ) )
			{
				p = "ro";
			}
			else if( (p != null) && p.equalsIgnoreCase( "w" ) )
			{
				p = "rw";
			}
			else
			{
				p = "no";
			}
			
			csv.append( Label.get( g.getNome_funzione() ) + "\t"+
						Label.get( g.getNome_subfunzione() ) + "\t" +
						Label.get( g.getNome_gui() ) + "\t" +
						p + "\n" );
		}
		
		
		res.setContentType( "application/vnd.ms-excel" );
		res.setHeader( "Content-Disposition", "inline; filename=\"lista_ruoli.xls\"" );
		
		ServletOutputStream out = res.getOutputStream();

		XlsUtil.write( csv.toString(), out );
		
	}

}
