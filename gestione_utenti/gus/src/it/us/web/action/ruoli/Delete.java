package it.us.web.action.ruoli;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BRuolo;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;
import it.us.web.util.properties.Message;

public class Delete extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "DELETE" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		String nome_ruolo	= stringaFromRequest( "NOME_RUOLO" );		
		BRuolo br			= null;
		
		if( (nome_ruolo == null) || (nome_ruolo.trim().length() == 0) )
		{
			setErrore( Message.getSmart( "PARAMETRI_NON_CORRETTI" ) );
		}
		else
		{
			br = RuoloDAO.getRuoloByName( nome_ruolo );
			
			if( (br == null) || br.isGiaAssegnato() )
			{
				setErrore( Message.getSmart( "AZIONE_NON_CONSENTITA" ) );
			}
			else
			{
				RuoloDAO.delete( nome_ruolo, utente, req );		
				br = RuoloDAO.getRuoloByName( nome_ruolo );
				
				if( br == null )
				{
					Permessi.rimuoviRuolo( nome_ruolo );
					setMessaggio( Message.getSmart( "OPERAZIONE_ESEGUITA_CON_SUCCESSO" ) );
				}
				else
				{
					setErrore( "OPERAZIONE_FALLITA" );
				}
			}
		}
		
		goToAction( new List() );
	}

}
