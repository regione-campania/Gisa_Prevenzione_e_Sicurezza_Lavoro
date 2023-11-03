package it.us.web.action.utenti;

import it.us.web.action.Action;
import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BUtente;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.util.properties.Message;

import java.sql.Timestamp;

import org.apache.commons.beanutils.BeanUtils;

public class Modify extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "EDIT" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		Action returnAction = null;
		

		BUtente toUpdateUser = UtenteDAO.getUtenteBId(db, interoFromRequest( "id" )); //(BUtente) persistence.find( BUtente.class, interoFromRequest( "id" ) );
		
		BeanUtils.populate( toUpdateUser, req.getParameterMap() );
		
		if( validate( toUpdateUser ) )
		{
			//persistence.update( toUpdateUser );
			//persistence.commit();
	 		
 			returnAction = new Detail();
 			setMessaggio( Message.getSmart( "UTENTE_MODIFICATO" ) );
		}
		else
		{
			setErrore( "ERRORE_AGGIORNAMENTO_UTENTE" );
			returnAction = new ToModify();
		}

 		req.setAttribute( "userDetail", toUpdateUser );
		goToAction( returnAction );
	}

	/**
	 * controlla che i valori passati siano corretti e imposta i dati di sistema 
	 * @param newUser
	 * @return
	 */
	private boolean validate(BUtente newUser)
	{
		boolean ret = true;
		
//		BUtente oldUser = (BUtente) GenericHibernateDAO.find( BUtente.class, newUser.getId() );
//		
//		newUser.setPassword( oldUser.getPassword() );
//		newUser.setDomanda_segreta( newUser.getDomanda_segreta() );
//		newUser.setRisposta_segreta( oldUser.getRisposta_segreta() );
//		newUser.setEntered_by( oldUser.getEntered_by() );
//		newUser.setEntered( oldUser.getEntered() );
		newUser.setModifiedBy( (int)utente.getId() );
		newUser.setModified( new Timestamp( System.currentTimeMillis() ) );
		
		return ret;
	}

}
