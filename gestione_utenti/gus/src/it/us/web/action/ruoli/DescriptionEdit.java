package it.us.web.action.ruoli;

import it.us.web.action.GenericAction;
import it.us.web.bean.BGuiView;
import it.us.web.dao.GuiViewDAO;
import it.us.web.dao.RuoloDAO;
import it.us.web.exceptions.AuthorizationException;

public class DescriptionEdit extends GenericAction
{

	@Override
	public void can() throws AuthorizationException
	{
		BGuiView gui = GuiViewDAO.getView("AMMINISTRAZIONE", "RUOLI", "EDIT");
		can( gui, "w");
	}

	@Override
	public void execute() throws Exception
	{
		String nuovaDescrizione = stringaFromRequest( "descrizione" );
		String nomeRuolo = stringaFromRequest( "ruolo" );
		
		String errore = RuoloDAO.modificaDescrizioneRuolo( nuovaDescrizione, nomeRuolo );
		
		if( isEmpty( errore ) )
		{
			setMessaggio( "Descrizione del ruolo modificata" );
		}
		else
		{
			setErrore( errore );
		}
		
		goToAction( new List() );
	}

}
