package it.us.web.action.utenti;

import it.us.web.action.Action;
import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.bean.BUtente;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.UtenteDAO;
import it.us.web.exceptions.AuthorizationException;
import it.us.web.permessi.Permessi;
import it.us.web.util.Md5;
import it.us.web.util.properties.Message;

import java.sql.Timestamp;

import org.apache.commons.beanutils.BeanUtils;

public class Add extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView( "AMMINISTRAZIONE", "UTENTI", "ADD" );
		can( gui, "w" );
	}

	@Override
	public void execute() throws Exception
	{
		Action returnAction = null;
		
		BUtente newUser = new BUtente();
		BeanUtils.populate( newUser, req.getParameterMap() );
		newUser.setEnabled(true);
		String validationError = validate( newUser );
		if( validationError == null )
		{
			
			UtenteDAO.insert(db, newUser);
	 		//persistence.insert( newUser );
	 		//persistence.commit();
	 		
	 		if( newUser.getId() > 0 )
	 		{
	 			Permessi.startupUser( newUser );
	 			returnAction = new Detail();// new List();
	 			setMessaggio( Message.getSmart( "UTENTE_AGGIUNTO" ) );
	 		}
	 		else
	 		{
	 			returnAction = new ToAdd();
	 			setErrore( Message.getSmart( "ERRORE_INSERIMENTO_UTENTE" ) );
	 		}
			
		}
		else
		{
			setErrore( validationError );
			returnAction = new ToAdd();
		}

 		req.setAttribute( "userDetail", newUser );
		goToAction( returnAction );
	}
	
	/**
	 * controlla che i valori passati siano corretti e imposta i dati di sistema 
	 * @param newUser
	 * @return
	 */
	private String validate(BUtente newUser)
	{
		String ret = null;
		
		ret = validaBean( newUser );
		
		if( ret == null )
		{
			String password = stringaFromRequest( "password_1" );
			String confirmPassword = stringaFromRequest( "password_2" );
			if( password == null || !password.equals( confirmPassword ) )
			{
				ret = "\nla password e la sua conferma non coincidono";
			}
			else if( password.length() <= 8 )
			{
				ret = "\nlunghezza minima della password 8 caratteri";
			}
			else
			{
				newUser.setPassword( Md5.encrypt( password ) );
			}
		}
		
		if( ret == null )
		{
			newUser.setEntered( new Timestamp( System.currentTimeMillis() ) );
			newUser.setEnteredBy( (int)utente.getId() );
			newUser.setModified( newUser.getEntered() );
			newUser.setModifiedBy( (int)utente.getId() );
		}
		
		return ret;
	}

}
