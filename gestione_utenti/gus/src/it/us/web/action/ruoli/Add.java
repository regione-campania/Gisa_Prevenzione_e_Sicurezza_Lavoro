package it.us.web.action.ruoli;

import it.us.web.action.Action;
import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;
import it.us.web.util.properties.Message;

public class Add extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "RUOLI", "ADD" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		Action returnAction = null;
		
		String ruoloDaClonare	= stringaFromRequest( "ruoloDaClonare" );
		String nomeruolo		= stringaFromRequest( "ruolo" );
		String descrizione		= stringaFromRequest( "descrizione" );
		
		if( !verificaCampi( nomeruolo, descrizione ) )
		{
			setErrore( "Inserire ruolo e descrizione" );
			returnAction = new ToAdd();
		}
		else
		{
			//Indica se in fase di creazione bisogna anche  
			//clonare i permessi di un altro ruolo
			boolean clone = false;
			if( !isEmpty( ruoloDaClonare ) )
			{
				clone = true;
			}
			
			//Se non esiste gia'' un ruolo con quel nome
			if( RuoloDAO.getRuoloByName( nomeruolo ) == null )
			{
				RuoloDAO.insertRuolo( nomeruolo, descrizione );
				//Clonazione permessi
				Permessi.createCategory( nomeruolo, clone, ruoloDaClonare );
				setMessaggio( Message.getSmart( "OPERAZIONE_ESEGUITA_CON_SUCCESSO" ) );
			}
			else
			{
				setErrore( Message.getSmart( "RUOLO_GIA'_ESISTENTE" ) + ": " + nomeruolo );
			}
			
			returnAction = new List();
		}
		
		goToAction( returnAction );
		
	}

	private boolean verificaCampi( String nomeruolo, String descrizione )
	{
		return !isEmpty( nomeruolo ) && !isEmpty( descrizione );
	}

}
