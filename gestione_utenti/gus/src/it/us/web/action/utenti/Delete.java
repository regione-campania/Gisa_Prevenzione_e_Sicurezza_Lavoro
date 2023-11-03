package it.us.web.action.utenti;

import java.sql.Timestamp;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BUtente;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;
import it.us.web.util.properties.Message;

public class Delete extends GenericAction
{
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "DELETE" );
		can( gui, "w" );
	}

	public void execute() throws Exception
	{
		
		int id = interoFromRequest( "user_id" );
		BUtente userDetail =  UtenteDAO.getUtenteBId(db, id);//(BUtente) persistence.find( BUtente.class, id );
		userDetail.setEnabled( false );
		userDetail.setModified( new Timestamp( System.currentTimeMillis() ) );
		userDetail.setModifiedBy( (int)utente.getId() );
		
		UtenteDAO.update(db, userDetail);
		//persistence.update( userDetail );
		//persistence.commit();
		Permessi.removeFromAllCategory( userDetail );
		
		setMessaggio( Message.getSmart( "UTENTE_ELIMINATO" ) );
		
		goToAction( new List() );
		
	}
}
