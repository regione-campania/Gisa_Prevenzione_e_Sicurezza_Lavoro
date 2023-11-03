package it.us.web.action.guc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Logger;

import javassist.bytecode.Descriptor.Iterator;
import it.us.web.action.GenericAction;
import it.us.web.action.Home;
import it.us.web.bean.endpointconnector.EndPoint;
import it.us.web.bean.guc.Asl;
import it.us.web.bean.guc.Utente;
import it.us.web.dao.AslDAO;
import it.us.web.dao.guc.UtenteGucDAO;
import it.us.web.exceptions.AuthorizationException;

public class ToEditProfilo extends GenericAction
{

	
	Logger logger = Logger.getLogger(ToEditProfilo.class);
	@Override
	public void can() throws AuthorizationException
	{
		isLogged();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void execute() throws Exception{
		
		int id = interoFromRequest("id");
		Utente u = null;
		List<Utente> utentiList = UtenteGucDAO.listaUtentibyId(db, id);
		
		
		
		/* lista endpoint */
		ArrayList<EndPoint> endPoints = EndPoint.getListaEndPoint(db, false);
		req.setAttribute("listaEndPoints", endPoints);

		/**
		 * LISTA COMUNI
		 */
		List<String> comuniList = AslDAO.getComuni(db);
		req.setAttribute("comuniList", comuniList);
		
		/**
		 * LISTA ASL
		 */
		List<Asl> aslList = AslDAO.getAsl(db);
		req.setAttribute("aslList", aslList);
		
		/**
		 * LISTA PROVINCE
		 */
		HashMap<String, Integer> HashProvince = costruisciListaProvince();
		req.setAttribute("HashProvince", HashProvince);
		
		if( utentiList.size() > 0 ){
			u = utentiList.get(0);
			req.setAttribute("UserRecord", u);
			
			
			Boolean flag =false ;
			try
			{
				 flag = costruisciListaRuoli();
			}
			catch(Exception e)
			{
				logger.info("Errore Costruzione Ruoli ");
			}
			if (flag==false){
				
				costruisciListaCliniche();
				costruisciListaCaniliBDU();
				costruisciListaImportatori();
				costruisciListaGestori();
				costruisciListaComuni();
				
				
			
				gotoPage( "/jsp/guc/edit_profilo.jsp" );
			} else {
				setErrore("Impossibile procedere. Lista Ruoli non disponibile");
				goToAction(new Home());
			}
		}
		else{
			setErrore("Utente con id " + id + " non trovato");
			goToAction(new Home());
		}	
	}
}
